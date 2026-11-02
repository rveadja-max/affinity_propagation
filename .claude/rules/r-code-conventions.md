---
paths:
  - "tp/**/*.R"
  - "tp/**/*.qmd"
  - "rapport/**/*.R"
  - "rapport/**/*.qmd"
  - "slides/**/*.qmd"
---

# Conventions de code R — projet Affinity Propagation

> Adapté de `claude-code-my-workflow` (Pedro H. C. Sant'Anna, licence MIT) pour un projet de
> clustering en R. Les sections économétriques (estimands, Beamer, RDS) ont été retirées.

## 1. Reproductibilité
- `set.seed()` appelé une seule fois en tête de script (format AAAAMMJJ), jamais dans une boucle.
  Exception : un appel par méthode stochastique comparée (K-means, bootstrap) si la graine est
  la même constante nommée pour toutes.
- Paquets chargés en tête par `library()` (jamais `require()`), avec en commentaire la ligne
  `install.packages()` nécessaire pour un étudiant.
- Chemins relatifs au dossier du livrable ; dossiers de sortie créés par
  `dir.create(..., recursive = TRUE)`.
- Le script tourne par `Rscript` sur une machine propre, en moins de quelques minutes (TP de 40 min).
- Consigner `sessionInfo()` (ou `packageVersion("apcluster")`) dans les sorties.

## 2. Conception des fonctions
- `snake_case`, motif verbe-nom (`construire_similarite`, `lancer_ap`).
- Documentation de style roxygen pour toute fonction non triviale.
- Paramètres par défaut explicites, pas de nombres magiques (préférence, `lam`, `maxits`,
  `convits` nommés).
- Retours nommés (listes ou data frames).

## 3. Exactitude du domaine (Affinity Propagation)
- **Aucune fuite d'étiquettes** : la variable de référence (ex. `iris$Species`) n'entre jamais
  dans la matrice de similarité ni dans un prétraitement ; elle ne sert qu'à l'évaluation
  externe (ARI/NMI).
- **Similarité explicite** : la fonction utilisée est nommée et justifiée (ex.
  `negDistMat(r = 2)` = négatif de la distance euclidienne au carré).
- **Préférence explicite** : toujours fixer et rapporter `q` (quantile) ou `p` ; ne jamais
  laisser le défaut implicite. Rappeler que le nombre de clusters en dépend.
- **Amortissement et convergence** : rapporter `lam`, `maxits`, `convits`, et vérifier/afficher
  si l'algorithme a convergé (avertissement de non-convergence = résultat à signaler).
- **Exemplaires** : ce sont des observations réelles (indices dans les données), à ne pas
  confondre avec des centroïdes.
- **Comparaison équitable** : K-means, K-medoids (`cluster::pam`) et hiérarchique reçoivent
  exactement les mêmes données prétraitées ; leurs paramètres (k, `nstart`, linkage) sont
  explicites ; un k imposé égal à celui d'AP est dit comme tel.
- **Métriques** : silhouette jamais seule ; ARI/NMI seulement avec des étiquettes légitimes.
- **Sensibilité** : balayage de la préférence (et de `lam`) avec tous les résultats conservés,
  y compris défavorables à AP.

## 4. Figures
- `ggplot2` ou graphiques de base, une seule convention par livrable.
- Titres d'axes en français, unités indiquées, police lisible en projection (`base_size >= 14`
  pour les slides).
- Dimensions explicites dans `ggsave()` (`width`, `height`).
- Palette accessible (daltonisme) ; pas de couleur seule pour coder les clusters si possible
  (ajouter des formes).

## 5. Pièges connus
| Piège | Conséquence | Prévention |
|---|---|---|
| Étiquettes dans les données de clustering | Fuite, résultats invalides | Sélectionner explicitement les colonnes numériques |
| Préférence par défaut non rapportée | Nombre de clusters inexplicable | Fixer `q`/`p` et l'afficher |
| Variables non standardisées | Une variable domine la distance | `scale()` justifié et documenté |
| Non-convergence ignorée | Exemplaires instables | Vérifier la convergence, augmenter `maxits`/`lam` |
| Matrice dense O(n²) | Mémoire saturée sur grands jeux | Limiter n ou utiliser une matrice creuse/`apclusterL` |
| Chemins absolus | Script cassé chez les étudiants | Chemins relatifs |

## 6. Discipline numérique
- Pas d'égalité `==` sur des réels : `all.equal()` ou `abs(a - b) < tol`.
- Entiers littéraux pour les comptes (`1L`).
- Pré-allouer les vecteurs avant les boucles.
- `na.rm = TRUE/FALSE` explicite.
- `TRUE`/`FALSE`, jamais `T`/`F`.
- Lignes ≤ 100 caractères, sauf formule mathématique commentée (ex. mises à jour de r(i,k), a(i,k)).

## 7. Liste de contrôle
```
[ ] library() en tête, install.packages() indiqué
[ ] set.seed() unique et nommé
[ ] Chemins relatifs
[ ] Étiquettes exclues du clustering
[ ] Similarité, préférence, lam, maxits, convits explicites et rapportés
[ ] Convergence vérifiée
[ ] Comparateurs sur les mêmes données, paramètres explicites
[ ] Fonctions documentées, commentaires qui expliquent le pourquoi
[ ] sessionInfo() consigné
```
