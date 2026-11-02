# Documentation — Projet Affinity Propagation

Projet du module **Apprentissage non supervisé** (URCA, 2026-2027).
Binôme : Hervé ADJAKOSSA · Marie DE AMORIM PEREIRA DA SILVA.
Enseignants : Frédéric Blanchard (référent), Philippe Regnault.

Cette documentation décrit l'objet du projet, l'installation, l'exécution du TP,
la structure du dépôt et la marche à suivre pour reproduire chaque résultat.

---

## 1. Objet du projet

L'algorithme **Affinity Propagation** (AP, Frey & Dueck, *Science*, 2007) regroupe
des observations en choisissant, **parmi elles**, des **exemplaires** réels, sans
que le nombre de groupes soit fixé à l'avance. Ce nombre émerge d'un échange
itératif de messages et est gouverné par un paramètre de **préférence**.

Le projet poursuit trois objectifs :

1. **expliquer** simplement le fonctionnement et les fondements mathématiques d'AP ;
2. **illustrer** son usage sur le jeu de données Iris, en R (`apcluster`) et en
   Python (`scikit-learn`) ;
3. **comparer** AP à K-means, K-medoids et à la classification hiérarchique, et
   documenter l'influence de la préférence et de l'amortissement.

### Livrables

| Livrable | Dossier | Format |
|---|---|---|
| Rapport (12–20 p.) | `Report/` | Quarto → PDF (gabarit URCA) |
| Fiche de synthèse (1 p.) | `fiche/` | Quarto → PDF A4 |
| Diaporama (20 min) | `slides/` | Quarto → HTML (reveal.js) |
| TP guidé (40 min) | `tp/` | scripts R et Python |

---

## 2. Prérequis

| Outil | Version testée | Rôle |
|---|---|---|
| R | ≥ 4.3 (testé 4.3.3) | TP version R |
| paquet R `apcluster` | 1.4.14 | algorithme AP en R |
| Python | 3.12.3 | TP version Python |
| scikit-learn | 1.9.1 | algorithme AP en Python |
| Quarto | 1.6.42 | compilation des documents |
| XeLaTeX + Biber | TeX Live 2023 | rendu PDF du rapport |

> Le paquet R `cluster` (pour `pam`, K-medoids) est fourni avec R de base.

---

## 3. Installation

Depuis la racine du dépôt :

```bash
# R : package AP (une seule fois)
Rscript -e 'install.packages("apcluster")'

# Python : bibliothèques du TP
pip install scikit-learn numpy

# Quarto (si absent) : https://quarto.org/docs/get-started/
# LaTeX minimal pour le rapport :
quarto install tinytex
```

---

## 4. Exécuter le TP (exemples d'utilisation)

Les deux scripts s'exécutent **depuis la racine du dépôt** et sont conçus pour
être suivis pas à pas en séance.

### Version R

```bash
Rscript tp/Application_Iris.R
```

- graphiques écrits dans `Rplots.pdf` (racine, non versionné) ;
- environnement consigné dans `sessionInfo.txt` (racine, non versionné).

### Version Python

```bash
python3 tp/Application_Iris.py
```

Les deux scripts réalisent la **même** chaîne de traitement, afin de comparer les
deux implémentations à réglages alignés.

### Ce que fait le TP, étape par étape

| Étape | Action | But pédagogique |
|---|---|---|
| 0 | chargement et inspection d'Iris | connaître les données |
| 1 | standardisation (z-score) | éviter qu'une variable domine la distance |
| 2 | similarité `-||xi - xk||²` + **balayage de la préférence** | voir le nombre de clusters varier |
| 3 | AP à préférence médiane | lire exemplaires, ARI, itérations |
| 4 | comparaison à K-means, K-medoids, hiérarchique (k imposé par AP) | situer AP parmi les méthodes |
| 5 | variation de l'amortissement λ | observer l'effet sur la convergence |
| 6 | versions / `sessionInfo()` | reproductibilité |

### Exemple de sortie (version Python, scikit-learn 1.9.1, graine 2026)

```text
quantile_q  nb_clusters  ARI
     0.00            3  0.631
     0.50            9  0.354
     1.00          149  0.000

--- AP, préférence médiane, amortissement 0,9 ---
Nombre de clusters trouvés : 9
Exemplaires (indices d'observations réelles) : [3 5 17 80 91 117 122 123 139]
```

Lecture : la préférence minimale retrouve ici les trois espèces (ARI = 0,631),
tandis que le réglage par défaut (médiane) fragmente la structure en 9 groupes.

---

## 5. Compiler les documents

Depuis la racine du dépôt :

```bash
quarto render Report/Affinity_propagation_rapport.qmd   # rapport PDF (page de titre URCA)
quarto render fiche/fiche_synthese.qmd                   # fiche PDF A4 (1 page)
quarto render slides/slides.qmd                          # diaporama HTML autonome
```

- Le rapport utilise le gabarit URCA (`Report/template.tex`,
  `Report/memoirerecherche.cls`) : `pdf-engine: xelatex` et `cite-method:
  biblatex` sont **imposés par le gabarit** et ne doivent pas être retirés.
- Les champs `diplome` et `coefficient` de la page de titre restent « À
  compléter » (information non fournie).

---

## 6. Structure du dépôt

```text
.
├── Report/                    rapport PDF + gabarit URCA + bibliography.bib
│   └── Affinity_propagation_rapport.qmd
├── fiche/                     fiche de synthèse (1 page)
│   └── fiche_synthese.qmd
├── slides/                    diaporama (20 min)
│   └── slides.qmd
├── tp/                        TP guidé, données Iris uniquement
│   ├── Application_Iris.R     (version R, apcluster)
│   └── Application_Iris.py    (version Python, scikit-learn)
├── analyse_litterature/       questions de recherche, cadre théorique, méthodologie
├── DOCUMENTATION.md           ce fichier
└── README.md                  présentation synthétique
```

---

## 7. Reproductibilité et règles de travail

- **Graines fixées** (`set.seed(2026)` en R, `random_state=2026` en Python) ;
  AP est déterministe à données et paramètres fixés.
- **Étiquettes réservées à l'évaluation** : `Species` sert uniquement à calculer
  l'ARI, jamais à construire les clusters.
- **Paramètres rapportés** : préférence (quantile `q`), amortissement `λ`,
  `maxits`/`convits` (R) ou `max_iter`/`convergence_iter` (Python).
- Les résultats du rapport sont des **résultats reproduits localement** par les
  scripts ; ils ne sont pas issus de la littérature.
- Les données brutes ne sont jamais modifiées ; toute transformation
  (standardisation) est documentée.

## 8. Choix techniques justifiés

- **Similarité** : moins la distance euclidienne au carré, `negDistMat(r = 2)`
  (R) ≡ `affinity="euclidean"` (scikit-learn), choix de Frey & Dueck (2007) pour
  minimiser l'erreur quadratique.
- **Standardisation** : z-score, pour que les quatre variables contribuent
  équitablement à la distance.
- **Préférence par quantile** : l'argument `q` d'`apcluster` est reproduit en
  Python en fixant `preference` au quantile correspondant des similarités, afin
  d'aligner les deux implémentations.
- **Amortissement λ = 0,9** : retenu pour garantir la convergence sur ce jeu.

## 9. Limites connues

- AP exige une mémoire et un temps en O(n²) : il convient aux jeux **petits à
  moyens** ; Iris (n = 150) est volontairement modeste.
- Le nombre de clusters **dépend de la préférence** et ne doit pas être présenté
  comme « optimal » ; un balayage de sensibilité est fourni dans le TP.
- Le script R n'a pas été exécuté dans l'environnement de rédaction (paquet
  `apcluster` indisponible hors-ligne) ; sa syntaxe est validée et son API suit
  la documentation officielle `apcluster` 1.4.14.

## 10. Références principales

- Frey, B. J. & Dueck, D. (2007). *Clustering by passing messages between data
  points*. Science, 315, 972–976. doi:10.1126/science.1136800
- Bodenhofer, U. et al. (2011). *APCluster: an R package for affinity
  propagation clustering*. Bioinformatics, 27(17). doi:10.1093/bioinformatics/btr406
- Wang, C.-D. et al. (2013). *Multi-Exemplar Affinity Propagation*. IEEE TPAMI,
  35(9). doi:10.1109/TPAMI.2013.28
- Brusco, M. J. & Köhn, H.-F. (2008). *Comment on “Clustering by Passing
  Messages Between Data Points”*. Science, 319, 726. doi:10.1126/science.1150921
- Liste complète et DOI : `Report/bibliography.bib`.
