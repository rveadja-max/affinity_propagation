# =============================================================================
# TP guidé — Affinity Propagation sur le jeu de données Iris (version R)
# =============================================================================
# Module : Apprentissage non supervisé (URCA, 2026-2027)
# Binôme : Hervé ADJAKOSSA, Marie DE AMORIM PEREIRA DA SILVA
#
# Exécution depuis la racine du dépôt :
#   Rscript tp/Application_Iris.R
#
# Prérequis (une seule fois) :
#   install.packages("apcluster")   # le paquet « cluster » est fourni avec R
#
# Le script est volontairement séquencé en étapes commentées, pour être suivi
# en séance (40 min). Les graphiques sont écrits dans « Rplots.pdf » (racine),
# fichier non versionné. Les étiquettes Species servent UNIQUEMENT à évaluer
# les partitions obtenues, jamais à construire les clusters.
# =============================================================================

library(apcluster)  # Affinity Propagation : apcluster(), negDistMat()
library(cluster)    # pam() (K-medoids) et silhouette()

# Graine fixée : les résultats doivent être reproductibles d'une machine à
# l'autre (AP est déterministe, mais kmeans ne l'est pas).
set.seed(2026)

#' Indice de Rand ajusté (ARI) entre deux partitions
#'
#' Mesure l'accord entre deux partitions, corrigé du hasard : 1 = accord
#' parfait, 0 = niveau du hasard. Implémentation locale pour rester
#' autonome (équivalent de mclust::adjustedRandIndex).
#'
#' @param x Vecteur d'étiquettes de la première partition.
#' @param y Vecteur d'étiquettes de la seconde partition.
#' @return Un nombre réel, l'ARI.
adjusted_rand_index <- function(x, y) {
  tab <- table(x, y)
  n   <- sum(tab)
  a   <- sum(choose(tab, 2))
  b   <- sum(choose(rowSums(tab), 2))
  c   <- sum(choose(colSums(tab), 2))
  d   <- choose(n, 2)
  attendu <- b * c / d
  (a - attendu) / (0.5 * (b + c) - attendu)
}

## ---------------------------------------------------------------------------
## Étape 0 — Chargement et inspection des données
## ---------------------------------------------------------------------------

data(iris)
dim(iris)      # 150 observations, 4 variables numériques + l'espèce
head(iris)
summary(iris)

# Exploration visuelle rapide : chaque variable prise seule.
plot(iris$Sepal.Length, main = "Iris — longueur du sépale",
     xlab = "observation", ylab = "Sepal.Length")
plot(iris$Sepal.Width, main = "Iris — largeur du sépale",
     xlab = "observation", ylab = "Sepal.Width")
plot(iris$Petal.Length, main = "Iris — longueur du pétale",
     xlab = "observation", ylab = "Petal.Length")
plot(iris$Petal.Width, main = "Iris — largeur du pétale",
     xlab = "observation", ylab = "Petal.Width")

## ---------------------------------------------------------------------------
## Étape 1 — Prétraitement : standardisation (z-score)
## ---------------------------------------------------------------------------
# Les 4 variables sont en cm mais sur des échelles différentes. Sans
# standardisation, les variables de grande variance domineraient la distance
# euclidienne. scale() centre et réduit chaque colonne.

X      <- as.matrix(iris[, 1:4])   # les étiquettes (Species) sont mises de côté
X_std  <- scale(X)
verite <- iris$Species             # étiquettes, réservées à l'évaluation

## ---------------------------------------------------------------------------
## Étape 2 — Matrice de similarité et rôle de la préférence s(k, k)
## ---------------------------------------------------------------------------
# Similarité : négatif de la distance euclidienne au carré, s(i, k) = -||xi - xk||^2.
# C'est le choix de Frey & Dueck (2007) lorsque l'on veut minimiser l'erreur
# quadratique ; apcluster le fournit sous le nom negDistMat(r = 2).

S <- negDistMat(X_std, r = 2)

# La préférence s(k, k) gouverne le nombre de clusters : plus elle est élevée,
# plus chaque observation est candidate à devenir son propre exemplaire, et
# plus AP produit de clusters. apcluster la règle par quantile q des
# similarités : q = 0 -> minimum (peu de clusters), q = 0,5 -> médiane
# (réglage par défaut), q -> 1 -> beaucoup de clusters.

q_grid   <- seq(0, 1, by = 0.05)   # balayage de la préférence (question Q1)
n_clust  <- numeric(length(q_grid))
ari_grid <- numeric(length(q_grid))

for (i in seq_along(q_grid)) {
  res <- apcluster(S, q = q_grid[i], lam = 0.9, seed = 2026)
  n_clust[i]  <- length(res@clusters)
  # ARI : accord entre la partition obtenue et les espèces (évaluation seule)
  ari_grid[i] <- adjusted_rand_index(as.integer(verite), res@idx)
}

resultats_q <- data.frame(quantile_q = q_grid,
                          nb_clusters = n_clust,
                          ARI = round(ari_grid, 3))
print(resultats_q)

plot(q_grid, n_clust, type = "b", pch = 16,
     main = "AP sur Iris : nombre de clusters selon la préférence (quantile q)",
     xlab = "quantile q de la préférence s(k, k)", ylab = "nombre de clusters")
abline(h = 3, lty = 2, col = "grey50")   # 3 espèces botaniques, en repère

## ---------------------------------------------------------------------------
## Étape 3 — AP avec le réglage de référence (préférence médiane, q = 0,5)
## ---------------------------------------------------------------------------

ap_res <- apcluster(S, q = 0.5, lam = 0.9, maxits = 1000,
                    convits = 100, seed = 2026)

cat("\n--- AP, préférence médiane (q = 0,5), lambda = 0,9 ---\n")
cat("Nombre de clusters trouvés :", length(ap_res@clusters), "\n")
cat("Exemplaires (indices d'observations réelles) :", ap_res@exemplars, "\n")
cat("ARI vs espèces :", round(adjusted_rand_index(as.integer(verite), ap_res@idx), 3), "\n")

# Visualisation : dendrogramme des fusions de clusters et projection 2D.
plot(ap_res, S)            # agrégation hiérarchique des clusters d'AP
plot(ap_res, X_std)        # projection sur les 2 premières composantes

# Profil des exemplaires : ce sont des fleurs réelles du jeu de données.
cat("\nExemplaires (valeurs standardisées) :\n")
print(round(X_std[ap_res@exemplars, ], 2))

## ---------------------------------------------------------------------------
## Étape 4 — Comparaison équitable : K-means, K-medoids, hiérarchique
## ---------------------------------------------------------------------------
# Mêmes données standardisées pour toutes les méthodes. Le nombre de groupes k
# est imposé par le résultat d'AP (et non par les étiquettes : pas de fuite).

k_ap <- length(ap_res@clusters)

km    <- kmeans(X_std, centers = k_ap, nstart = 25)
pam_  <- pam(X_std, k = k_ap)
hc    <- hclust(dist(X_std)^2, method = "ward.D2")
hc_cl <- cutree(hc, k = k_ap)

comparaison <- data.frame(
  methode = c("Affinity Propagation", "K-means", "K-medoids (pam)",
              "Hiérarchique (Ward)"),
  k       = k_ap,
  ARI     = round(c(
    adjusted_rand_index(as.integer(verite), ap_res@idx),
    adjusted_rand_index(as.integer(verite), km$cluster),
    adjusted_rand_index(as.integer(verite), pam_$clustering),
    adjusted_rand_index(as.integer(verite), hc_cl)), 3)
)

# Critère commun du p-médiane : somme des distances au carré aux représentants.
#   - AP et pam : distances aux exemplaires/médoïdes (observations réelles) ;
#   - kmeans : distances aux centroïdes (points moyens) ;
#   - ward : non comparable directement (optimise l'inertie de fusion).
somme_dist <- function(X, centers, idx) {
  sum(vapply(seq_len(nrow(X)), function(i) {
    sum((X[i, ] - centers[idx[i], ])^2)
  }, numeric(1)))
}

# AP : reconstruction des étiquettes de cluster par observation.
labels_ap <- rep(NA_integer_, nrow(X_std))
for (c in seq_along(ap_res@clusters)) labels_ap[ap_res@clusters[[c]]] <- c
centres_ap <- X_std[ap_res@exemplars, , drop = FALSE]

comparaison$somme_dist2 <- round(c(
  somme_dist(X_std, centres_ap, labels_ap),
  sum(km$withinss),
  sum(pam_$objective["build"] + pam_$objective["swap"]),
  NA), 1)

cat("\n--- Comparaison à k imposé par AP (k =", k_ap, ") ---\n")
print(comparaison)

# Visualisation comparative (pétales, variables les plus discriminantes).
op <- par(mfrow = c(2, 2))
plot(X_std[, 3:4], col = labels_ap, pch = 16,
     main = paste0("AP (k = ", k_ap, ")"),
     xlab = "Petal.Length", ylab = "Petal.Width")
points(centres_ap[, 3:4], pch = 4, cex = 2, lwd = 2)
plot(X_std[, 3:4], col = km$cluster, pch = 16, main = "K-means",
     xlab = "Petal.Length", ylab = "Petal.Width")
plot(X_std[, 3:4], col = pam_$clustering, pch = 16, main = "K-medoids (pam)",
     xlab = "Petal.Length", ylab = "Petal.Width")
plot(X_std[, 3:4], col = hc_cl, pch = 16, main = "Hiérarchique (Ward)",
     xlab = "Petal.Length", ylab = "Petal.Width")
par(op)

## ---------------------------------------------------------------------------
## Étape 5 — Effet de l'amortissement lambda sur la convergence (Q4)
## ---------------------------------------------------------------------------
# Ce sont les MESSAGES (responsabilités et disponibilités) qui sont amortis,
# pas les préférences : message <- lambda * ancienne valeur + (1 - lambda) *
# nouvelle valeur. Un lambda plus élevé évite les oscillations mais ralentit.

maxits_test <- 3000
for (lam_test in c(0.5, 0.7, 0.9)) {
  res_lam <- apcluster(S, q = 0.5, lam = lam_test, maxits = maxits_test,
                       convits = 100, seed = 2026)
  cat(sprintf("lambda = %.1f -> itérations : %d, clusters : %d, convergé : %s\n",
              lam_test, res_lam@it, length(res_lam@clusters),
              ifelse(res_lam@it < maxits_test, "oui", "non (maxits atteint)")))
}

## ---------------------------------------------------------------------------
## Étape 6 — Environnement d'exécution (reproductibilité)
## ---------------------------------------------------------------------------

sink("sessionInfo.txt")
sessionInfo()
sink()
cat("\nEnvironnement consigné dans sessionInfo.txt (racine du dépôt).\n")
