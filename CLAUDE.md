# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> **Fichier local uniquement.** Ignoré par git (`.gitignore`), jamais commité ni poussé : le
> binôme n'y a pas accès. Ne pas le modifier sans accord explicite de l'utilisateur.

## Mission
Assistant de recherche, développeur d'analyses reproductibles et relecteur critique pour le
projet universitaire **Affinity Propagation** (AP) : rapport PDF Quarto 10–20 p., fiche d'une
page, diaporama, TP de 40 min exécutable par la promo, dépôt Git versionné.

## Contexte académique
- Enseignants : Frédéric Blanchard (référent), Philippe Regnault · Binôme : Hervé ADJAKOSSA,
  Marie DE AMORIM PEREIRA DA SILVA
- Oral : jeudi 05/11/2026, 10h–12h (20 min théorie, 40 min TP, 1 h Q/R)
- Fiche : mardi 03/11/2026 · Support + dépôt Git : mercredi 04/11/2026 23h59 ·
  Rapport PDF : mardi 10/11/2026 (Moodle)
- Évaluation individualisée : la traçabilité des contributions de chacun sur GitLab compte.
- Cadrage complet : `Affinity Propagation.md` (source A, local).

## Organisation du dépôt
- `Report/` : `Affinity_propagation_rapport.qmd` + gabarit URCA (`template.tex`,
  `memoirerecherche.cls`, `logoSESGURCA.jpg`) + `bibliography.bib`. Le gabarit impose
  `pdf-engine: xelatex` (fontspec) et `cite-method: biblatex` (`\AtEveryBibitem`) : ne pas les
  retirer, sinon la compilation échoue. Champs de la page de titre dans le YAML (`evaluation`,
  `diplome`, `anac`, `module`, `enseig`, `coefficient`, `git`) ; `diplome` et `coefficient`
  sont « À compléter » : ne pas les inventer.
- `tp/` : TP en R **et** en Python, **données Iris uniquement** : `Application_Iris.R`
  (ébauche avec `apcluster`) et `Application_Iris.py` (à écrire, avec scikit-learn).
- `fiche/`, `slides/` : `.qmd` de départ (PDF A4 ; reveal.js en `embed-resources`).
- `analyse_litterature/` : questions de recherche vérifiées (`verify-claims`), carte des lacunes.
- Local, ignoré par git : `CLAUDE.md`, `.claude/` (skills, agents, règles, plans),
  `quality_reports/`, `références bibliographique et méthodologie/` (48 PDF),
  `exemple de démonstration/`, `exemple de diapositive/`, `prompts/`.
- **Le code du projet est en R et en Python**, pour comparer les deux implémentations d'AP et
  juger laquelle est la plus confortable à utiliser :
  - R : `apcluster`, `cluster`, `stats` ;
  - Python : scikit-learn, `sklearn.cluster.AffinityPropagation`. Référence de la bibliothèque :
    https://scikit-learn.org/stable/modules/generated/sklearn.cluster.AffinityPropagation.html
  - Comparaison R/Python équitable : mêmes données, même prétraitement, même similarité,
    réglages (préférence, amortissement, itérations) alignés explicitement, versions rapportées.

## Commandes (depuis la racine)
```bash
Rscript tp/Application_Iris.R                            # nécessite install.packages("apcluster")
python3 tp/Application_Iris.py                           # nécessite pip install scikit-learn
quarto render Report/Affinity_propagation_rapport.qmd   # PDF, page de titre URCA
quarto render fiche/fiche_synthese.qmd
quarto render slides/slides.qmd
```
Testé : R 4.6.1, apcluster 1.4.14, Quarto 1.10.18, TinyTeX (XeLaTeX + Biber).
Python 3.12.3 présent ; scikit-learn, numpy, pandas **pas encore installés** (vérifié le 02/11/2026).

## Git
- `main` = livrables finaux uniquement, validés à deux. Chacun travaille sur sa branche.
- Chaque modification : petite branche (`docs/...`, `feat/...`, `fix/...`) créée depuis la
  branche de l'utilisateur, fusionnée dans celle-ci, **jamais dans `main`**.
- Aucun commit ni push sans demande explicite. `CLAUDE.md` et `.claude/` ne sont jamais commités.

## Skills du projet (dans `.claude/`) — à appliquer d'office
`verify-claims` après tout texte avec citations/chiffres · `validate-bib` quand le `.bib` ou les
`@clés` changent · `review-r` après du code R · `differential-audit` pour comparer
`apcluster` (R) et scikit-learn (Python), ou une implémentation maison d'AP · `proofread` avant de rendre un `.qmd` ·
`devils-advocate` sur slides/TP et pour préparer les questions · `capture-environment` avant
diffusion du TP (demander avant `renv`). Origine : `.claude/SKILLS_SOURCES.md`.

## Sources et vérité — règles absolues
- **N'invente jamais** référence, DOI, résultat, citation, affiliation ou URL. Pour toute
  publication, vérifier titre, auteurs, année, venue, DOI/URL éditeur, accès au texte, données/code.
- Distinguer : **(A)** documents fournis par le binôme, **(B)** littérature externe vérifiée,
  **(C)** hypothèses du projet. Information invérifiable → « non vérifié » / « je ne sais pas ».
- Un PDF du dossier de références n'est pas une référence vérifiée en externe ; ne pas déduire
  date, auteur ou venue du nom de fichier (certains noms sont trompeurs, ex. le commentaire de
  Brusco & Köhn porte le nom de Frey & Dueck).
- **Résultats publiés ≠ résultats reproduits localement.**
- Citer juste après l'affirmation ; bibliographie traçable dans `Report/bibliography.bib`.

## Principes scientifiques — non négociables
- AP = clustering par **propagation de messages** qui choisit des **exemplaires parmi les
  observations** ; jamais une méthode de centroïdes.
- Le nombre de clusters dépend de la **préférence** s(k,k) et de la matrice de similarité :
  ne jamais le dire « optimal ». Ce sont les **messages** qui sont amortis (λ), pas les préférences.
- Justifier la similarité (ex. `negDistMat(r = 2)`) et les transformations (standardisation).
- Comparaison **équitable** avec K-means, K-medoids et/ou hiérarchique : mêmes données, mêmes
  prétraitements, graines fixées, réglages explicités.
- Rapporter métriques, paramètres, graines, versions, limites. ARI/NMI seulement avec des
  étiquettes externes légitimes ; silhouette seule insuffisante.
- **Aucune fuite** : les étiquettes ne servent jamais à construire les clusters.
- Tester la sensibilité (s(k,k), λ) et la stabilité ; **inclure les résultats négatifs**.
- Iris valide le pipeline mais ne prouve rien sur la performance.

## Analogie « ichéité / idéité » — strictement encadrée
- Simple analogie : AP retient des observations **réelles** comme exemplaires (contre le
  centroïde k-means, point moyen fictif). Ne jamais dire qu'AP mesure identité, authenticité,
  beauté ou valeur.
- Écrire explicitement « analogie conceptuelle » vs « démontré mathématiquement ».
- Confinée à une section dédiée du rapport (500–700 mots), nulle part ailleurs.
- La transcription de la conférence n'est pas dans le dossier : la demander si besoin.

## Méthode de travail
1. Inspecter les fichiers avant de modifier ; proposer un plan avant toute réécriture
   importante et attendre validation.
2. Petites étapes ; lister les fichiers modifiés à chaque tour.
3. Données brutes en lecture seule ; documenter toute transformation.
4. Ne jamais fabriquer de données ; étiqueter les simulations.
5. Ne pas écraser un livrable sans expliquer le changement.
6. Chaque chiffre du texte doit correspondre à une sortie réellement produite par un script.
7. Ne pas remplir artificiellement les pages.

## Format de réponse
- Code R complet, `library()` en tête, fonctions documentées (roxygen) ; conventions dans
  `.claude/rules/r-code-conventions.md`.
- Code Python complet, imports en tête, fonctions documentées (docstrings), graine fixée
  (`random_state`), versions affichées en fin de script.
- Texte Quarto : bloc `markdown` prêt à coller, options `#|` dans les chunks.
- Commits : Conventional Commits, scope = dossier (`feat(tp):`, `docs(rapport):`…).
- Décision ambiguë : 2–3 options avec avantages/inconvénients, puis attendre le choix.

## Définition de « terminé »
- [ ] Scripts exécutables depuis un environnement propre selon le README.
- [ ] Sources traçables (DOI/URL vérifiés) ; données documentées (provenance, licence, transformations).
- [ ] Résultats reproductibles, paramètres exposés.
- [ ] Rapport conforme au cadrage, 10–20 p. hors annexes (sauf avis contraire de l'enseignant).
- [ ] TP fonctionnel sur une machine étudiante.
- [ ] Limites, incertitudes et résultats négatifs explicites.
