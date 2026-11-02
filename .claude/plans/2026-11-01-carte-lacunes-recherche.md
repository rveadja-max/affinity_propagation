# Carte des lacunes de recherche — Plan de réalisation

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Produire `analyse_litterature/carte_lacunes.md`, une carte de 3 à 5 lacunes de recherche sur Affinity Propagation, chacune classée et étayée uniquement par les PDF du dossier `références bibliographique et méthodologie/`, et applicable au projet (rapport, TP R).

**Architecture:** Quatre livrables texte enchaînés : inventaire du corpus → tri (inclusion/exclusion motivée) → grille d'extraction par article inclus (citations + page) → carte des lacunes. Chaque étape se vérifie par des commandes `grep`/`awk` simples, puis la carte passe par `verify-claims` (sources = PDF locaux seulement) et `proofread`.

**Tech Stack:** Markdown ; extraction de texte des PDF avec `pypdf==5.1.0` installé dans le dossier temporaire de session (outil de lecture, non versionné, hors code du projet qui reste en R) ; skills projet `verify-claims`, `proofread`.

**Spec:** demande du 2026-11-01 (dans la conversation) : « En utilisant uniquement les articles de ce dossier, identifier 3 à 5 lacunes ; se concentrer sur les études récentes compatibles et applicables au projet ; classer chaque lacune. » + `CLAUDE.md` du projet (règles sources A/B/C, pas d'invention).

## Global Constraints

- Sources : **uniquement** les 48 PDF de `références bibliographique et méthodologie/`. Aucune recherche web, aucune connaissance externe présentée comme source.
- Ces PDF sont des documents fournis (niveau **A**) ; leurs métadonnées ne sont pas vérifiées en externe → mention « métadonnées lues dans le PDF, non vérifiées en externe ».
- Ne jamais inventer titre, auteur, année, DOI, chiffre ou citation. Information absente du PDF → « non indiqué dans le PDF ».
- Toute affirmation sur un article porte une référence `[ID, p. N]` où `N` est la page physique du PDF.
- Fenêtre « récente » (choix de Claude, à valider) : **2020–2026** pour les preuves d'une lacune ; les articles 2007–2014 servent seulement à vérifier qu'une lacune n'est pas déjà comblée.
- Typologie (interprétation de Claude, à valider) : **théorique, méthodologique, empirique, contextuelle, population**. Une lacune = un type principal (+ un type secondaire facultatif).
- 3 à 5 lacunes, chacune appuyée par **au moins 2 articles inclus** dont au moins 1 de 2020–2026.
- Applicabilité : chaque lacune dit ce que le projet peut en faire **d'ici le 10/11/2026**, en R (`apcluster`, `cluster`, `stats`), sur un jeu public de taille TP. Ce que le projet propose est marqué **(C) hypothèse du projet**.
- Pas de commit, pas de push (consigne du 2026-11-01). `analyse_litterature/` reste local jusqu'à décision.
- Langue : français.

## Review Focus

1. **Document hors sujet compté comme preuve** (ex. benchmark CTF pour LLM, portefeuilles financiers, segmentation d'images où « affinity propagation » désigne autre chose qu'AP de Frey & Dueck) → doit être exclu au tri avec motif. Test : Task 2 Step 2.
2. **« Futur travail » d'un auteur pris pour une lacune du domaine** alors qu'un autre PDF du corpus y répond → chaque lacune a une ligne « Contre-preuve cherchée » qui cite les articles qui la comblent partiellement. Test : Task 4 Step 2.
3. **Page fausse** (numérotation revue ≠ page PDF) → seules les pages physiques PDF sont citées, et un échantillon est relu. Test : Task 5 Step 1.
4. **Métadonnée devinée** à partir du nom de fichier (ex. année d'un fichier « 2610.15144 ») → l'inventaire prend titre/année dans le texte du PDF uniquement. Test : Task 1 Step 3.
5. **Lacune non applicable au projet** (exige un grand jeu de données, du GPU, ou une théorie hors portée) → colonne « Faisable d'ici le 10/11 : oui/partiel/non » obligatoire ; au moins 2 lacunes « oui ». Test : Task 4 Step 3.

---

### Task 1: Inventaire du corpus

**Files:**
- Create: `analyse_litterature/inventaire_corpus.md`
- Outil (non versionné) : `<scratchpad>/tools/extract.py`, sortie `<scratchpad>/txt/<fichier>.txt` avec marqueurs de page.

**Interfaces:**
- Produces: tableau Markdown, une ligne par PDF, colonnes exactes :
  `| ID | Fichier | Titre | Auteurs | Année | Revue/venue | DOI/arXiv | Type | Sujet AP ? |`
  - `ID` : `R01`…`R48` dans l'ordre alphabétique des fichiers (identifiant stable utilisé par toutes les tâches suivantes).
  - `Type` ∈ {fondateur, variante algorithmique, application, revue/survey, logiciel, thèse/livre, hors sujet probable}.
  - `Sujet AP ?` ∈ {central, secondaire, absent}.

- [ ] **Step 1: Réextraire le texte avec marqueurs de page**
  Modifier `extract.py` pour écrire `=== page N ===` avant chaque page (N commence à 1). Lancer :
  `python3 -I <scratchpad>/tools/extract.py "références bibliographique et méthodologie" <scratchpad>/txt <scratchpad>/pylib`
  Attendu : 48 fichiers `.txt`, chacun contenant `=== page 1 ===`.
  Vérif : `grep -L '=== page 1 ===' <scratchpad>/txt/*.txt` → aucune sortie.

- [ ] **Step 2: Remplir l'inventaire** depuis la page 1 (et la page de garde/références si besoin) de chaque PDF. Les livres volumineux (`978-3-540-78839-3.pdf`, actes RECOMB 2008, 495 p.) : identifier le ou les chapitres sur AP et les noter dans la colonne Titre.

- [ ] **Step 3: Vérifier l'inventaire**
  `grep -c '^| R[0-9][0-9] ' analyse_litterature/inventaire_corpus.md` → `48`
  `grep -E '^\| R[0-9]{2} ' analyse_litterature/inventaire_corpus.md | awk -F'|' '$6 ~ /^ *$/' ` → aucune ligne (année jamais vide : valeur ou « non indiqué dans le PDF »).
  Relire 5 lignes tirées au hasard contre la page 1 du PDF : titre et année identiques au texte.

### Task 2: Tri du corpus (inclusion / exclusion)

**Files:**
- Create: `analyse_litterature/tri_corpus.md`

**Interfaces:**
- Consumes: IDs et colonnes `Année`, `Type`, `Sujet AP ?` de Task 1.
- Produces: tableau `| ID | Décision | Motif |` avec `Décision` ∈ {inclus-récent, inclus-référence, exclu} ; en tête, les critères écrits :
  - inclus-récent : 2020–2026, AP (Frey & Dueck ou variante) utilisé ou étudié de façon substantielle ;
  - inclus-référence : avant 2020, fondateur ou variante citée pour vérifier les contre-preuves ;
  - exclu : AP absent ou seulement mentionné, ou « affinity propagation » au sens différent (à justifier par une citation `[ID, p. N]`).

- [ ] **Step 1: Écrire les critères puis classer les 48 IDs.** Pour repérer AP dans le texte extrait, chercher aussi les ligatures (`aﬃnity`, `afﬁnity`, `Afﬁnity`) : un premier comptage naïf a donné 0 occurrence pour des articles centrés sur AP (ex. Shiokawa AAAI-21, Nurmayanti 2026).
- [ ] **Step 2: Vérifier**
  `grep -cE '^\| R[0-9]{2} \| (inclus-récent|inclus-référence|exclu) \|' analyse_litterature/tri_corpus.md` → `48`
  `grep -E '\| exclu \|' analyse_litterature/tri_corpus.md | grep -vc 'p\. [0-9]'` → `0` (chaque exclusion cite une page).
  Nombre d'`inclus-récent` ≥ 8 ; sinon signaler à l'utilisateur que le corpus récent est trop mince avant de continuer.

### Task 3: Grille d'extraction

**Files:**
- Create: `analyse_litterature/grille_extraction.md`

**Interfaces:**
- Consumes: IDs `inclus-récent` et `inclus-référence` de Task 2.
- Produces: une fiche par article inclus, titre `## Rxx — <titre court> (<année>)`, champs exacts :
  `Question` · `Données (nom, n, publiques ?)` · `Variante d'AP` · `Similarité utilisée` · `Choix de la préférence` · `λ / convergence rapportés ?` · `Comparateurs` · `Métriques` · `Étiquettes externes utilisées pour évaluer ?` · `Code/données disponibles ?` · `Limites déclarées par les auteurs` · `Travaux futurs déclarés`.
  Format de chaque champ (ici et en Task 4) : une ligne `- **<Nom du champ> :** <valeur>`.
  Chaque champ renseigné porte `[Rxx, p. N]` ; champ absent → « non indiqué dans le PDF ».

- [ ] **Step 1: Remplir les fiches** (lire en priorité résumé, méthode, expériences, discussion/conclusion, sections « limitations »/« future work »).
- [ ] **Step 2: Vérifier**
  Nombre de fiches = nombre d'inclus : `grep -c '^## R[0-9][0-9] ' analyse_litterature/grille_extraction.md`.
  Chaque fiche a ses 12 champs : `grep -c '^- \*\*Travaux futurs déclarés' ...` = nombre de fiches.
  Champs « Limites » et « Travaux futurs » : soit `[Rxx, p. N]`, soit « non indiqué dans le PDF ».

### Task 4: Carte des lacunes

**Files:**
- Create: `analyse_litterature/carte_lacunes.md`

**Interfaces:**
- Consumes: fiches de Task 3.
- Produces: document avec
  1. **Méthode** (5–8 lignes) : corpus, fenêtre récente, critères, typologie, limite « métadonnées non vérifiées en externe ».
  2. **Tableau de synthèse** : `| # | Lacune (1 phrase) | Type principal | Type secondaire | Preuves | Faisable d'ici le 10/11 |`.
  3. **Une section par lacune** `## L<n> — <intitulé>`, champs exacts :
     `Énoncé` · `Type (et justification du type)` · `Preuves dans le corpus` (≥ 2 articles inclus, ≥ 1 récent, citations `[Rxx, p. N]`) · `Contre-preuve cherchée` (articles du corpus qui la comblent en partie, ou « aucune trouvée dans le corpus ») · `Pourquoi c'est une lacune et pas un simple détail` · `Applicabilité au projet — (C) hypothèse du projet` (expérience R concrète : jeu, paramètre balayé, métrique, livrable concerné) · `Faisable d'ici le 10/11 : oui / partiel / non` · `Limites de ce constat`.
  4. **Ce que la carte ne permet pas de conclure** (corpus non exhaustif, choisi par le binôme).

  Pistes à tester contre le corpus, sans les présupposer (C) : choix et sensibilité de la préférence ; comparaisons non équitables ou sans étiquettes ; reproductibilité (code, données, paramètres) ; passage à l'échelle O(n²) ; transformations de variables / similarité pour données mixtes ; stabilité.

- [ ] **Step 1: Rédiger les lacunes** à partir des fiches (motifs récurrents dans « Limites », « Travaux futurs » et champs « non indiqué »).
- [ ] **Step 2: Vérifier la structure**
  `grep -c '^## L[0-9] ' analyse_litterature/carte_lacunes.md` → entre `3` et `5`.
  `grep -E '^- \*\*Type' analyse_litterature/carte_lacunes.md | grep -cvE 'théorique|méthodologique|empirique|contextuelle|population'` → `0`.
  `grep -c 'Contre-preuve cherchée' ...` = nombre de lacunes.
- [ ] **Step 3: Vérifier preuves et faisabilité**
  Pour chaque `L<n>`, au moins 2 IDs distincts cités dans « Preuves », dont 1 « inclus-récent » de Task 2 (contrôle par lecture croisée avec `tri_corpus.md`).
  `grep -c 'Faisable d.ici le 10/11 : oui' ...` ≥ `2`.
  Aucun ID cité n'est « exclu » dans `tri_corpus.md`.

### Task 5: Vérification indépendante et relecture

**Files:**
- Modify: `analyse_litterature/carte_lacunes.md` (corrections uniquement)
- Create (local) : `quality_reports/carte_lacunes_verification.md`, `quality_reports/carte_lacunes_qmd_report.md`

**Interfaces:**
- Consumes: `carte_lacunes.md`, `grille_extraction.md`, les PDF.

- [ ] **Step 1: Lancer `verify-claims`** sur `analyse_litterature/carte_lacunes.md` avec `--source "références bibliographique et méthodologie/"` et la consigne au vérificateur : **sources locales seulement, pas de WebSearch**. Attendu : outcome PASS ou PARTIAL ; toute HIGH-WARN (citation contredite, page fausse, article inexistant dans le dossier) est corrigée puis revérifiée.
- [ ] **Step 2: Lancer `proofread`** sur `carte_lacunes.md` ; corriger les fautes signalées de sévérité High/Medium.
- [ ] **Step 3: Contrôle final**
  Tous les `[Rxx, p. N]` de la carte existent dans l'inventaire : `grep -oE 'R[0-9]{2}' carte_lacunes.md | sort -u` ⊂ IDs de `inventaire_corpus.md`.
  Présenter à l'utilisateur : le tableau de synthèse, les choix faits par Claude (fenêtre 2020–2026, typologie à 5 types, ID par ordre alphabétique), les documents exclus et pourquoi.
- [ ] **Step 4: Pas de commit** (consigne du 2026-11-01) — lister les fichiers créés.
