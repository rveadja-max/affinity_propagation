suppressMessages({library(apcluster); library(cluster)})
X <- scale(iris[,1:4]); S <- negDistMat(X, r=2); D <- -S
for (q in c(0, 0.5)) {
  ap <- apcluster(S, q=q, seed=20261105)
  k <- length(ap@exemplars); lab <- labels(ap, "enum")
  sap <- sum(D[cbind(seq_len(nrow(X)), ap@exemplars[lab])])
  pm <- pam(as.dist(D), k=k, diss=TRUE)
  spm <- sum(D[cbind(seq_len(nrow(X)), pm$medoids[pm$clustering])])
  cat(sprintf("q=%.1f k=%d somme dissim AP=%.2f pam=%.2f\n", q, k, sap, spm))
}
