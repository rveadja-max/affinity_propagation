# ADR-0003 : Comparaison à k fixé égal à celui d'AP, sur la même dissimilarité

**Date** : 2026-11-01
**Statut** : proposé
**Décideurs** : Hervé ADJAKOSSA (avec Claude)

## Contexte
Le cadrage exige une comparaison équitable avec K-means, K-medoids et/ou le hiérarchique. AP ne prend pas k en entrée, alors que ces concurrents l'exigent. Brusco & Köhn (p. 1) comparent AP à une heuristique du p-médiane sur le même critère.

## Décision
Pour chaque k produit par AP, nous lançons `cluster::pam(k)`, `kmeans(k, nstart = 25)` et `hclust` (Ward) découpé à k. Toutes les méthodes reçoivent les mêmes données standardisées (ADR-0002) et la même dissimilarité (distance euclidienne au carré). Critères : somme des dissimilarités aux exemplaires, ARI, NMI, silhouette, temps. Le fait que k soit imposé par AP est écrit dans chaque tableau.

## Alternatives considérées

### Chaque méthode choisit son propre k (coude, silhouette)
- **Avantages** : chaque méthode est « au mieux ».
- **Inconvénients** : on compare alors deux choses à la fois, le choix de k et la qualité de la partition.
- **Pourquoi pas** : rend la comparaison ininterprétable.

### k égal au nombre de classes (3)
- **Avantages** : simple.
- **Inconvénients** : utilise l'information des étiquettes pour régler les méthodes, ce qui est une fuite.
- **Pourquoi pas** : interdit par les règles du projet.

## Conséquences
### Positives
- Comparaison sur le critère que les deux familles optimisent (cadre p-médiane).
### Négatives
- Le lien K-medoids ↔ p-médiane est une inférence du projet (C), à appuyer par une source externe vérifiée.
### Risques
- AP peut être battu → le résultat est rapporté tel quel.
