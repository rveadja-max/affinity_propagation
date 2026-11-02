suppressMessages({library(apcluster); library(cluster)})
cat("apcluster", as.character(packageVersion("apcluster")), "cluster", as.character(packageVersion("cluster")), "\n")
print(args(apcluster:::apcluster.matrix))
for (p in c("mclust","aricode","fpc","rattle","HDclassif","gclus","renv","ggplot2","knitr")) cat(p, requireNamespace(p, quietly=TRUE), "\n")
X <- scale(iris[,1:4]); S <- negDistMat(X, r=2)
ap <- apcluster(S, seed=1234); cat("default k", length(ap@exemplars), "ex", ap@exemplars, "it", ap@it, "\n")
for (q in c(0,0.05,0.1,0.2,0.5,1)) { a <- apcluster(S, q=q, seed=1234); cat("q",q,"k",length(a@exemplars),"\n") }
for (l in c(0.5,0.7,0.9)) { a <- apcluster(S, lam=l, seed=1234); cat("lam",l,"k",length(a@exemplars),"it",a@it,"\n") }
a0 <- apcluster(S, q=0, seed=1234); print(table(labels(a0,"enum"), iris$Species))
a5 <- apcluster(S, lam=0.5, maxits=20, convits=10, seed=1234); cat("lam .5 maxits20 conv? k", length(a5@exemplars), "it", a5@it, "\n")
print(a5)
