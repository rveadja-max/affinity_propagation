suppressPackageStartupMessages({library(apcluster); library(cluster)})
cat("apcluster", as.character(packageVersion("apcluster")), "cluster", as.character(packageVersion("cluster")), "\n")
print(args(apcluster:::apcluster.matrix))
x <- scale(iris[,1:4])
ap <- apcluster(negDistMat(r=2), x, seed=1234)
cat("defaut: k=", length(ap@exemplars), " it=", ap@it, " exemplars=", ap@exemplars, "\n")
for (q in c(0, .05, .1, .2, .5, 1)) { a <- apcluster(negDistMat(r=2), x, q=q, seed=1234); cat("q=",q," k=",length(a@exemplars),"\n") }
for (l in c(.5,.7,.9)) { a <- apcluster(negDistMat(r=2), x, lam=l, seed=1234); cat("lam=",l," k=",length(a@exemplars)," it=",a@it,"\n") }
a0 <- apcluster(negDistMat(r=2), x, q=0, seed=1234); print(a0@exemplars)
lab <- integer(150); for (i in seq_along(a0@clusters)) lab[a0@clusters[[i]]] <- i
print(table(lab, iris$Species))
cat("datasets wine?", exists("wine"), "\n")
