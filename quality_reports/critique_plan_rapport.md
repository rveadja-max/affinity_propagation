# Plan du rapport (10-20 pages)
> Keywords: affinity propagation, plan du rapport, charpente Quarto, gabarit URCA, apcluster, préférence, amortissement, comparaison équitable, ichéité
Iteration: 1

Fichiers critiqués : `Report/plan_rapport.md` (le plan) et `Report/Affinity_propagation_rapport.qmd` (la charpente).
Références croisées : `Affinity Propagation.md` (cadrage), `analyse_litterature/methodologie.md`, `README.md`, `CLAUDE.md`.

## Table des remarques

1. Titre - promet un « cas concret » que le protocole ne fournit pas (CONFIRMED)
2. Question de recherche - trois formulations différentes dans le dépôt (CONFIRMED)
3. 3. Fondements mathématiques - la stratégie d'optimisation (max-sum) n'est pas nommée (CONFIRMED)
4. Chapitre manquant - aucune partie « Implémentation », exigée par le cadrage (CONFIRMED)
5. 4. Paramètres et limites - doublon avec la Discussion (CONFIRMED)
6. 5. Cas d'étude - liste de candidats périmée, le choix Iris + Wine est déjà fait ailleurs (CONFIRMED)
7. 5. Cas d'étude - DOI des cas candidats non vérifiés (UNVERIFIED)
8. 6. Protocole - « AP est déterministe » est faux pour `apcluster` (CONFIRMED)
9. 6-7. Protocole et résultats - aucun chapitre ne dit quel script produit ses chiffres (CONFIRMED)
10. 7. Résultats - les résultats négatifs ne sont pas prévus (CONFIRMED)
11. 9. Ouverture ichéité / idéité - longueur incohérente, source absente (CONFIRMED / UNVERIFIED)
12. Charpente - le .qmd n'est pas relié au gabarit URCA ni à la bibliographie (CONFIRMED)
13. Charpente - double numérotation des titres (CONFIRMED)
14. Charpente - erreur de définition dans l'introduction (CONFIRMED)
15. Charpente - le README pointe vers `rapport/`, le dossier s'appelle `Report/` (CONFIRMED)

## Summary

- Plan solide sur le fond : découpage proche du cadrage, budget de pages cohérent (environ 15 p. en additionnant les chapitres 1 à 10), ichéité bien confinée.
- Trois manques structurels : pas de partie Implémentation, pas de lien chapitre -> script, pas de place pour les résultats négatifs.
- Le plan date du 24/10 et n'a pas suivi `methodologie.md` (01/11) : cas d'étude et question de recherche à réaligner.
- La charpente (.qmd) ne compile pas avec le gabarit URCA et ne peut pas citer de référence en l'état.
- 14 remarques CONFIRMED, 2 UNVERIFIED (la remarque 11 en a une de chaque).
- Vérification faite par lecture des fichiers, Grep et exécution de R 4.6.1 / apcluster 1.4.14 ; pas de LSP pour R.

---

## Titre

Confidence: CONFIRMED

Description:
`plan_rapport.md` ligne 4 annonce « comparaison empirique sur un cas concret ». Or le protocole retenu porte sur Iris et Wine, deux jeux de référence que `methodologie.md` qualifie lui-même de « petits et faciles » sans généralisation possible. Le titre promet plus que ce que le rapport pourra montrer. Il diffère aussi du titre de la charpente.

Evidence:
`Report/plan_rapport.md:4` ; `analyse_litterature/methodologie.md:33-34` et `:89` (« Deux jeux petits et faciles », « Aucune généralisation ») ; `Report/Affinity_propagation_rapport.qmd:2` (« L'algorithme Affinity Propagation »).

Suggested Solution:
Option A : « Affinity Propagation : sélection d'exemplaires et sensibilité à la préférence, illustrations sur Iris et Wine ».
Option B : garder le titre court du .qmd et mettre la précision en sous-titre. Dans les deux cas, un seul titre pour le plan et le .qmd.

---

## Question de recherche

Confidence: CONFIRMED

Description:
Trois formulations coexistent. Le plan parle de « méthode de référence ». Le README ajoute la stabilité et nomme les trois comparateurs. `methodologie.md` découpe en Q1 à Q5. Le jury questionnera chacun de vous sur la question : il faut une seule formulation.

Evidence:
`Report/plan_rapport.md:7` ; `README.md:26-29` ; `analyse_litterature/methodologie.md:7`.

Suggested Solution:
Reprendre la formulation du README (la plus complète) dans le plan et dans l'introduction du .qmd. Elle couvre Q1 à Q5. Mettre en note que Q5 (stabilité) est conditionnelle au temps disponible, comme dans `methodologie.md:68`.

---

## 3. Fondements mathématiques

Confidence: CONFIRMED

Description:
Le cadrage demande « hypothèses probabilistes éventuelles » et « stratégie d'optimisation ». Le plan liste les messages r(i,k) et a(i,k), mais ne nomme ni le graphe factoriel ni l'algorithme max-sum dont dérivent ces messages. C'est pourtant le cadre que `methodologie.md` mobilise pour expliquer la convergence. Sans lui, la partie ne répond pas explicitement à deux des quatre points du cadrage.

Evidence:
`Affinity Propagation.md:26` (exigences) ; `Report/plan_rapport.md:13` (aucune occurrence de « max-sum » ni « graphe ») ; `analyse_litterature/methodologie.md:22` (« max-sum, pour expliquer la convergence »).

Suggested Solution:
Ajouter au chapitre 3 deux sous-points :
- « Stratégie d'optimisation : passage de messages max-sum sur un graphe factoriel ; pas de garantie d'optimum global. »
- « Hypothèses probabilistes : dire explicitement ce qu'il en est (à sourcer dans Frey & Dueck 2007 avant d'écrire). »

---

## Chapitre manquant - Implémentation

Confidence: CONFIRMED

Description:
Le cadrage exige une partie Implémentation, et l'introduction du .qmd l'annonce (« nous préciserons une implémentation existante sous R »). Le plan n'a aucun chapitre pour cela. C'est aussi là que doivent figurer les réglages par défaut d'`apcluster`, qui diffèrent de l'article original. Le défaut d'amortissement est 0,9 dans `apcluster` contre 0,5 chez Frey & Dueck. Cette différence doit être dite dans le rapport, sinon les résultats ne sont pas interprétables. Ces défauts règlent aussi le point ouvert de `methodologie.md` sur `lam` et `maxits`.

Evidence:
- `Affinity Propagation.md:27` ; `Report/Affinity_propagation_rapport.qmd:24`.
- Aide `?apcluster` (apcluster 1.4.14) : `apcluster(s, x, p=NA, q=NA, maxits=1000, convits=100, lam=0.9, ..., nonoise=FALSE, seed=NA)`.
- `analyse_litterature/questions_recherche.md:21` (λ = 0,5 par défaut chez Frey & Dueck, p. 3).
- `analyse_litterature/methodologie.md:110` (point ouvert).

Suggested Solution:
Insérer après le chapitre 3 un chapitre « Implémentation dans R : apcluster » (environ 1 p.). Il contient : la fonction `apcluster()`, la similarité `negDistMat(r = 2)`, le tableau des défauts (`q` = médiane, `lam` = 0,9, `maxits` = 1000, `convits` = 100, bruit ajouté et `seed`) et la citation `@bodenhofer2011apcluster`. Prendre la page sur le chapitre 4 (voir la remarque suivante).

---

## 4. Paramètres et limites

Confidence: CONFIRMED

Description:
Les limites apparaissent deux fois : au chapitre 4, avant les résultats, puis au chapitre 8 (« limites »). Annoncer la sensibilité à la préférence avant de l'avoir mesurée prive les résultats de leur effet, et crée des répétitions.

Evidence:
`Report/plan_rapport.md:14` et `:18`.

Suggested Solution:
Déplacer « rôle des paramètres » dans le nouveau chapitre Implémentation. Garder la complexité O(n²) au chapitre 3. Regrouper toutes les limites au chapitre 8, où elles s'appuient sur vos propres mesures.

---

## 5. Cas d'étude et données - choix du cas

Confidence: CONFIRMED

Description:
Le plan propose encore quatre cas (combustion, corpus diachronique, intrusions, Iris), avec des critères de choix. Or `methodologie.md`, plus récent, a tranché : Iris pour valider la chaîne de traitement, Wine pour le rapport. Garder les anciens candidats dans le plan entretient une confusion entre vous deux sur ce qui sera rédigé.

Evidence:
`Report/plan_rapport.md:23-36` (fichier modifié le 24/10) ; `analyse_litterature/methodologie.md:31-34` (rédigé le 01/11).

Suggested Solution:
Remplacer les lignes 23-36 par : « Cas retenus : Iris (TP, validation) et Wine UCI 178 × 13 (rapport) ; voir `methodologie.md` ». Les trois articles applicatifs peuvent rester comme exemples d'usage au chapitre 2, une fois vérifiés.

---

## 5. Cas d'étude et données - références candidates

Confidence: UNVERIFIED

Description:
Les DOI de Wang et al. (2024), Periti et al. (2025) et Duan & Zou (2024) ne sont pas dans `bibliography.bib`, qui ne contient que deux entrées. Ils n'ont pas été vérifiés en externe pendant cette critique.

Evidence:
Non vérifié : aucune recherche web faite pendant cette passe. Constat local : `Report/bibliography.bib` ne contient que `frey2007clustering` et `bodenhofer2011apcluster`.

Suggested Solution:
Lancer `verify-claims` puis `validate-bib` sur ces trois DOI avant de les citer. Ajouter aussi Brusco & Köhn (2008), dont dépend la comparaison du protocole (Q3).

---

## 6. Protocole expérimental - déterminisme

Confidence: CONFIRMED

Description:
`methodologie.md` affirme qu'« AP est déterministe à données et paramètres fixés ». C'est vrai pour l'algorithme de Frey & Dueck, pas pour `apcluster` : le paquet ajoute par défaut un petit bruit aléatoire à la matrice de similarité. Sans `seed`, la reproductibilité n'est pas garantie en principe. En pratique, 5 lancements sur Iris ont donné les mêmes exemplaires, mais c'est un constat local, pas une garantie.

Evidence:
- Aide `?apcluster`, argument `nonoise` : « apcluster adds a small amount of noise to s to prevent degenerate cases » ; argument `seed` : « if NA, the seed remains unchanged ».
- Sortie locale (5 lancements, Iris standardisé, défauts) : exemplaires `4,6,18,81,92,118,123,124,140` à chaque fois.
- `analyse_litterature/methodologie.md:18`.

Suggested Solution:
Corriger la phrase : « AP (algorithme) est déterministe ; `apcluster` ajoute un bruit de départage, neutralisé par `seed` fixé (ou `nonoise = TRUE`) ». Ajouter `seed` à la liste des contrôles du chapitre 6 du plan.

---

## 6-7. Protocole et résultats - lien chapitre -> script

Confidence: CONFIRMED

Description:
Ta règle de projet : chaque chiffre du texte doit venir d'un script. Le plan ne dit pour aucun chapitre quel script produira ses tableaux et figures. Aujourd'hui, le seul script existant s'arrête avant l'appel à AP. Les chapitres 5 à 7 n'ont donc aucune source de chiffres.

Evidence:
`Report/plan_rapport.md:15-17` (aucun nom de fichier) ; `tp/Application_Iris.R:24` (commentaire final, sans appel à `apcluster`).

Suggested Solution:
Ajouter sous chaque chapitre 5 à 7 deux lignes, sur le modèle :
- « Fichiers : `analyses/01_sensibilite_q.R` -> `figures/k_vs_q.pdf` »
- « Vérification : `Rscript analyses/01_sensibilite_q.R` reproduit le tableau X »

Les noms exacts sont à décider à deux.

---

## 7. Résultats - résultats négatifs

Confidence: CONFIRMED

Description:
Le chapitre 7 liste ce qu'on affichera, mais ne prévoit pas où vont les résultats défavorables à AP. Par exemple, `pam` peut obtenir une somme de dissimilarités plus basse à k égal, ou AP peut ne pas converger. `methodologie.md` dit qu'ils seront rapportés « quel que soit leur sens » : le plan doit leur réserver une place.

Evidence:
`Report/plan_rapport.md:17` (aucune mention de « négatif », « non-convergence » ou « pam ») ; `analyse_litterature/methodologie.md:66-67`.

Suggested Solution:
Ajouter au chapitre 7 : « Tableau de comparaison à k imposé par AP (AP, `pam`, K-means, Ward) ; cas de non-convergence ; résultats défavorables à AP, rapportés tels quels ».

---

## 9. Ouverture : ichéité et idéité

Confidence: CONFIRMED (longueur) / UNVERIFIED (contenu)

Description:
Le plan prévoit 0,5 à 1 page. Les consignes du projet fixent 500 à 700 mots, soit plutôt 1 à 1,5 page avec le gabarit. Par ailleurs, la transcription de la conférence d'où vient l'analogie n'est pas dans le dépôt : le contenu ne peut pas être vérifié ni cité.

Evidence:
`Report/plan_rapport.md:19` ; `CLAUDE.md`, section « Analogie », 500-700 mots. Aucun fichier de transcription trouvé dans le dépôt.

Suggested Solution:
Passer le budget à « environ 1 p. (500-700 mots) ». Ajouter dans le plan la consigne d'écrire explicitement « analogie conceptuelle, non démontrée mathématiquement ». Fournir la transcription, ou une référence, avant de rédiger cette partie.

---

## Charpente - gabarit URCA et bibliographie

Confidence: CONFIRMED

Description:
Le YAML du .qmd n'utilise ni le gabarit URCA (`template.tex`, `memoirerecherche.cls`), ni XeLaTeX, ni biblatex, et ne déclare aucune bibliographie. La page de titre URCA ne sortira pas, et aucune clé `@...` ne pourra être citée. La référence à Frey & Dueck est d'ailleurs écrite en clair, sans clé. Le PDF présent dans `Report/` (12h12) est plus ancien que le .qmd (13h27).

Evidence:
`Report/Affinity_propagation_rapport.qmd:1-12` (aucune clé `template`, `pdf-engine`, `cite-method`, `bibliography`) ; `Report/Affinity_propagation_rapport.qmd:54` ; `CLAUDE.md`, section « Organisation du dépôt » (gabarit, xelatex et biblatex obligatoires) ; `ls -la Report/`.

Suggested Solution:
Réintégrer dans le YAML : `template`, `pdf-engine: xelatex`, `cite-method: biblatex`, `bibliography: bibliography.bib` et les champs de page de titre. Remplacer la ligne 54 par `[@frey2007clustering]`. À faire en accord avec Marie, qui a écrit cette charpente.

---

## Charpente - double numérotation

Confidence: CONFIRMED

Description:
`number-sections: true` numérote déjà les titres. Les numéros écrits à la main (« I. », « A. ») vont s'y ajouter, ce qui donne par exemple « 2 I. POSITIONNEMENT… » et « 2.1 A. La classification… ». L'introduction recevra aussi le numéro 1.

Evidence:
`Report/Affinity_propagation_rapport.qmd:10`, `:28`, `:30`, `:40`, `:52`.

Suggested Solution:
Retirer « I. », « A. », « B. », « C. » des titres et laisser Quarto numéroter. Mettre `# Introduction {.unnumbered}`. Éviter aussi les titres tout en majuscules, le gabarit gère la typographie.

---

## Charpente - définition dans l'introduction

Confidence: CONFIRMED

Description:
La phrase « L'apprentissage non-supervisé, aussi appelé apprentissage automatique » est fausse. L'apprentissage automatique (machine learning) est la famille entière, qui contient le supervisé et le non supervisé. La définition qui suit est celle de l'apprentissage automatique en général. Un membre du jury le relèvera tout de suite.

Evidence:
`Report/Affinity_propagation_rapport.qmd:20`. Coquilles relevées au passage : « en revenche » (`:20`), « sour R » (`:24`), « partitionnement,elles » (`:44`).

Suggested Solution:
« L'apprentissage automatique consiste à… On y distingue l'apprentissage supervisé, où…, et l'apprentissage non supervisé, où… » Lancer ensuite `proofread` sur le .qmd.

---

## Charpente - nom du dossier

Confidence: CONFIRMED

Description:
Le README et `CLAUDE.md` décrivent un dossier `rapport/`, mais le dossier réel est `Report/`. La commande `quarto render rapport/Affinity_propagation_rapport.qmd` du README échoue donc. La règle `rapport/*.tex` du `.gitignore` ne s'applique pas non plus.

Evidence:
`README.md:35` et `:70` ; `.gitignore` (`rapport/*.tex`, `!rapport/template.tex`) ; `ls` : dossier `Report/`.

Suggested Solution:
Choisir un nom à deux. Soit renommer `Report/` en `rapport/`, soit mettre à jour le README et le `.gitignore`. Marie a déjà commité sous `Report/` : il faut s'accorder avant de renommer.
