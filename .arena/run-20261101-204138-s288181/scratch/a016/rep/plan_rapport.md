# Plan du rapport (10–20 pages)

## Titre proposé
**Affinity Propagation : sélection d'exemplaires, sensibilité aux similarités et comparaison empirique sur un cas concret**

## Question de recherche
Dans quelles conditions Affinity Propagation sélectionne-t-il des exemplaires utiles et des clusters interprétables, et comment ses résultats varient-ils selon la similarité, la préférence et la méthode de référence ?

## Plan calibré (environ 15 pages hors bibliographie/annexes)

1. **Introduction et problématique** (1 p.) — problème pratique, intérêt des exemplaires, question, contributions.
2. **Positionnement dans la classification non supervisée** (1 p.) — clustering, distinction entre AP, K-means, K-medoids, hiérarchique.
3. **Fondements mathématiques** (3 p.) — matrice S, préférence diagonale, exemplaires, fonction objectif, responsabilités r(i,k), disponibilités a(i,k), amortissement et arrêt.
4. **Paramètres et limites** (1 p.) — choix de similarité, préférence, complexité mémoire O(n²) pour une matrice dense, convergence, sensibilité et données volumineuses.
5. **Cas d'étude et données** (1–2 p.) — source, provenance, unités, nettoyage, descriptif, question appliquée.
6. **Protocole expérimental** (2 p.) — pipeline, variantes de préférence, métriques, comparateurs, environnement et reproductibilité.
7. **Résultats** (2–3 p.) — nombre de clusters, exemplaires, métriques, temps, graphiques et analyses de sensibilité.
8. **Discussion critique** (1–2 p.) — ce que les résultats autorisent à conclure, limites, comparaison à la littérature.
9. **Ouverture : ichéité et idéité** (0,5–1 p.) — analogie conceptuelle prudente : observations réelles comme exemplaires ; singularité dépendante des variables et de la similarité ; pas de mesure philosophique automatique.
10. **Conclusion** (0,5 p.) — réponse à la question, limites et suite.
11. **Bibliographie** — références vérifiées, DOI et accès.

## Cas pratiques candidats

- **Combustion / sélection de conditions expérimentales** : Wang et al. (2024), DOI 10.1016/j.combustflame.2023.113121. Très concret et orienté sélection d'exemplaires ; vérifier l'accès aux données et au code avant de retenir ce cas.
- **Corpus diachronique / changement sémantique** : Periti et al. (2025), DOI 10.1007/s11063-025-11752-y. Permet de discuter des clusters évolutifs ; vérifier les ressources du papier.
- **Détection d'intrusions** : Duan & Zou (2024), DOI 10.7717/peerj-cs.1863. Cas concret avec UCI et NSL-KDD, mais lire la méthode et examiner les métriques avant d'adopter leurs conclusions.
- **TP minimal reproductible** : Iris ou autre petit jeu public étiqueté, uniquement pour apprendre le pipeline et illustrer les métriques ; compléter par un cas appliqué réel.

## Critères de choix final du cas
1. Données téléchargeables et licence claire.
2. Variables et unité d'observation compréhensibles.
3. Code et paramètres accessibles, ou possibilité de reconstruire le protocole.
4. Une question où des représentants réels sont utiles.
5. Comparateurs et métriques pertinents.
6. Taille compatible avec le TP de 40 minutes.

## Articulation « ichéité / idéité »
Présenter cela comme une **lecture interprétative** : les exemplaires AP sont des observations concrètes choisies dans un espace de similarité. Ils peuvent rendre visibles des profils particuliers et faciliter l'inspection des clusters. Toutefois, la singularité obtenue dépend des variables, de la préparation et de la métrique ; l'algorithme ne mesure pas directement l'identité, la valeur ou l'authenticité d'un objet.
