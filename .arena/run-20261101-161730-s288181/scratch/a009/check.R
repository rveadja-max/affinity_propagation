library(apcluster); library(cluster)
x <- scale(iris[,1:4])
a <- apcluster(negDistMat(r=2), x, seed=1234)
cat("defaut k=", length(a@exemplars), " it=", a@it, " exemplars=", a@exemplars, "\n")
for (q in c(0,0.05,0.1,0.2,0.3,0.5,0.7,0.9,1)) { b <- apcluster(negDistMat(r=2), x, q=q, seed=1234); cat("q=",q," k=",length(b@exemplars)," it=",b@it,"\n") }
for (l in c(0.5,0.7,0.9)) { b <- apcluster(negDistMat(r=2), x, lam=l, seed=1234); cat("lam=",l," k=",length(b@exemplars)," it=",b@it,"\n") }
b <- apcluster(negDistMat(r=2), x, q=0, seed=1234); print(table(labels(b,"enum"), iris$Species)); cat("ex:", b@exemplars,"\n")
D <- as.matrix(dist(x))^2
cost <- function(ex, cl) sum(D[cbind(seq_len(nrow(x)), ex[cl])])
cl_ap <- labels(b,"enum"); cat("AP sum sqdist:", cost(b@exemplars, cl_ap), "\n")
p <- pam(D, k=3, diss=TRUE); cat("pam sum sqdist:", cost(p$id.med, p$clustering), " medoids:", p$id.med, "\n")
print(args(apcluster))
print(formals(apcluster:::apclusterK)[1:3])
