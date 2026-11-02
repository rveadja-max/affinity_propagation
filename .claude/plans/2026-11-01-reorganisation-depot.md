# Réorganisation du dépôt — Plan de réalisation

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal :** passer des trois copies `affinity_propagation-*` à un dossier par livrable (`rapport/ tp/ fiche/ slides/`), relier le gabarit URCA au rapport, réécrire README et CLAUDE.md, et remplacer les mentions de Python par R.

**Architecture :** déplacements de fichiers (avec une sauvegarde dans le dossier temporaire de session), puis un rendu Quarto PDF du rapport via `template.tex` + `memoirerecherche.cls` (XeLaTeX, biblatex), puis des textes.

**Tech Stack :** Quarto 1.10.18, TinyTeX (XeLaTeX), R + `apcluster`.

**Spec :** description en cinq points validée dans la conversation (« oui, lance la réorganisation du dépôt en cinq points », 2026-11-01) ; corrections de l'utilisateur : CLAUDE.md local seulement, `main` réservé aux livrables finaux, aucun commit ni push.

## Global Constraints
- Aucun commit, aucun push, pas de `git init`.
- `CLAUDE.md` et `.claude/` restent ignorés par git (`.gitignore` lignes 9–10).
- Ne rien inventer sur la page de titre : champ inconnu → « À compléter ».
- Les PDF de références, `exemple*`, `prompts/` et `Affinity Propagation.md` ne bougent pas.
- `analyse_litterature/` reste à la racine, en local (décision de versionnement en attente).

## Review Focus
1. Un fichier présent dans une ancienne copie et absent de la nouvelle organisation → vérification par liste avant suppression (Task 1 Step 3).
2. Le rendu PDF échoue sans biblatex (`\AtEveryBibitem`) ou sans XeLaTeX (`fontspec`) → `cite-method: biblatex`, `pdf-engine: xelatex` (Task 2).
3. Le logo et les champs du titre ne sont pas devinés : logo SESG conservé (choix du gabarit), diplôme et coefficient « À compléter » (Task 2).
4. Le README annonce une commande qui ne marche pas → chaque commande du README est exécutée (Task 4).
5. Il reste une mention de Python → `grep -ri python README.md CLAUDE.md prompts/` (Task 5).

---

### Task 1 : Dossiers par livrable
- [ ] Sauvegarder les trois dossiers dans `<scratchpad>/sauvegarde_avant_reorg/`.
- [ ] Créer `rapport/` (`.qmd`, `plan_rapport.md`, `recherche_bibliographique.md`, `memoirerecherche.cls`, `template.tex`, les 2 `.jpg`, `.csl`) et `tp/` (`Application_Iris.R`).
- [ ] Vérifier que chaque fichier de la sauvegarde est soit déplacé, soit dans la liste « à supprimer » (copie `.qmd` identique, 3 README GitLab par défaut, README obsolète du gabarit), puis supprimer les trois dossiers.

### Task 2 : Gabarit URCA relié au rapport
- [ ] YAML de `rapport/Affinity_propagation_rapport.qmd` : `format: pdf` avec `template: template.tex`, `documentclass: memoirerecherche`, `pdf-engine: xelatex`, `cite-method: biblatex`, `bibliography: bibliography.bib`, `lang: fr`, champs `evaluation`, `diplome`, `anac`, `module`, `enseig`, `coefficient`, `git`.
- [ ] Créer `rapport/bibliography.bib` avec les seules entrées dont les métadonnées ont été vérifiées dans les PDF (Frey & Dueck 2007 ; Bodenhofer et al. 2011).
- [ ] `quarto render Affinity_propagation_rapport.qmd` → PDF produit, page de titre URCA visible (contrôle visuel de la page 1).

### Task 3 : Fiche et slides
- [ ] `fiche/fiche_synthese.qmd` (PDF A4) et `slides/slides.qmd` (revealjs) : titre et auteurs seulement.
- [ ] `quarto render` des deux fichiers → sorties produites sans erreur.

### Task 4 : README
- [ ] Réécrire `README.md` (skill `crafting-effective-readmes`) : projet, équipe, échéances, organisation réelle, prérequis R/Quarto, commandes, règle « `main` = livrables finaux », sources de départ conservées telles quelles.
- [ ] Exécuter chaque commande citée dans le README.

### Task 5 : CLAUDE.md et mentions de Python
- [ ] Remplacer `CLAUDE.md` par la version proposée, ajustée : R seul, règles Git, local seulement, nouvelle organisation, skills du projet.
- [ ] Remplacer Python par R dans `prompts/PROMPTS.md`.
- [ ] `grep -rniw python README.md CLAUDE.md prompts/` → seules des mentions voulues (ex. « pas de Python »).
