#!/usr/bin/env python3
# =============================================================================
# TP guidé — Affinity Propagation sur le jeu de données Iris (version Python)
# =============================================================================
# Module : Apprentissage non supervisé (URCA, 2026-2027)
# Binôme : Hervé ADJAKOSSA, Marie DE AMORIM PEREIRA DA SILVA
#
# Exécution depuis la racine du dépôt :
#   python3 tp/Application_Iris.py
#
# Prérequis (une seule fois) :
#   pip install scikit-learn numpy
#
# Ce script est le pendant Python de tp/Application_Iris.R. La comparaison est
# volontairement équitable : mêmes données (Iris), même prétraitement
# (standardisation z-score), même similarité (moins la distance euclidienne au
# carré), préférences réglées par quantile comme l'argument q d'apcluster.
# Les étiquettes (species) servent UNIQUEMENT à évaluer les partitions.
#
# Référence de la classe utilisée :
# https://scikit-learn.org/stable/modules/generated/sklearn.cluster.AffinityPropagation.html
# =============================================================================

import sys

import numpy as np
from sklearn.cluster import AffinityPropagation, KMeans
from sklearn.datasets import load_iris
from sklearn.metrics import adjusted_rand_score
from sklearn.preprocessing import StandardScaler

GRAINE = 2026  # random_state fixé : reproductibilité


# -----------------------------------------------------------------------------
# Étape 0 — Chargement et inspection des données
# -----------------------------------------------------------------------------
iris = load_iris()
X = iris.data          # 150 observations, 4 variables numériques
verite = iris.target   # étiquettes (0, 1, 2), réservées à l'évaluation

print("Dimensions :", X.shape)
print("Variables :", list(iris.feature_names))
print("Effectifs par espèce :", np.bincount(verite))

# -----------------------------------------------------------------------------
# Étape 1 — Prétraitement : standardisation (z-score), comme scale() en R
# -----------------------------------------------------------------------------
X_std = StandardScaler().fit_transform(X)

# -----------------------------------------------------------------------------
# Étape 2 — Similarité et balayage de la préférence
# -----------------------------------------------------------------------------
# scikit-learn attend une PREMISE différente d'apcluster : au lieu de fournir
# la matrice de similarité, on passe affinity="precomputed" ou, plus simple,
# on règle la préférence directement. La similarité par défaut de la classe
# AffinityPropagation est déjà la moins distance euclidienne au carré
# (affinity="euclidean"), exactement negDistMat(r = 2) d'apcluster.
#
# Rôle de la préférence s(k, k) : plus elle est élevée, plus chaque
# observation est candidate à devenir son propre exemplaire, et plus AP
# produit de clusters. Pour balayer la préférence comme le fait l'argument q
# d'apcluster, on la fixe ici au quantile q des similarités hors diagonale.

# Matrice de similarité explicite, pour le balayage par quantiles :
diff = X_std[:, np.newaxis, :] - X_std[np.newaxis, :, :]
S = -np.sum(diff ** 2, axis=-1)          # s(i, k) = -||xi - xk||^2
s_hors_diag = S[~np.eye(len(S), dtype=bool)]

q_grid = np.arange(0.0, 1.0 + 1e-9, 0.05)
print("\nquantile_q  nb_clusters  ARI")
for q in q_grid:
    pref = float(np.quantile(s_hors_diag, q))
    ap = AffinityPropagation(preference=pref, damping=0.9,
                             max_iter=1000, convergence_iter=100,
                             random_state=GRAINE)
    labels = ap.fit_predict(X_std)
    k = len(ap.cluster_centers_indices_)
    ari = adjusted_rand_score(verite, labels)
    print(f"{q:9.2f}  {k:11d}  {ari:5.3f}")

# -----------------------------------------------------------------------------
# Étape 3 — AP avec le réglage de référence (préférence médiane)
# -----------------------------------------------------------------------------
pref_med = float(np.median(s_hors_diag))
ap = AffinityPropagation(preference=pref_med, damping=0.9,
                         max_iter=1000, convergence_iter=100,
                         random_state=GRAINE)
labels_ap = ap.fit_predict(X_std)
k_ap = len(ap.cluster_centers_indices_)

print("\n--- AP, préférence médiane, amortissement 0,9 ---")
print("Nombre de clusters trouvés :", k_ap)
print("Exemplaires (indices d'observations réelles) :",
      ap.cluster_centers_indices_)
print("ARI vs espèces :", round(adjusted_rand_score(verite, labels_ap), 3))
print("Itérations :", ap.n_iter_)

# -----------------------------------------------------------------------------
# Étape 4 — Comparaison à k imposé par AP : K-means (K-medoids voir version R)
# -----------------------------------------------------------------------------
# Mêmes données standardisées ; k imposé par AP, pas par les étiquettes.
km = KMeans(n_clusters=k_ap, n_init=25, random_state=GRAINE)
labels_km = km.fit_predict(X_std)

def somme_dist2(X_, centres, idx):
    """Somme des distances euclidiennes au carré aux représentants."""
    return float(np.sum((X_ - centres[idx]) ** 2))

centres_ap = X_std[ap.cluster_centers_indices_]
print("\n--- Comparaison à k imposé par AP (k =", k_ap, ") ---")
print(f"AP      : ARI = {adjusted_rand_score(verite, labels_ap):.3f}, "
      f"somme dist^2 = {somme_dist2(X_std, centres_ap, labels_ap):.1f}")
print(f"K-means : ARI = {adjusted_rand_score(verite, labels_km):.3f}, "
      f"somme dist^2 = {km.inertia_:.1f}")

# -----------------------------------------------------------------------------
# Étape 5 — Effet de l'amortissement (damping) sur la convergence
# -----------------------------------------------------------------------------
# Ce sont les MESSAGES (responsabilités et disponibilités) qui sont amortis,
# pas les préférences. Un amortissement plus élevé évite les oscillations
# numériques mais rallonge la convergence.
for lam in (0.5, 0.7, 0.9):
    ap_l = AffinityPropagation(preference=pref_med, damping=lam,
                               max_iter=3000, convergence_iter=100,
                               random_state=GRAINE)
    lab = ap_l.fit_predict(X_std)
    print(f"damping = {lam:.1f} -> itérations : {ap_l.n_iter_}, "
          f"clusters : {len(ap_l.cluster_centers_indices_)}")

# -----------------------------------------------------------------------------
# Étape 6 — Versions (reproductibilité)
# -----------------------------------------------------------------------------
import sklearn
print("\nPython", sys.version.split()[0],
      "| scikit-learn", sklearn.__version__, "| numpy", np.__version__)
