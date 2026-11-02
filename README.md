# Affinity Propagation — étude et cas pratique en R et en Python

Projet du module **Apprentissage non supervisé** (URCA, 2026-2027) : étude de l'algorithme
Affinity Propagation (AP), de ses fondements à sa mise en œuvre en R (`apcluster`) et en Python
(scikit-learn), avec comparaison à K-means, K-medoids et au clustering hiérarchique. Les deux
implémentations sont comparées pour juger laquelle est la plus confortable à utiliser.

*Dernière mise à jour : 2026-11-02.*

## Équipe et échéances

- **Binôme :** Hervé ADJAKOSSA · Marie DE AMORIM PEREIRA DA SILVA
- **Enseignants :** Frédéric Blanchard (référent), Philippe Regnault

| Livrable | Dossier | Échéance |
|---|---|---|
| Fiche de synthèse (1 page A4) | `fiche/` | mardi 03/11/2026 |
| Support de présentation (20 min) | `slides/` | mercredi 04/11/2026, 23h59 |
| TP guidé (40 min) | `tp/` | mercredi 04/11/2026, 23h59 |
| Dépôt Git | ce dépôt, branche `main` | mercredi 04/11/2026, 23h59 |
| Rapport PDF Quarto (10–20 p.) | `Report/` | mardi 10/11/2026 (Moodle) |

Oral : jeudi 05/11/2026, 10h00–12h00 (20 min de théorie, 40 min de TP, 1 h de questions).

## Question directrice

Dans quelles conditions Affinity Propagation identifie-t-il des représentants pertinents d'un
jeu de données, et comment les choix de **similarité** et de **préférence** influencent-ils le
nombre, la stabilité et l'interprétabilité des clusters, par rapport à K-means, K-medoids et au
clustering hiérarchique ?

## Organisation

```text
.
├── Report/               rapport PDF (Quarto + gabarit URCA)
│   ├── Affinity_propagation_rapport.qmd
│   ├── bibliography.bib
│   ├── template.tex, memoirerecherche.cls, logoSESGURCA.jpg   gabarit URCA
│   └── plan_rapport.md, recherche_bibliographique.md          notes de travail
├── tp/                   TP en R et en Python, données Iris uniquement
│   ├── Application_Iris.R
│   └── Application_Iris.py
├── fiche/                fiche de synthèse (Quarto → PDF)
├── slides/               support de présentation (Quarto → reveal.js)
└── analyse_litterature/  questions de recherche et analyse du corpus
```

## Prérequis

- **R ≥ 4.3** avec le paquet `apcluster` (testé avec R 4.6.1 et `apcluster` 1.4.14)
- **Python 3** avec scikit-learn, pour la partie Python du TP (testé avec Python 3.12.3 et
  scikit-learn 1.9.1 le 02/11/2026)
- **Quarto ≥ 1.4** (testé avec 1.10.18)
- **Une distribution LaTeX avec XeLaTeX et Biber**, nécessaire au rapport : par exemple TinyTeX, installé avec `quarto install tinytex`

```r
install.packages("apcluster")
```

```bash
pip install scikit-learn
```

Documentation de la classe Python utilisée :
https://scikit-learn.org/stable/modules/generated/sklearn.cluster.AffinityPropagation.html

## Utilisation

**Lancer le TP**, depuis la racine du dépôt :

```bash
Rscript tp/Application_Iris.R      # version R
python3 tp/Application_Iris.py     # version Python
```

Le script R affiche ses graphiques dans `Rplots.pdf`, fichier non versionné.

**Compiler les livrables**, depuis la racine du dépôt :

```bash
quarto render Report/Affinity_propagation_rapport.qmd   # PDF avec page de titre URCA
quarto render fiche/fiche_synthese.qmd                   # PDF A4
quarto render slides/slides.qmd                          # HTML autonome
```

## Documentation

Une documentation complète (objet, installation, exécution du TP pas à pas,
exemples de sortie, reproductibilité) est fournie dans
[`DOCUMENTATION.md`](DOCUMENTATION.md).

## Règles de travail

- **`main` ne reçoit que les livrables finaux**, validés par les deux membres du binôme.
- Chacun travaille sur sa propre branche.
- Les données brutes ne sont jamais modifiées, et toute transformation est documentée.
- Les graines aléatoires, les paramètres d'AP (préférence, amortissement λ) et les versions des paquets sont rapportés pour chaque résultat.
- Les étiquettes de référence (par exemple `Species` pour Iris) servent uniquement à évaluer les clusters, jamais à les construire.

## Sources de départ

- Frey, B. J. & Dueck, D. (2007). *Clustering by passing messages between data points*. Science, 315, 972–976. https://doi.org/10.1126/science.1136800
- Frey, B. J. & Dueck, D. (2005). *Mixture Modeling by Affinity Propagation*. NeurIPS 18. https://proceedings.neurips.cc/paper/2005/hash/327708dd10d68b1361ad3addbaca01f2-Abstract.html
- Leone, M., Sumedha & Weigt, M. (2007). *Clustering by soft-constraint affinity propagation: applications to gene-expression data*. Bioinformatics, 23(20), 2708–2715. https://doi.org/10.1093/bioinformatics/btm414
- Duan, G. & Zou, C. (2024). *A clustering effectiveness measurement model based on merging similar clusters*. PeerJ Computer Science, 10:e1863. https://doi.org/10.7717/peerj-cs.1863
- Periti, F. et al. (2025). *Incremental Affinity Propagation Based on Cluster Consolidation and Stratification*. Neural Processing Letters, 57, 44. https://doi.org/10.1007/s11063-025-11752-y
- Wang, Y. et al. (2024). *Clustering algorithm for experimental datasets using global sensitivity-based affinity propagation (GSAP)*. Combustion and Flame, 259, 113121. https://doi.org/10.1016/j.combustflame.2023.113121

Ces références viennent du README d'origine. Leurs DOI n'ont pas encore été vérifiés sur les pages des éditeurs.

## Dépôt

GitLab des départements maths-info de l'URCA : https://gitlab-mi.univ-reims.fr/dea0014/affinity_propagation
