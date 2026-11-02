suppressPackageStartupMessages({library(apcluster); library(cluster)})
print(args(apcluster::apcluster))
showMethods("apcluster")
x <- scale(iris[,1:4]); s <- negDistMat(x, r=2)
ap <- apcluster(s, seed=1234); cat("default k=", length(ap@exemplars), " it=", ap@it, " ex=", ap@exemplars, "\n")
for (q in c(0,0.05,0.1,0.2,0.3,0.5,0.7,0.9,1)) { a <- apcluster(s, q=q, seed=1234); cat("q",q,"k",length(a@exemplars),"it",a@it,"\n") }
for (l in c(0.5,0.7,0.9)) { a <- apcluster(s, lam=l, seed=1234); cat("lam",l,"k",length(a@exemplars),"it",a@it,"\n") }
a0 <- apcluster(s, q=0, seed=1234); print(a0@exemplars); lab <- labels(a0, type="enum"); print(table(lab, iris$Species))
# p-median objective: sum of sq dist to exemplars
D <- as.matrix(dist(x))^2
obj <- function(cl, ex) sum(D[cbind(seq_len(nrow(D)), ex[cl])])
cat("AP obj q=0:", obj(lab, a0@exemplars), "\n")
p <- pam(D, k=3, diss=TRUE); cat("pam obj (sq):", sum(D[cbind(1:150, p$id.med[p$clustering])]), "\n")
apd <- apcluster(s, seed=1234); labd <- labels(apd, type="enum"); k <- length(apd@exemplars)
p9 <- pam(D, k=k, diss=TRUE); cat("k",k,"AP obj:", obj(labd, apd@exemplars), " pam obj:", sum(D[cbind(1:150, p9$id.med[p9$clustering])]), "\n")
pr <- preferenceRange(s); print(pr)
cat("nonoise test default seed NA twice:\n"); for(i in 1:3) cat(apcluster(s)@exemplars, "\n")
