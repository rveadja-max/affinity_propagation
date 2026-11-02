suppressMessages(library(apcluster))
cat(R.version.string, " apcluster", as.character(packageVersion("apcluster")), "\n")
print(args(apcluster::apcluster))
print(formals(getMethod("apcluster", signature("function","ANY"))))
x <- scale(iris[,1:4])
for (q in c(0, 0.1, 0.5, 1)) { a <- apcluster(negDistMat(r=2), x, q=q, seed=1234); cat("q=",q," k=",length(a@exemplars)," it=",a@it, "\n") }
a <- apcluster(negDistMat(r=2), x, seed=1234); print(a@exemplars)
for (l in c(.5,.7,.9)) { a <- apcluster(negDistMat(r=2), x, lam=l, seed=1234); cat("lam=",l," k=",length(a@exemplars)," it=",a@it,"\n") }
cat("pkgs: cluster", requireNamespace("cluster"), " mclust", requireNamespace("mclust", quietly=TRUE), " aricode", requireNamespace("aricode", quietly=TRUE), "\n")
