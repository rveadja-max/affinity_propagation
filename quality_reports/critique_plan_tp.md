# Plan du TP (40 min, Iris)
> Keywords: TP, apcluster, Iris, préférence q, amortissement lam, reproductibilité, seed, fuite d'étiquettes, déroulé
Iteration: 1

Sources du « plan » : il n'existe pas de document de TP. Le plan est reconstitué à partir de `tp/Application_Iris.R`, de `analyse_litterature/methodologie.md:103` (« TP construit sur Q1 et Q4 (Iris) ») et de `README.md:18` et `:59-65`.

## Table des remarques

1. Plan absent - pas de déroulé minuté pour 40 min (CONFIRMED)
2. Script - il s'arrête avant l'appel à AP (CONFIRMED)
3. Q1 préférence - très démonstratif, mesures à l'appui (CONFIRMED)
4. Q4 amortissement - peu démonstratif sur Iris (CONFIRMED)
5. Fuite d'étiquettes - choisir q pour obtenir 3 clusters (CONFIRMED)
6. Reproductibilité - pas de seed ni de sessionInfo (CONFIRMED)
7. Exploration - les graphiques par variable sont peu informatifs (CONFIRMED)
8. Installation - risque en direct avec la promo (UNVERIFIED)
9. Comparaison - aucune méthode de référence dans le TP (CONFIRMED)

## Summary

- Le TP n'a ni déroulé ni objectifs écrits. Le script ne contient que le chargement et la standardisation des données.
- Les mesures locales montrent que la préférence (Q1) est le meilleur levier pédagogique et l'amortissement (Q4) le plus faible sur Iris.
- Risque principal en séance : l'installation du paquet sur les machines des étudiants.
- 8 remarques CONFIRMED, 1 UNVERIFIED.
- Chiffres produits localement avec R 4.6.1, apcluster 1.4.14, `scale(iris[, 1:4])`, `negDistMat(r = 2)`. Ils ne sont pas encore produits par un script du dépôt : ne pas les recopier dans un livrable avant que le script du TP les régénère.

---

## Plan absent

Confidence: CONFIRMED

Description:
Rien ne décrit le déroulé de la séance : objectifs, étapes, durée de chaque étape, sorties attendues, questions posées aux étudiants. Pour 40 minutes en direct avec toute la promo, c'est le principal risque. C'est aussi ce que l'évaluation de l'oral regardera.

Evidence:
Aucun fichier de TP hors `tp/Application_Iris.R` (24 lignes) ; `methodologie.md:103` mentionne seulement « TP construit sur Q1 et Q4 ».

Suggested Solution:
Écrire un `tp/plan_tp.md` minuté, par exemple :
- 0-5 min : installation et chargement
- 5-10 min : exploration
- 10-20 min : premier lancement d'AP et lecture des exemplaires
- 20-30 min : balayage de q
- 30-37 min : comparaison avec K-means à k égal
- 37-40 min : synthèse

Chaque étape indique la sortie attendue et une question à poser à la salle.

---

## Script - pas d'appel à AP

Confidence: CONFIRMED

Description:
Le script s'arrête sur un commentaire. Le README annonce pourtant `Rscript tp/Application_Iris.R` comme « lancer le TP ».

Evidence:
`tp/Application_Iris.R:24` ; `README.md:59-62`.

Suggested Solution:
Compléter avec, au minimum :

    ```r
    ap <- apcluster(negDistMat(r = 2), data_stand, seed = 1234)
    ap                      # nombre de clusters, exemplaires
    data[ap@exemplars, ]    # les exemplaires sont de vraies fleurs
    ```

Lancer ensuite `review-r` sur le script.

---

## Q1 - préférence

Confidence: CONFIRMED

Description:
Avec les réglages par défaut (q = médiane), AP trouve 9 clusters sur Iris standardisé. Avec q = 0 (minimum des similarités), il en trouve 3, et 5 pour q entre 0,05 et 0,2. C'est un très bon fil conducteur : « le nombre de clusters n'est pas choisi, il découle de la préférence ».

Evidence:
Sortie locale :
- défauts : `k = 9`, 210 itérations
- `q = 0` : k = 3
- `q = 0,05 / 0,1 / 0,15 / 0,2` : k = 5
- `q = 1` : k = 150

Suggested Solution:
Faire de Q1 le cœur du TP : boucle sur `q`, puis courbe du nombre de clusters en fonction de q. Les étudiants prédisent d'abord la tendance, puis observent. Faire générer ces chiffres par le script du TP.

---

## Q4 - amortissement

Confidence: CONFIRMED

Description:
Sur Iris, faire varier `lam` ne change pas la partition, seulement le nombre d'itérations. La démonstration risque de tomber à plat en séance. À noter aussi : le défaut d'`apcluster` est `lam = 0.9`, pas 0,5 comme dans l'article.

Evidence:
- Sortie locale (q = médiane) : `lam` 0,5 -> 9 clusters, 109 itérations ; 0,7 -> 9 clusters, 113 itérations ; 0,9 -> 9 clusters, 210 itérations.
- `?apcluster` : `lam=0.9`.

Suggested Solution:
Option A : réduire Q4 à 2 minutes (« λ change la vitesse, pas le résultat ici ») et dire au passage que les messages sont amortis, pas les préférences.
Option B : chercher un réglage qui ne converge pas (`lam` bas, `maxits` faible) pour montrer l'utilité de l'amortissement. Ce cas n'est pas encore testé : à vérifier avant de le promettre.

---

## Fuite d'étiquettes

Confidence: CONFIRMED

Description:
Comme q = 0 donne exactement 3 clusters, la tentation est forte de présenter ce réglage comme « le bon ». Ce serait régler AP avec les étiquettes, c'est-à-dire une fuite. Le tableau croisé reste intéressant : setosa est parfaitement isolée, versicolor et virginica se mélangent.

Evidence:
Sortie locale avec `q = 0`, exemplaires 8, 56 et 140. Clusters en ligne, espèces en colonne (setosa / versicolor / virginica) :

| Cluster (exemplaire) | setosa | versicolor | virginica |
|---|---|---|---|
| 8 | 50 | 0 | 0 |
| 56 | 0 | 41 | 15 |
| 140 | 0 | 9 | 35 |

Suggested Solution:
Dans le TP, choisir q avant de regarder les espèces, avec un critère annoncé à l'avance. Ne sortir `table(ap, iris$Species)` qu'à la fin, comme évaluation externe, en disant clairement : « on n'a pas utilisé ces étiquettes pour régler AP ».

---

## Reproductibilité

Confidence: CONFIRMED

Description:
`apcluster` ajoute un bruit aléatoire à la similarité si `seed` n'est pas fixé. Le script ne fixe aucune graine et n'enregistre pas les versions. Les étudiants risquent alors de ne pas retrouver les mêmes exemplaires que vous à l'écran.

Evidence:
`?apcluster` (arguments `nonoise` et `seed`) ; `tp/Application_Iris.R` (aucun `seed`, `set.seed` ni `sessionInfo`).

Suggested Solution:
Passer `seed = 1234` à chaque appel d'`apcluster`, `set.seed(1234)` avant `kmeans`, et `sessionInfo()` en fin de script. Lancer `capture-environment` avant diffusion (te demander avant `renv`).

---

## Exploration

Confidence: CONFIRMED

Description:
`plot()` sur un vecteur trace la valeur en fonction du numéro de ligne. Comme `iris` est trié par espèce, ces graphiques montrent surtout les paliers des espèces, et donc les étiquettes dès le début. Ils n'aident pas à comprendre la notion de similarité.

Evidence:
`tp/Application_Iris.R:14-17`.

Suggested Solution:
Remplacer par `pairs(data_stand)` sans couleur, puis le même graphique coloré par cluster AP après le clustering. Montrer les espèces seulement à l'étape d'évaluation.

---

## Installation en séance

Confidence: UNVERIFIED

Description:
`install.packages("apcluster")` est commenté et laissé aux étudiants. Il n'a pas été vérifié que l'installation passe sur leurs machines : versions de R, Windows sans outils de compilation, réseau de la salle. Si 5 minutes y passent, le TP déborde.

Evidence:
`tp/Application_Iris.R:4`. Non vérifié : aucun test sur machine étudiante ou sur un R vierge.

Suggested Solution:
Annoncer le prérequis dans la fiche du 03/11 (« installer apcluster avant la séance »). Tester l'installation sur un R propre. Prévoir un plan B, comme un lien vers le HTML du TP déjà exécuté.

---

## Comparaison

Confidence: CONFIRMED

Description:
Le cadrage demande une comparaison avec d'autres méthodes, et l'oral portera aussi sur la pratique. Or le TP prévu (Q1 + Q4) n'en contient aucune. Une comparaison courte à k égal suffirait à montrer la différence entre exemplaire et centroïde, qui est le message central d'AP.

Evidence:
`Affinity Propagation.md:28` ; `analyse_litterature/methodologie.md:103`.

Suggested Solution:
Après Q1, prendre le k d'AP et lancer `kmeans(data_stand, centers = k, nstart = 25)`. Mettre côte à côte les centroïdes (points fictifs) et les exemplaires d'AP (fleurs réelles, `data[ap@exemplars, ]`). Remplacer la majeure partie de Q4 par ce passage.
