suppressMessages({library(apcluster); library(cluster)})
cat("R", R.version.string, " apcluster", as.character(packageVersion("apcluster")), " cluster", as.character(packageVersion("cluster")), "\n")
X <- scale(iris[,1:4])
ap <- apcluster(negDistMat(r=2), X, seed=1)
cat("k(median)=", length(ap@exemplars), " ex=", ap@exemplars, " it=", ap@it, "\n")
for (q in c(0,0.05,0.1,0.25,0.5)) {a<-apcluster(negDistMat(r=2),X,q=q,seed=1); cat("q=",q," k=",length(a@exemplars),"\n")}
a0 <- apcluster(negDistMat(r=2),X,q=0,seed=1); print(table(labels(a0,"enum"), iris$Species))
