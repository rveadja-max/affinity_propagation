# Méthodologie — Affinity Propagation

*Rédigé le 2026-11-01. S'appuie sur `questions_recherche.md` et `cadre_theorique.md`. Les citations renvoient aux PDF du dossier de références, à la page du fichier ; elles ont été vérifiées le 2026-11-01.*

## Cadrage

- **Questions :** Q1 à Q5 (`questions_recherche.md`). Q1 et Q2 sont fusionnées.
- **Population :** jeux de données publics, numériques, petits et étiquetés.
- **Contraintes :**
  - code en R (`apcluster`, `cluster`, `stats`) sur un ordinateur portable, sans budget ;
  - TP de 40 min le 05/11/2026 ;
  - rapport le 10/11/2026.

## 1. Approche

- Démarche **quantitative**, sous forme d'**expérience numérique** : on fait varier les réglages des algorithmes sur des données fixes, et on mesure ce qui change.
- Visée **descriptive et comparative**, pas causale.
- AP est déterministe à données et paramètres fixés : la variabilité étudiée vient des réglages.
- **Plan factoriel complet** : tous les niveaux des paramètres sont croisés. Seules les parties aléatoires (départs de K-means, sous-échantillons de Q5) sont répétées.
- **Cadres mobilisés :**
  - p-médiane, pour évaluer et comparer ;
  - max-sum, pour expliquer la convergence ;
  - transition de phase, comme hypothèse **(C)** testée dans Q1.

## 2. Échantillonnage

### a) Choix des jeux de données (choix raisonné)

Critères : publics et documentés, numériques, avec des étiquettes externes légitimes, assez petits pour le TP, et déjà utilisés pour évaluer AP dans le corpus [Periti et al. 2025, p. 14 ; Sinha & Jana 2025, p. 19].

| Jeu | Taille | Source | Remarque |
|---|---|---|---|
| Iris | 150 × 4, 3 classes | `datasets::iris`, intégré à R | jeu facile : il valide la chaîne de traitement, il ne prouve rien |
| Wine | 178 × 13, 3 classes | dépôt UCI, à télécharger | consigner la provenance, la licence (**non vérifiée à ce jour**) et la date de téléchargement |

> **À ne pas utiliser :** le fichier `wine.txt` du dossier d'exemples. D'après son `ReadmeEnglish.txt`, il ne contient que 3 des 13 variables (colonnes 2, 8 et 13 du jeu d'origine).

### b) Grille des paramètres

- Préférence : quantile `q` de 0 à 1 par pas de 0,05, soit 21 valeurs. La médiane (`q = 0,5`) sert de référence.
- Amortissement : λ ∈ {0,5 ; 0,7 ; 0,9}.
- Prétraitement : z-score ou données brutes.

### c) Rééchantillonnage (stabilité, Q5)

- B = 100 sous-échantillons sans remise, chacun de 80 % des observations, avec une graine fixe et nommée.
- Les partitions sont comparées par ARI sur les observations communes à deux sous-échantillons.

## 3. Variables

| Rôle | Variables |
|---|---|
| Facteurs | `q`, λ, méthode (AP, K-means, K-medoids `pam`, hiérarchique de Ward), standardisation |
| Mesures | nombre de clusters ; ARI et NMI par rapport aux étiquettes ; silhouette (jamais seule) ; somme des dissimilarités aux exemplaires (critère du p-médiane) ; itérations ; convergence ; temps de calcul |
| Contrôles | similarité `negDistMat(r = 2)` ; `maxits` et `convits` fixés et rapportés ; graines ; versions de R et des paquets (`sessionInfo()`) |

**Choix de la similarité.**
- Frey & Dueck fixent chaque similarité au négatif de l'erreur quadratique (distance euclidienne au carré) lorsque le but est de minimiser l'erreur quadratique [Frey & Dueck 2007, p. 2]. `apcluster` la fournit sous le nom `negDistMat(r = 2)` [vignette `apcluster avec R.pdf`, p. 6].
- La standardisation évite qu'une variable de grande échelle domine la distance, ce qui est surtout utile pour Wine.

## 4. Procédure par question

| Q | Procédure | Lecture fixée à l'avance |
|---|---|---|
| Q1 + Q2 | Balayage de `q` ; la médiane sert de point de référence | Une plage étroite donnant 3 clusters indique une forte sensibilité. Un saut brusque du nombre de clusters va dans le sens de l'hypothèse de transition (C). |
| Q3 | Pour chaque k obtenu par AP : `pam(k)`, `kmeans(k, nstart = 25)` et `hclust` (Ward) découpé à k, sur les mêmes données standardisées, avec la même dissimilarité (distance euclidienne au carré) | Si `pam` obtient une somme plus basse qu'AP à k égal, la critique de Brusco & Köhn [p. 1] se confirme localement. Le résultat est rapporté quel que soit son sens. |
| Q4 | Préférence fixée, λ variable : itérations, convergence, exemplaires obtenus | Une non-convergence est un résultat : elle n'est ni cachée ni corrigée en silence. |
| Q5 | Rééchantillonnage, AP comparé à K-means, avec et sans standardisation | Description seulement ; à faire s'il reste du temps. |

**Comparaison équitable (Q3).**
- k est **imposé par AP**, et chaque tableau le dit.
- Laisser chaque méthode choisir son k mélangerait deux questions : le choix de k et la qualité de la partition.
- Fixer k = 3 utiliserait les étiquettes pour régler les méthodes, ce qui est une fuite.
- Le rapprochement entre K-medoids et p-médiane est une inférence du projet (C) : il reste à appuyer par une source externe vérifiée.

## 5. Analyse

- **Description** : courbes (nombre de clusters et ARI en fonction de `q`) et tableaux par méthode.
- Parties aléatoires : moyenne, écart-type et intervalle interquartile.
- **Pas de test de significativité.** Avec deux jeux et des algorithmes déterministes, une p-valeur n'aurait pas de sens.
- Les conclusions sont formulées « sur Iris et Wine, dans ces réglages ».

## 6. Validité et fiabilité

| Type | Risque | Parade |
|---|---|---|
| Interne | Fuite d'étiquettes ; prétraitements différents selon les méthodes | Étiquettes réservées à l'évaluation ; un seul pipeline de prétraitement pour toutes les méthodes |
| Construit | L'ARI mesure l'accord avec les classes, pas une « vérité » | Le dire explicitement ; croiser avec le critère du p-médiane et la silhouette |
| Externe | Deux jeux petits et faciles | Aucune généralisation ; section des limites dans le rapport |
| Fiabilité | Résultats non reproductibles | Scripts dans `tp/`, graines nommées, `sessionInfo.txt`, tous les paramètres dans les tableaux |
| Implémentation | Mauvais usage d'`apcluster` | Si une implémentation maison d'AP est écrite, la confronter à `apcluster` |

## 7. Éthique et données

- Aucune donnée personnelle ; jeux publics.
- Provenance et licence de Wine à consigner avant toute redistribution dans `tp/`.

## 8. Calendrier

| Date | Travail | Livrable concerné |
|---|---|---|
| 1er–2 nov. | Scripts de Q1 et Q3 sur Iris | fiche (3 nov.) |
| 3–4 nov. | TP construit sur Q1 et Q4 (Iris), slides | TP, support, dépôt (4 nov.) |
| 5–9 nov. | Wine, Q5 si possible, rédaction | rapport (10 nov.) |

## Points ouverts

- Licence du jeu Wine d'UCI : à vérifier.
- Lien K-medoids ↔ p-médiane : à appuyer par une source externe vérifiée.
- `lam` et `maxits` d'`apcluster` : non documentés dans le dossier, à citer depuis `?apcluster`.
