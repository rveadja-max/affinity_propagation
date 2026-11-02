if (!interactive()) pdf(NULL)  # évite Rplots.pdf sous Rscript
# --- REGLAGES DEBUT ---
seed_main <- 1
q_main <- 0.5
lam_main <- 0.9
# --- REGLAGES FIN ---
library(apcluster)
x <- scale(iris[, c("Sepal.Length","Sepal.Width","Petal.Length","Petal.Width")])
plot(x[,1])
ap_main <- apcluster(negDistMat(r = 2), x, q = q_main, lam = lam_main, seed = seed_main)
