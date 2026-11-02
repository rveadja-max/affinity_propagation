# Cadre théorique — Affinity Propagation

*Rédigé le 2026-11-01. Sources : uniquement les PDF du dossier `références bibliographique et méthodologie/`. Les pages sont celles du **fichier PDF**.*

> **Vérification (2026-11-01) :** `verify-claims` a contrôlé 11 affirmations en utilisant les PDF locaux comme seules sources. 8 sont confirmées. Une attribution erronée (convergence et graphe à boucles) et deux formulations excessives (origine du p-médiane, lien `pam`–p-médiane) ont été **corrigées** ci-dessous.

**Niveaux de source**
- Les passages cités sont des documents fournis par le binôme (**A**). Leurs métadonnées n'ont pas été vérifiées en externe.
- La recommandation finale et l'hypothèse du cadre 3 sont des **propositions du projet (C)**.

## Cadrage de l'étude

- **Phénomène :** le nombre de clusters et la qualité des exemplaires d'AP dépendent de la préférence s(k,k). On étudie aussi la position d'AP face au K-medoids à nombre de clusters égal.
- **Population :** jeux de données publics, petits et étiquetés (Iris, Wine).
- **Contexte :** projet de master en R (`apcluster`, `cluster`), TP de 40 min, rapport le 10/11/2026.
- **Questions de recherche :** Q1–Q5 dans `questions_recherche.md`.

Dans un projet de méthode, le « cadre théorique » désigne le cadre mathématique qui explique le comportement de l'algorithme.

## Cadre 1 — Localisation d'exemplaires (problème p-médiane / k-médiane)

- **Concepts fondamentaux :**
  - Regrouper revient à choisir des exemplaires parmi les observations.
  - L'objectif d'AP s'écrit comme une énergie E(c) = −Σᵢ s(i, cᵢ). La minimiser exactement est intraitable, car le problème NP-difficile du k-médiane en est un cas particulier [Frey & Dueck 2007, p. 5].
  - Les préférences sont interprétées comme un **coût fixe** (« fixed charge ») dans la fonction objectif de l'heuristique de substitution de sommets (VSH), une heuristique du modèle p-médiane. Ce modèle est « un problème mathématique général », dont la localisation d'usines est « un exemple classique » [Brusco & Köhn, p. 1].
- **Adéquation aux questions :**
  - Fort pour Q1 et Q2 : la préférence règle le compromis entre le nombre d'exemplaires et la proximité aux exemplaires.
  - Très fort pour Q3 : le K-medoids (`cluster::pam`) minimise lui aussi une somme de dissimilarités à des représentants choisis parmi les observations. **Ce rapprochement entre K-medoids et p-médiane est une inférence du projet (C)** : aucun PDF du dossier ne l'énonce explicitement. Les éléments existent séparément : le p-médiane revient à minimiser la somme des dissimilarités [Brusco & Köhn, p. 1] ; k-médianes, localisation d'installations et p-médiane sont présentés comme un même problème [actes RECOMB 2008, `978-3-540-78839-3.pdf`, p. 378] ; le k-medoids minimise la somme des distances au médoïde [`2103.14376v1.pdf`, p. 10]. Le rapport devra citer une source externe vérifiée (B) pour ce lien.
- **Forces :**
  - Un critère commun à toutes les méthodes (somme des similarités aux exemplaires).
  - Explique qu'une heuristique concurrente puisse battre AP.
- **Limites explicatives :**
  - Rien sur la convergence ni l'amortissement (Q4), rien sur la stabilité (Q5).
  - Juge la valeur de l'objectif, pas l'interprétabilité des clusters.
  - Comparaison à k fixé seulement, puisque `pam` n'a pas de préférence.

## Cadre 2 — Propagation de messages max-sum sur graphe factoriel

- **Concepts fondamentaux :**
  - Les règles de mise à jour d'AP sont des récursions de point fixe qui minimisent une approximation de Bethe de l'énergie libre.
  - AP se dérive comme une instance de l'algorithme max-sum sur un graphe factoriel décrivant les contraintes [Frey & Dueck 2007, p. 5].
  - Dans certains cas dégénérés, la fonction d'énergie a plusieurs minima, donc plusieurs points fixes des règles de mise à jour, ce qui peut empêcher la convergence et faire osciller AP (exemple : similarités symétriques et préférences égales). Ces oscillations peuvent toujours être évitées en ajoutant un bruit minime aux similarités ou en augmentant l'amortissement [Frey & Dueck 2007, p. 5].
  - Frey & Dueck rattachent AP aux méthodes de propagation de messages « dans un graphe à boucles » utilisées en décodage, en satisfiabilité et en dépliement de phase [Frey & Dueck 2007, p. 6]. Ils ne lient pas explicitement les boucles aux échecs de convergence.
  - Givoni et al. décrivent AP comme un algorithme max-sum sur graphe factoriel à boucles, et en dérivent une version hiérarchique (HAP) [Givoni, Chung & Frey, `1202.3722v1.pdf`, p. 1–2].
- **Adéquation aux questions :**
  - Très fort pour Q4 : il explique pourquoi AP peut osciller et pourquoi on amortit les messages par λ.
  - Indirect pour Q3 : la solution d'AP est approchée, pas garantie optimale.
- **Forces :** c'est le cadre d'origine d'AP, indispensable au chapitre « fondements mathématiques » du cadrage.
- **Limites explicatives :**
  - Ne dit pas comment choisir la préférence.
  - Explique les échecs de convergence (cas dégénérés à plusieurs points fixes) sans prédire la qualité de la partition.

## Cadre 3 — Physique statistique : phases et contraintes souples

- **Concepts fondamentaux :**
  - « Sous certaines conditions », il existe une valeur s* du paramètre de pénalité qui fixe le nombre de clusters. Elle sépare une phase de **fragmentation** (s < s*) d'une phase de **coalescence** (s > s*).
  - Une stratégie fondée sur AP en est tirée pour estimer le nombre de clusters [Furtlehner, Sebag & Zhang, `0910.1800v1.pdf`, p. 1].
  - La contrainte stricte d'AP (chaque exemplaire est son propre exemplaire) force des clusters « en étoile de rayon un ». La version à contrainte souple (SCAP) la relâche [Leone, Sumedha & Weigt, `0705.2646v2.pdf`, p. 1]. Le PDF ne porte que la mention arXiv v2 du 29/11/2007, sans revue : la publication dans *Bioinformatics* 23(20), donnée par le README, reste à vérifier en externe.
  - Leone et al. rattachent AP à la propagation de croyances (belief propagation), avec O(N²) messages au lieu de O(N³) [Leone et al., p. 1].
- **Adéquation aux questions :**
  - Fort pour Q1 : il prédit une transition nette dans la courbe « nombre de clusters en fonction de `q` ».
  - Partiel pour Q5.
- **Forces :**
  - Le seul des trois cadres qui fasse une prédiction testable sur la sensibilité à la préférence.
  - Explique la difficulté d'AP face aux clusters allongés.
- **Limites explicatives :**
  - Résultat obtenu « sous certaines conditions ».
  - Mathématiques hors de portée d'un TP de 40 min.
  - Prépublication arXiv (0910.1800v1, 9 octobre 2009). Le PDF n'indique aucune publication en revue ou en conférence.
  - Transition non garantie sur de petits jeux comme Iris (n = 150).

## Recommandation (C)

| Rôle | Cadre | Questions |
|---|---|---|
| Mécanisme : comment AP fonctionne | 2 — max-sum | Q4, chapitre « fondements » |
| Évaluation : ce qu'AP optimise et à quoi le comparer | 1 — p-médiane | Q1, Q2, Q3 |
| Hypothèse à tester | 3 — transition de phase | Q1 |

- Le cadre 2 dit **comment** AP cherche ; le cadre 1 dit **ce qu'il cherche** et permet la comparaison.
- Le cadre 3 n'entre que comme hypothèse : « le balayage de `q` montre-t-il une transition nette sur Iris et Wine ? ». Il n'est jamais présenté comme un résultat.
- L'analogie « ichéité / idéité » n'est pas un cadre théorique. Elle reste confinée à sa section du rapport.
