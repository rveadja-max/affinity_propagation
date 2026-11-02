suppressMessages({library(apcluster); library(cluster)})
cat("R", R.version.string, " apcluster", as.character(packageVersion("apcluster")), " cluster", as.character(packageVersion("cluster")), "\n")
print(args(apcluster::apcluster))
print(formals(getMethod("apcluster", signature("function","ANY"))))
x <- scale(iris[,1:4])
ap <- apcluster(negDistMat(r=2), x, seed=1234)
cat("default k=", length(ap@exemplars), " it=", ap@it, " ex=", ap@exemplars, "\n")
for (q in c(0,0.05,0.1,0.2,0.3,0.5,0.9,1)) { a <- apcluster(negDistMat(r=2), x, q=q, seed=1234); cat("q=",q," k=",length(a@exemplars)," it=",a@it,"\n") }
for (l in c(0.5,0.7,0.9)) { a <- apcluster(negDistMat(r=2), x, lam=l, seed=1234); cat("lam=",l," k=",length(a@exemplars)," it=",a@it,"\n") }
a0 <- apcluster(negDistMat(r=2), x, q=0, seed=1234); cat("q0 ex=", a0@exemplars, "\n")
lab <- integer(150); for (i in seq_along(a0@clusters)) lab[a0@clusters[[i]]] <- i
print(table(lab, iris$Species))
