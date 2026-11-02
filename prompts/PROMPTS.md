
---

## 3. `prompts/PROMPTS.md`

```markdown
# PROMPTS.md — Flux de travail pour Claude

Utiliser les prompts **dans l'ordre**, après avoir placé les deux documents fournis
(`cadrage.md`, `conference_icheite_ideite.md`) et ce dossier dans le répertoire de travail
de Claude. Chaque prompt est autosuffisant et possède un critère d'acceptation.

---

## Prompt 1 — Audit des documents et du cadrage

Tu es mon assistant de recherche. Lis intégralement `Affinity Propagation.md` puis
`README.md` et `CLAUDE.md`. Produis un tableau à quatre colonnes : **exigence explicite du
cadrage**, **idée du document philosophique**, **conséquence opérationnelle pour le projet**,
**risque de confusion ou point à vérifier**. N'ajoute aucune information externe à cette
étape. Cite les passages ou sections utiles. Signale toute ambiguïté sans la résoudre
arbitrairement. Termine par une **liste priorisée des décisions à prendre**.

---

## Prompt 2 — Revue de littérature vérifiable

Constitue une revue ciblée sur Affinity Propagation, avec priorité aux publications
universitaires de **Stanford** et du **MIT** lorsque des travaux pertinents existent, sans
exclure les meilleures sources d'autres institutions. Cherche en priorité **2023–2026**, puis
les références fondatrices.

Pour chaque résultat, fournis : **titre exact, auteurs, année, revue/conférence, institution
d'affiliation, DOI/URL éditeur, accès PDF légal, données/code disponibles, cas concret,
méthode, métriques, limites, intérêt pour notre rapport**.

Vérifie chaque métadonnée à la **source primaire**. Ne confonds pas site hébergeur et
affiliation des auteurs. **Ne fabrique aucune référence.** Sépare : articles **vérifiés** /
résultats **à vérifier** / documents **inaccessibles**. Sélectionne **6–10 références** de
valeur et explique pourquoi.

**Critère d'acceptation** : chaque entrée a un DOI ou une URL éditeur vérifiable ; un tableau
« Vigilance » liste les références dont je dois confirmer l'accès.

---

## Prompt 3 — Choix du cas d'étude

Compare les cas suivants :
1. sélection de conditions expérimentales en combustion (**GSAP, 2024**) ;
2. clustering incrémental d'un corpus diachronique (**2025**) ;
3. détection d'intrusions (**2024**) ;
4. un petit jeu pédagogique public.

Vérifie pour chacun : **données, code, licence, taille, difficulté, pertinence des
exemplaires, faisabilité en 40 minutes de TP**.

Construis une **matrice multicritère** avec critères définis **avant** de noter. N'invente pas
les notes : justifie chaque score par une preuve vérifiable, ou marque-le « à vérifier ».
Recommande un **cas principal** et un **cas de secours**.

**Critère d'acceptation** : chaque score renvoie à une source vérifiable ou est explicitement
marqué « à vérifier ».

---

## Prompt 4 — Explication mathématique de niveau master

Explique Affinity Propagation avec une progression **intuitive puis formelle** :
- matrice de similarité $S$ ;
- préférence diagonale $s(k,k)$ ;
- responsabilité $r(i,k)$ ;
- disponibilité $a(i,k)$ ;
- amortissement $\lambda$ ;
- critère de convergence ;
- extraction des exemplaires.

Donne les **équations** avec une définition de chaque symbole, un **petit exemple numérique
calculé pas à pas** et les **hypothèses/limites**. Explique **pourquoi AP ne requiert pas de
fixer $K$ au départ** mais pourquoi le nombre de clusters dépend notamment de la préférence.
Distingue **optimisation visée** et **garantie d'optimum global**. **Vérifie les équations
contre la publication fondatrice** et cite la source.

**Critère d'acceptation** : un lecteur M2 peut reproduire le calcul à la main sur l'exemple
fourni.

---

## Prompt 5 — Protocole expérimental avant codage

À partir du jeu de données retenu, rédige un **protocole pré-enregistrable** :
- question ;
- unités d'observation ;
- variables ;
- exclusions ;
- valeurs manquantes ;
- standardisation ;
- similarité ;
- AP et paramètres ;
- comparateurs ;
- métriques internes / externes ;
- analyse de sensibilité ;
- stabilité ;
- complexité ;
- environnement ;
- critères d'interprétation.

Indique quelles décisions sont **exploratoires**. **N'utilise pas les étiquettes externes dans
la construction des clusters.** Propose des résultats attendus seulement **sous forme
d'hypothèses, jamais comme faits**.

**Critère d'acceptation** : le protocole peut être suivi sans ambiguïté par un tiers.

---

## Prompt 6 — Implémentation reproductible

Implémente le protocole en R (`apcluster`, `cluster`, `stats`). **Commence par
inspecter l'arborescence et les versions installées.** Écris des fonctions courtes pour :
charger, valider, prétraiter, calculer la similarité, exécuter AP, calculer les métriques,
exporter les figures/tableaux. Ajoute des **contrôles** sur dimensions, valeurs manquantes,
matrice de similarité et labels.

Compare AP à **K-means, K-medoids et clustering hiérarchique** avec un **protocole
équitable**. Fixe les **graines** quand cela s'applique. Ajoute des **tests unitaires** et une
**commande de lancement documentée**.

**Ne prétends pas qu'un script fonctionne avant de l'avoir exécuté.**

**Critère d'acceptation** : les tests `testthat` passent ; `Rscript tp/<script>.R` s'exécute
sans erreur de bout en bout.

---

## Prompt 7 — Analyse des résultats sans surinterprétation

Analyse **exclusivement les fichiers de résultats réellement produits**. Commence par vérifier
leur **provenance, paramètres et cohérence**. Présente : nombre de clusters, exemplaires,
métriques, temps de calcul, stabilité, sensibilité. Compare les méthodes avec **incertitudes
ou répétitions** quand pertinent. Explique les **cas d'échec** et les clusters difficiles à
interpréter.

**Ne transforme pas une différence numérique en preuve de supériorité générale.** Distingue
**nos résultats**, **les résultats des articles** et **ton interprétation**.

**Critère d'acceptation** : chaque chiffre du texte pointe vers un fichier de `outputs/`.

---

## Prompt 8 — Lien critique avec ichéité et idéité

À partir du document fourni, **identifie les passages** qui opposent ou articulent
**idéalisation** et **singularité**. Propose une discussion de **500–700 mots** qui fait le
lien, **avec prudence**, entre cette distinction et le fait qu'AP sélectionne des
**observations réelles** comme exemplaires.

Indique **clairement** ce qui est une **analogie conceptuelle** et ce qui est **démontré
mathématiquement**. N'affirme pas qu'AP mesure l'identité, l'authenticité, la beauté ou la
valeur économique. Propose une **opérationnalisation éventuelle de la singularité**
uniquement si les variables et indicateurs sont **mesurables, justifiés et validables**.
Préserve les termes du document et signale les affirmations du texte qui exigeraient des
**sources indépendantes**.

**Critère d'acceptation** : un relecteur externe peut distinguer sans effort, dans la
discussion, l'analogie de la démonstration.

---

## Prompt 9 — Rédaction du rapport Quarto

Rédige le rapport en **français académique clair**, dans une source **Quarto compilable**.
Respecte le plan de `docs/plan_rapport.md` et la limite de **10–20 pages**. Chaque
affirmation technique ou empirique non triviale doit être **sourcée**. Les **figures et
tableaux** doivent provenir des **sorties réelles** du projet. Insère des **renvois aux
scripts** et explique les **choix méthodologiques**. **Ne remplis pas artificiellement les
pages.** Signale les éléments encore manquants avec des **TODO explicites** plutôt que de les
inventer.

**Vérifie la compilation Quarto et les références bibliographiques** si l'environnement le
permet.

**Critère d'acceptation** : `quarto render reports/rapport.qmd` produit un PDF entre 10 et
20 pages, avec TOC, références numérotées, figures issues de `outputs/`.

---

## Prompt 10 — TP de 40 minutes

Conçois un **tutoriel guidé** que des étudiants peuvent exécuter en **40 minutes** sur une
machine standard. Fournis : **prérequis, installation, données, commandes, étapes, temps
indicatif, questions de compréhension, résultats attendus uniquement s'ils ont été vérifiés,
dépannage**.

Le TP doit :
- faire varier **au moins la préférence** d'AP ;
- **montrer les exemplaires** ;
- **comparer à une méthode de référence** ;
- inclure une section **« que se passe-t-il si la similarité ou les paramètres changent ? »**.

Évite les dépendances lourdes et indique une **solution de secours hors ligne** si possible.

**Critère d'acceptation** : le notebook s'exécute sur un laptop vierge en < 40 min, sans
installation manuelle.

---

## Prompt 11 — Préparation de l'oral et questions difficiles

Prépare **10 minutes de contenu théorique par étudiant** (20 minutes au total), puis une
démonstration pratique de **40 minutes**. Construis un **diaporama concis** et répartis
**équitablement** les parties entre les deux membres du binôme.

Génère ensuite **25 questions possibles du jury**, classées par **difficulté**, avec
**réponses courtes mais rigoureuses** :
- fonction objectif ;
- préférence ;
- amortissement ;
- convergence ;
- complexité ;
- métriques ;
- choix des comparateurs ;
- stabilité ;
- reproductibilité ;
- limites ;
- comparaison avec K-means / K-medoids ;
- interprétation des exemplaires ;
- lien **prudent** avec ichéité/idéité.

**Les réponses doivent correspondre au code et aux résultats du projet.**

**Critère d'acceptation** : chaque question est répondue par une réponse qui renvoie à un
élément précis du code ou du rapport.

---

## Prompt 12 — Audit final contradictoire

Agis comme un **rapporteur critique**. Vérifie **chaque référence, chaque citation, chaque
tableau, chaque chiffre, les paramètres, la correspondance entre texte et code**. Cherche :
- fuites de données ;
- comparaisons injustes ;
- choix de métriques inadéquats ;
- conclusions trop fortes ;
- absence de résultats négatifs ;
- risques de non-reproductibilité ;
- confusion entre **analogie philosophique** et **preuve mathématique**.

Produis une liste de corrections **bloquantes / majeures / mineures**.

**Ne réécris pas automatiquement les résultats : demande une vérification quand la preuve
manque.**

**Critère d'acceptation** : la liste permet de prioriser les corrections à faire avant le
dépôt final du 04/11 23h59.