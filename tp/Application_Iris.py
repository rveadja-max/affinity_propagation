# Application de l'algorithme Affinity Propagation sur le jeu de données pédagogique "Iris"
# Traduction Python (scikit-learn) du script Application_Iris.R, avec la même structure.
#
# Dépendances (ligne suivante à exécuter la première fois) :
# pip install scikit-learn pandas matplotlib

from itertools import combinations

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from sklearn.cluster import AffinityPropagation, KMeans
from sklearn.datasets import load_iris
from sklearn.metrics import euclidean_distances

# ---------------------------------------------------------------------------
# Petites utilitaires (répliquent les fonctions du package R `apcluster`)
# ---------------------------------------------------------------------------


def negDistMat(x, r=2):
    """Similarité : opposé de la distance euclidienne élevée à la puissance r.

    Équivalent de ``negDistMat(x, r)`` du package R `apcluster`.
    Avec ``r = 2`` : s(i, k) = -||x_i - x_k||^2, la similarité de
    l'article original de Frey et Dueck (2007).

    Parameters
    ----------
    x : ndarray de forme (n_echantillons, n_variables)
        Observations (les lignes sont les échantillons).
    r : float, defaut=2
        Puissance appliquée à la distance euclidienne.

    Returns
    -------
    ndarray de forme (n_echantillons, n_echantillons)
        Matrice de similarités (valeurs négatives ou nulles).
    """
    return -(euclidean_distances(x) ** r)


def preferenceRange(s):
    """Plage de préférences raisonnables (équivalent de ``preferenceRange``).

    Renvoie une borne basse (qui conduirait à un ou deux groupes) et une
    borne haute (qui conduirait à autant de groupes que d'observations).
    La fonction exacte du package R est écrite en C ; elle est ici
    approchée par le minimum et la médiane des similarités hors diagonale.

    Parameters
    ----------
    s : ndarray de forme (n, n)
        Matrice de similarités.

    Returns
    -------
    tuple (borne_basse, borne_haute)
    """
    valeurs = s[np.triu_indices_from(s, k=1)]
    return float(np.min(valeurs)), float(np.median(valeurs))


def apclusterK(s, K, prc=10, bimaxit=20, maxits=200, convergence_iter=15,
               damping=0.5, random_state=None, verbose=True):
    """Affinity Propagation pour un nombre de groupes cible K.

    Réplique la logique de ``apclusterK()`` du package R `apcluster` :
    ajustement itératif de la préférence par recherche dichotomique dans
    la plage fournie par ``preferenceRange()``, jusqu'à obtenir un nombre
    de groupes proche de K (à ``prc`` pour cent près).

    Parameters
    ----------
    s : ndarray de forme (n, n)
        Matrice de similarités.
    K : int
        Nombre de groupes souhaité.
    prc : float, defaut=10
        Tolérance : on s'arrête si le nombre de groupes ne s'écarte pas
        de plus de ``prc`` % de K.
    bimaxit : int, defaut=20
        Nombre maximal d'étapes de dichotomie.
    maxits, convergence_iter, damping : paramètres transmis à
        ``AffinityPropagation``.
    random_state : int ou None
        Graine aléatoire pour la reproductibilité.
    verbose : bool, defaut=True
        Affiche la progression de la recherche.

    Returns
    -------
    AffinityPropagation ajusté sur la matrice de similarités.
    """
    n = s.shape[0]
    if K < 2 or K >= n:
        raise ValueError(
            f"Nombre d'échantillons = {n}. Plage pertinente pour K : 2 à {n - 1}."
        )

    lopref, hipref = preferenceRange(s)
    lok, hik = 1, n

    # Essai préalable pour resserrer la borne basse (comme dans apclusterK)
    ex = -3
    dn = False
    tmpk = 0
    while not dn:
        tmppref = hipref - 10.0**ex * (hipref - lopref)
        if verbose:
            print(f"Essai p = {tmppref}")
        modele = AffinityPropagation(
            damping=damping, max_iter=maxits, convergence_iter=convergence_iter,
            preference=tmppref, affinity="precomputed",
            random_state=random_state,
        ).fit(s)
        tmpk = len(modele.cluster_centers_indices_)
        if verbose:
            print(f"   Nombre de groupes : {tmpk}")
        if 0 < tmpk < K:
            lok, lopref = tmpk, tmppref
            dn = True
        elif ex == -1:
            dn = True
        else:
            ex += 1

    # Recherche dichotomique
    ntries = 0
    while (abs(tmpk - K) * 100 / K) > prc and ntries < bimaxit:
        ntries += 1
        tmppref = (lopref + hipref) / 2
        if verbose:
            print(f"Essai p = {tmppref} (étape de dichotomie n° {ntries})")
        modele = AffinityPropagation(
            damping=damping, max_iter=maxits, convergence_iter=convergence_iter,
            preference=tmppref, affinity="precomputed",
            random_state=random_state,
        ).fit(s)
        tmpk = len(modele.cluster_centers_indices_)
        if verbose:
            print(f"   Nombre de groupes : {tmpk}")
        if K > tmpk:
            lopref, lok = tmppref, tmpk
        else:
            hipref, hik = tmppref, tmpk

    if verbose:
        print(f"\nNombre de groupes : {tmpk} pour p = {tmppref}")
    if (abs(tmpk - K) * 100 / K) > prc:
        print(
            "Avertissement : nombre de groupes hors de la plage souhaitée ; "
            "augmenter 'bimaxit' pour améliorer la précision de la dichotomie."
        )
    return modele


# ---------------------------------------------------------------------------
# Début du script (même structure que Application_Iris.R)
# ---------------------------------------------------------------------------

# chargement du dataset
iris = load_iris()
data = pd.DataFrame(iris.data, columns=iris.feature_names)
data["Species"] = pd.Categorical.from_codes(iris.target, iris.target_names)
print(data.shape)   # dim(data)
print(data.head())  # head(data)
print(data.describe(include="all"))  # summary(data)

# exploration visuelle du jeu de données
colonnes = ["petal width (cm)", "petal length (cm)",
            "sepal width (cm)", "sepal length (cm)"]
fig, axes = plt.subplots(2, 2, figsize=(10, 7))
for ax, col in zip(axes.ravel(), colonnes):
    ax.plot(data[col], ".", markersize=4)
    ax.set_title(col)
    ax.set_xlabel("Indice de l'observation")
fig.suptitle("Exploration visuelle du jeu de données Iris")
fig.tight_layout()

# préparation du dataset
data_ap = data.iloc[:, 0:4].to_numpy()
data_especes = data["Species"]

# Construire la matrice de similarité et la vérifier
matrice_similarites = negDistMat(data_ap, r=2)
print(matrice_similarites[:5, :5])                       # [1:5, 1:5]
print(matrice_similarites.shape)                         # dim
print(np.allclose(matrice_similarites, matrice_similarites.T))  # isSymmetric
print(np.diag(matrice_similarites)[:6])                  # head(diag(...))

# Fixer une graine aléatoire pour rendre les résultats reproductibles
np.random.seed(123)

# 1) Appliquer Affinity Propagation avec les paramètres "classiques"
# (préférence = médiane des similarités par défaut ; damping aligné sur
#  lam = 0.9 du script R)
resultat_ap = AffinityPropagation(
    damping=0.9,            # coefficient d'amortissement (lam en R)
    max_iter=1000,          # nombre maximal d'itérations (maxits)
    convergence_iter=100,   # itérations sans changement pour la convergence (convits)
    random_state=123,       # graine aléatoire (seed)
).fit(data_ap)              # similarité euclidienne négative au carré (défaut)

print(resultat_ap)
groupes_ap = resultat_ap.labels_
print(pd.Series(groupes_ap).value_counts().sort_index())  # table(groupes_ap)
# Afficher les fleurs correspondant aux exemplaires
print(data.iloc[resultat_ap.cluster_centers_indices_])

# Visualiser les groupes et leurs exemplaires (équivalent de
# plot(resultat_ap, data_ap)) : nuages de points pour chaque paire de
# variables, exemplaires entourés.
paires = list(combinations(range(4), 2))
fig, axes = plt.subplots(2, 3, figsize=(13, 8))
noms = iris.feature_names
exemplaires = set(resultat_ap.cluster_centers_indices_)
for ax, (i, j) in zip(axes.ravel(), paires):
    ax.scatter(data_ap[:, i], data_ap[:, j], c=groupes_ap, cmap="tab10", s=15)
    for e in exemplaires:
        ax.plot(data_ap[e, i], data_ap[e, j], "o", ms=14, mfc="none",
                mec="k", mew=1.5)
    ax.set_xlabel(noms[i])
    ax.set_ylabel(noms[j])
fig.suptitle("Affinity Propagation sur Iris : groupes et exemplaires")
fig.tight_layout()

# 2) Appliquer Affinity Propagation : test de l'importance du paramètre p
# (preference)

# Déterminer une plage de préférences
plage_preference = preferenceRange(matrice_similarites)
print(plage_preference)

# Tester différentes valeurs de préférence
preferences = np.linspace(
    start=min(plage_preference), stop=max(plage_preference), num=10
)

# Appliquer Affinity Propagation pour chaque préférence
resultats_preference = []
for p in preferences:
    resultats_preference.append(
        AffinityPropagation(
            damping=0.9, max_iter=1000, convergence_iter=100,
            preference=float(p), affinity="precomputed", random_state=123,
        ).fit(matrice_similarites)
    )
# Afficher le nombre de groupes obtenus pour chaque préférence
for p, res in zip(preferences, resultats_preference):
    print(f"Préférence : {p:.6g} - "
          f"Nombre de groupes : {len(np.unique(res.labels_))}")

# 3) Appliquer Affinity Propagation : test de l'importance du paramètre lam
# (amortissement)
# Définir différentes valeurs d'amortissement
valeurs_lam = [0.6, 0.75, 0.9, 0.95]

# Appliquer Affinity Propagation pour chaque valeur
resultats_lam = []
for lam in valeurs_lam:
    resultats_lam.append(
        AffinityPropagation(
            damping=lam, max_iter=1000, convergence_iter=100,
            random_state=123,
        ).fit(data_ap)
    )

# Afficher le nombre de groupes obtenus
for lam, res in zip(valeurs_lam, resultats_lam):
    print(f"Amortissement : {lam} - "
          f"Nombre de groupes : {len(np.unique(res.labels_))}")

# 4) comparaison avec K-Means 3 groupes
resultat_kmeans = KMeans(n_clusters=3, random_state=123, n_init=10).fit(data_ap)

groupes_kmeans = resultat_kmeans.labels_
print(pd.Series(groupes_kmeans).value_counts().sort_index())

# 5) Appliquer Affinity Propagation en recherchant trois groupes
# (équivalent de apclusterK() : préférence ajustée par dichotomie)
resultat_ap3 = apclusterK(
    matrice_similarites, K=3,
    maxits=1000, convergence_iter=100, damping=0.9, random_state=123,
)

groupes_ap3 = resultat_ap3.labels_
print(pd.Series(groupes_ap3).value_counts().sort_index())

# 6) comparaison des méthodes
# Affinity Propagation : classique
print("Affinity Propagation : classique")
print(pd.crosstab(pd.Series(groupes_ap, name="Groupes"),
                  pd.Series(data_especes, name="Especes")))

# Affinity Propagation : trois groupes
print("\nAffinity Propagation : trois groupes")
print(pd.crosstab(pd.Series(groupes_ap3, name="Groupes"),
                  pd.Series(data_especes, name="Especes")))

# K-means
print("\nK-means")
print(pd.crosstab(pd.Series(groupes_kmeans, name="Groupes"),
                  pd.Series(data_especes, name="Especes")))

plt.show()

# Affichage des versions pour la reproductibilité
import sklearn  # noqa: E402

print("\n--- Environnement ---")
print(f"Python        : {__import__('sys').version.split()[0]}")
print(f"scikit-learn  : {sklearn.__version__}")
print(f"numpy         : {np.__version__}")
print(f"pandas        : {pd.__version__}")
print(f"matplotlib    : {plt.matplotlib.__version__}")
