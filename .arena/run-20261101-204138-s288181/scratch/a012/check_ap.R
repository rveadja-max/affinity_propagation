suppressPackageStartupMessages({library(apcluster); library(cluster)})
m <- getMethod("apcluster", signature("function","ANY"))
print(unlist(formals(m@.Data)[c("q","maxits","convits","lam","nonoise","seed")]))
x <- scale(iris[,1:4])
ap <- apcluster(negDistMat(r=2), x, seed=1234)
cat("default k=", length(ap@exemplars), " it=", ap@it, " exemplars=", ap@exemplars, "\n")
for (q in c(0, .05, .1, .2, .3, .5, 1)) { a <- apcluster(negDistMat(r=2), x, q=q, seed=1234); cat("q=",q," k=",length(a@exemplars)," conv=", a@it < 1000, "\n") }
for (l in c(.5,.7,.9)) { a <- apcluster(negDistMat(r=2), x, lam=l, seed=1234); cat("lam=",l," k=",length(a@exemplars)," it=",a@it,"\n") }
a0 <- apcluster(negDistMat(r=2), x, q=0, seed=1234)
print(table(cluster=labels(a0, type="enum"), iris$Species))
# p-median objective: AP vs pam at k=3, sq euclid
D2 <- as.matrix(dist(x))^2
obj <- function(ex, cl) sum(D2[cbind(seq_len(nrow(x)), ex[cl])])
cl_ap <- labels(a0, type="enum"); cat("AP obj=", obj(a0@exemplars, cl_ap), "\n")
p <- pam(as.dist(D2), k=3, diss=TRUE); cat("pam obj=", sum(D2[cbind(seq_len(nrow(x)), p$id.med[p$clustering])]), "\n")
cat(R.version.string, as.character(packageVersion("cluster")), "\n")
