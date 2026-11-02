# Questions de recherche — Affinity Propagation

*Rédigé le 2026-11-01. Sources : uniquement les PDF du dossier `références bibliographique et méthodologie/`.*

**Niveaux de source**
- Les passages cités sont des documents fournis par le binôme (**A**). Leurs métadonnées (auteurs, année, revue) ont été lues dans les PDF et **ne sont pas vérifiées en externe**.
- Les questions sont des **propositions du projet (C)**, à tester. Ce ne sont pas des résultats.
- Les numéros de page sont ceux du **fichier PDF**, pas ceux de la revue.

> **Vérification (2026-11-01) :** `verify-claims` a été lancé avec les PDF locaux comme seules sources, sans recherche web. 14 affirmations ont été contrôlées. Une erreur (C2, amortissement) et deux formulations imprécises (C4, C11) ont été **corrigées** ci-dessous. Il reste un point non documenté dans le dossier : `lam` et `maxits` (voir Q4).

## Cadrage

### Problème

Le résultat d'AP, en particulier le nombre de clusters, dépend fortement de la **préférence** s(k,k). Il n'existe pas de règle fiable pour la choisir, et l'avantage d'AP sur les méthodes classiques reste discuté.

| Constat | Source (fichier, page) |
|---|---|
| Préférence commune conseillée : la médiane des similarités, ou le minimum pour obtenir moins de clusters | Frey & Dueck 2007, *Science* — `y passing messages between data points_ …pdf`, p. 2 |
| Les **messages** (responsabilités et disponibilités) sont amortis pour éviter les oscillations numériques : chaque message vaut λ fois sa valeur précédente plus (1 − λ) fois sa valeur mise à jour, avec λ = 0,5 par défaut | Frey & Dueck 2007 — même fichier, p. 3 |
| `apcluster()` utilise la médiane par défaut ; l'argument `q` permet de choisir un autre quantile | Bodenhofer et al. 2011, *Bioinformatics* — `APCluster an R package … .pdf`, p. 1 |
| La préférence médiane ne conduit pas à une solution optimale « dans de nombreux cas » ; les oscillations ne peuvent pas être éliminées automatiquement (il faut augmenter λ à la main et relancer, ou fixer λ proche de 1, ce qui ralentit beaucoup AP) | Wang et al. 2007, *Acta Automatica Sinica* 33(12) — `0805.1096v1.pdf` (copie arXiv), p. 1 |
| Déterminer la préférence idéale est « l'un des principaux défis » ; relancer l'algorithme plusieurs fois ne garantit pas l'optimalité | Sinha & Jana 2025, *Knowledge and Information Systems* — `s10115-024-02260-x.pdf`, p. 2 |
| Une heuristique du problème p-médiane obtient souvent une erreur plus basse qu'AP, en un temps comparable | Brusco & Köhn 2008, commentaire dans *Science* 319 (heuristique de substitution de sommets) — `Comment on Clustering by Passing Messages … .pdf`, p. 1. Le nom du fichier cite Frey & Dueck, qui ne sont pas les auteurs du commentaire. |
| La préférence est en général fixée au minimum ou à la médiane des similarités | Shiokawa, AAAI-21 — `01136-AAAI21.ShiokawaH-ML.pdf`, p. 2 |

### Population

Il ne s'agit pas d'une population humaine, mais de **jeux de données publics, numériques, de petite taille et étiquetés**.

| Jeu | Observations | Variables | Classes | Disponibilité | Usage dans le corpus |
|---|---|---|---|---|---|
| Iris | 150 | 4 | 3 | intégré à R (`iris`) | Periti et al. 2025, `s11063-025-11752-y.pdf`, p. 14 |
| Wine | 178 | 13 | 3 | à charger : source et licence à documenter | Periti et al. 2025, p. 14 ; Sinha & Jana 2025, p. 19 |

### Contexte

- Projet de master à l'URCA, code en R (`apcluster`, `cluster`, `stats`).
- Matériel : un ordinateur portable d'étudiant, sans budget.
- Délais : oral et TP de 40 min le 05/11/2026, rapport le 10/11/2026.

## Les 5 questions

### Q1 — Sensibilité à la préférence

- **Question :** sur Iris et Wine standardisés, avec la similarité `negDistMat(r = 2)` (moins la distance euclidienne au carré), comment varient le nombre de clusters et l'ARI d'AP quand le quantile `q` va de 0 à 1 par pas de 0,05 ?
- **Ce qu'on mesure :** nombre de clusters, ARI, convergence ; plage de `q` qui donne 3 clusters.
- **Appui :** Frey & Dueck p. 2 ; APCluster p. 1 ; Sinha & Jana p. 2.
- **Livrables :** TP et rapport.
- **Faisable d'ici le 10/11 :** oui.

### Q2 — Que vaut le réglage par défaut ?

- **Question :** la préférence médiane, réglage par défaut, donne-t-elle sur Iris et Wine un nombre de clusters proche des 3 classes connues ?
- **Comparaisons :** préférence minimale (`q = 0`) et plage proposée par `preferenceRange()`.
- **Ce qu'on mesure :** nombre de clusters, ARI, NMI.
- **Appui :** Wang et al. 2007 p. 1 ; Shiokawa p. 2.
- **Livrables :** rapport et slides.
- **Faisable d'ici le 10/11 :** oui.

### Q3 — AP face au K-medoids

- **Question :** à nombre de clusters égal, AP obtient-il une somme des dissimilarités aux exemplaires plus basse ou plus haute que K-medoids (`cluster::pam`) ?
- **Protocole :** mêmes données, même standardisation, même similarité ; k de `pam` fixé au nombre de clusters trouvé par AP, et dit comme tel.
- **Ce qu'on mesure :** somme des dissimilarités, temps de calcul, ARI.
- **Appui :** Brusco & Köhn p. 1. On reproduit leur critique à petite échelle.
- **Livrable :** rapport.
- **Faisable d'ici le 10/11 :** oui. Un résultat défavorable à AP sera rapporté.

### Q4 — Amortissement et convergence

- **Question :** à préférence fixée, quel effet ont λ = 0,5, 0,7 et 0,9 sur la convergence et sur la partition obtenue ?
- **Ce qu'on mesure :** nombre d'itérations, non-convergences, changements d'exemplaires, ARI.
- **Appui :** Frey & Dueck p. 3 ; Wang et al. 2007 p. 1.
- **À sourcer :** les arguments `lam` et `maxits` de `apcluster()` ne sont décrits dans **aucun document du dossier**. Seul `convits` l'est (vignette, p. 10). Avant de les citer, il faut ajouter le manuel du paquet ou l'aide `?apcluster`.
- **Livrables :** TP et rapport.
- **Faisable d'ici le 10/11 :** oui.

### Q5 — Standardisation et stabilité

- **Question :** la standardisation (z-score ou données brutes) change-t-elle les exemplaires choisis par AP ? Sur 100 sous-échantillons à 80 % avec une graine fixée, quel ARI moyen obtient-on entre partitions, pour AP comparé à K-means ?
- **Ce qu'on mesure :** exemplaires, nombre de clusters, ARI entre sous-échantillons.
- **Appui :** standardisation en z-score avant clustering dans Nurmayanti et al. 2026 (`4_5933_39-52_…pdf`, p. 3). Dans Zhang et al. 2024 (`s10653-024-02246-2.pdf`), le z-score de la p. 5 sert au modèle APCS-MLR, **pas** à l'entrée d'AP : cet article ne doit donc pas être cité comme exemple de standardisation pour AP.
- **Stabilité :** aucun article du dossier ne teste la stabilité d'AP par sous-échantillonnage ou bootstrap. Ce volet est donc une **proposition du projet (C)**. Le travail le plus proche est Goel, Filipovic & Pasricha (`2401.16920v2.pdf`, p. 18–19, tableau 2 ; annexe B, p. 36) : ils calculent l'ARI entre partitions AP obtenues sur des fenêtres temporelles glissantes, mais pas par rééchantillonnage.
- **Livrable :** rapport.
- **Faisable d'ici le 10/11 :** partiellement.

## Règles communes

- Les étiquettes servent **uniquement à évaluer** (ARI, NMI), jamais à construire les clusters.
- La silhouette n'est jamais utilisée seule.
- Paramètres, graines et versions des paquets sont rapportés pour chaque expérience.

## Limites

- Iris et Wine sont des jeux faciles et de petite taille. Les réponses ne permettront pas de conclure sur AP en général.
- Le corpus a été choisi par le binôme et n'est pas exhaustif.
- Les pages ont été repérées dans le texte extrait automatiquement. Le vérificateur a contrôlé que la numérotation correspond aux pages physiques des PDF.
- Pour Frey & Dueck, la p. 1 du fichier est une page de garde de *Science* : les p. 2 et 3 du fichier correspondent aux pages imprimées 972 et 973.
- Le premier auteur de l'article de Jurnal Varian s'écrit « Wiwit Pura Nurmayanti » dans le PDF, et non « Putra » comme dans le nom du fichier.

---

## Évaluation critique de l'énoncé du problème

> **Statut :** citations vérifiées et corrigées le 2026-11-01 (voir l'encadré en tête du fichier).

### Questions retenues comme les plus réalisables

- **Q1 et Q3** sont les plus solides. Elles sont appuyées par le corpus, s'exécutent en quelques secondes en R et donnent un résultat utile, qu'il soit favorable ou défavorable à AP.
- **Q2** est un cas particulier de Q1 (le défaut médian est une valeur de `q`). Elle est à fusionner avec Q1.
- **Q4** est secondaire.
- **Q5** manque d'appui dans le corpus.

### Grille d'évaluation de l'énoncé initial

| Critère | Verdict | Constat |
|---|---|---|
| Contexte | Partiel | Seul le contexte du projet est posé (master, R, délais). Le contexte scientifique manque : AP sélectionne des exemplaires réels, contrairement aux centroïdes de K-means, et il est présenté comme une méthode qui « trouve » le nombre de clusters. |
| Problème documenté | Présent, mais double | La dépendance à la préférence est appuyée par cinq sources. L'énoncé mélange le choix de la préférence et la performance d'AP face au p-médiane / K-medoids (Brusco & Köhn) : il faut relier ces deux problèmes ou en choisir un. |
| Population affectée | Absent | Iris et Wine sont des données de test, pas une population affectée. Les concernés sont les analystes qui appliquent AP avec le réglage par défaut. Il reste à compter, dans les articles appliqués du corpus, ceux qui ne rapportent pas leur préférence. |
| Preuves de signification | Faible | Les sources montrent que le problème existe, mais pas son ampleur ni sa fréquence. Seul Sinha & Jana 2025 indique que le problème est toujours d'actualité. |
| Lacune de recherche | Implicite | Aucune phrase ne dit ce qui manque. Elle doit venir de la carte des lacunes (plan 1). |
| Conséquences si non résolu | Absent | Pistes : nombre de clusters arbitraire présenté comme découvert, résultats non reproductibles quand la préférence n'est pas rapportée, supériorité d'AP affirmée sur une comparaison inéquitable. Chacune doit être sourcée ou marquée (C). |

### Énoncé réécrit (brouillon)

> Affinity Propagation (AP) regroupe des observations en choisissant certaines d'entre elles comme exemplaires, et il est souvent présenté comme dispensant de fixer le nombre de clusters à l'avance [Frey & Dueck 2007]. En pratique, ce nombre est gouverné par la préférence s(k,k). Le réglage conseillé, la médiane des similarités [Frey & Dueck 2007, p. 2 ; APCluster 2011, p. 1], ne conduit pas, dans de nombreux cas, à une solution optimale [Wang et al. 2007, p. 1], et le choix de la préférence reste décrit en 2025 comme l'un des principaux défis d'AP [Sinha & Jana 2025, p. 2]. Par ailleurs, une heuristique classique du p-médiane obtiendrait souvent une erreur plus faible qu'AP [Brusco & Köhn, p. 1].
>
> Les analystes qui appliquent AP avec le réglage par défaut risquent donc d'interpréter comme une structure découverte un nombre de clusters qui dépend d'un paramètre arbitraire, et d'attribuer à AP un avantage qu'une comparaison équitable ne confirmerait pas **(C)**.
>
> Ce projet mesure, sur deux jeux de référence étiquetés (Iris, Wine), l'ampleur de cette dépendance à la préférence et la position d'AP face au K-medoids à nombre de clusters égal. L'objectif est de documenter un comportement de l'algorithme, sans conclure sur sa performance générale.

**Ce que la réécriture corrige :**
- elle relie les deux problèmes (la préférence fixe le nombre de clusters, puis on compare à k égal) ;
- elle nomme la population affectée ;
- elle énonce une conséquence, marquée (C) ;
- elle limite la portée de l'étude.

### Ce qui manque encore

1. **Preuve de la population affectée :** compter les articles appliqués du corpus qui rapportent leur préférence (grille d'extraction du plan 1).
2. **Phrase de lacune :** à tirer de la carte des lacunes.
3. **Ordre de grandeur :** les premiers résultats de Q1. Ils seront présentés comme **résultats produits localement**, jamais comme résultats de la littérature.
