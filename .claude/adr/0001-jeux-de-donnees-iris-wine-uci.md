# ADR-0001 : Iris et Wine complet (UCI) comme jeux d'étude

**Date** : 2026-11-01
**Statut** : proposé
**Décideurs** : Hervé ADJAKOSSA (avec Claude)

## Contexte
Les questions Q1–Q5 exigent des jeux publics, numériques, étiquetés (évaluation par ARI/NMI), assez petits pour un TP de 40 min, et déjà utilisés pour évaluer AP dans le corpus (Periti et al. 2025, p. 14 ; Sinha & Jana 2025, p. 19). Le dossier d'exemples contient un `wine.txt` qui, d'après son `ReadmeEnglish.txt`, ne garde que les colonnes 2, 8 et 13 du jeu d'origine.

## Décision
Nous utilisons `datasets::iris` (150 × 4, 3 classes) et le jeu Wine **complet** d'UCI (178 × 13, 3 classes), téléchargé avec provenance, licence et date consignées. Le `wine.txt` réduit n'est pas utilisé.

## Alternatives considérées

### `wine.txt` local (3 variables)
- **Avantages** : déjà sur le disque, utilisé dans la démo Adaptive AP.
- **Inconvénients** : 3 variables sur 13 ; résultats non comparables à ceux du corpus.
- **Pourquoi pas** : décrire ce jeu comme « Wine » serait inexact.

### Iris seul
- **Avantages** : intégré à R, aucun téléchargement.
- **Inconvénients** : jeu très facile, aucune portée au-delà de la validation du pipeline.
- **Pourquoi pas** : un seul jeu facile ne permet aucune comparaison.

### Un cas appliqué du corpus (combustion, trafic, sols…)
- **Avantages** : plus réaliste.
- **Inconvénients** : données et code non vérifiés comme disponibles ; trop lourd pour le délai.
- **Pourquoi pas** : délai du 10/11 ; à garder comme ouverture.

## Conséquences
### Positives
- Comparabilité avec le corpus ; TP exécutable partout (Iris).
### Négatives
- Deux jeux petits et faciles : aucune généralisation possible.
### Risques
- Licence UCI non vérifiée à ce jour → la vérifier et la citer avant diffusion.
- Téléchargement impossible en salle → fournir une copie de Wine avec sa provenance dans `tp/` si la licence le permet.
