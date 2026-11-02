# ADR-0002 : Similarité `negDistMat(r = 2)` sur données standardisées (z-score)

**Date** : 2026-11-01
**Statut** : proposé
**Décideurs** : Hervé ADJAKOSSA (avec Claude)

## Contexte
AP opère sur une matrice de similarité qu'il faut justifier. Frey & Dueck fixent chaque similarité au négatif de l'erreur quadratique (distance euclidienne au carré) quand le but est de minimiser l'erreur quadratique (Frey & Dueck 2007, p. 2 du PDF) ; `apcluster` la fournit par `negDistMat(r = 2)` (vignette, p. 6). Les variables d'Iris et surtout de Wine ont des unités et des échelles différentes.

## Décision
Nous standardisons chaque variable (z-score, `scale()`), puis calculons `negDistMat(r = 2)`. Le facteur « données brutes » n'est conservé que comme variante dans Q5.

## Alternatives considérées

### Données brutes
- **Avantages** : aucune transformation à justifier.
- **Inconvénients** : les variables de grande échelle dominent la distance (Wine).
- **Pourquoi pas** : biais d'échelle ; gardé seulement comme comparaison en Q5.

### Autre similarité (corrélation de Pearson, distance de Manhattan)
- **Avantages** : la démo Adaptive AP propose une similarité de Pearson.
- **Inconvénients** : s'éloigne de la formulation d'origine et des concurrents (K-means est euclidien).
- **Pourquoi pas** : compliquerait la comparaison équitable (ADR-0003).

## Conséquences
### Positives
- Même géométrie pour AP, K-means et `pam` ; formulation fidèle à Frey & Dueck.
### Négatives
- La standardisation est un choix de modélisation, qui doit être signalé.
### Risques
- La standardisation peut changer les exemplaires choisis → mesuré dans Q5.
