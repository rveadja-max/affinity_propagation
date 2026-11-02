# ADR-0004 : Analyse descriptive, sans tests de significativité

**Date** : 2026-11-01
**Statut** : proposé
**Décideurs** : Hervé ADJAKOSSA (avec Claude)

## Contexte
L'étude porte sur deux jeux de données. AP est déterministe à données et paramètres fixés ; seules les parties aléatoires (départs de K-means, sous-échantillons de Q5) varient.

## Décision
Nous décrivons les résultats par courbes et tableaux, avec moyenne, écart-type et intervalle interquartile pour les parties aléatoires. Aucune p-valeur. La lecture attendue de chaque question est écrite avant de lancer les calculs.

## Alternatives considérées

### Tests statistiques (Wilcoxon, ANOVA sur les métriques)
- **Avantages** : apparence de rigueur.
- **Inconvénients** : n = 2 jeux ; répétitions d'un algorithme déterministe sans variabilité réelle.
- **Pourquoi pas** : une p-valeur n'aurait pas de sens.

## Conséquences
### Positives
- Conclusions honnêtes, formulées « sur Iris et Wine, dans ces réglages ».
### Négatives
- Aucune affirmation de supériorité générale possible.
### Risques
- Être interrogé sur l'absence de tests à l'oral → l'argument est documenté ici.
