suppressPackageStartupMessages({library(apcluster); library(cluster)})
print(selectMethod("apcluster", signature("matrix","missing"))@.Data |> formals() |> unlist(recursive=FALSE) |> (\(f) f[c("maxits","convits","lam","nonoise","seed","q")])())
print(args(apcluster::apcluster))
showMethods("apcluster")
x <- scale(iris[,1:4])
s <- negDistMat(x, r=2)
a <- apcluster(s, seed=1234); cat("default k=", length(a@exemplars), " it=", a@it, " ex=", a@exemplars, "\n")
for (q in c(0,0.05,0.1,0.2,0.5,1)) { b <- apcluster(s, q=q, seed=1234); cat("q=",q," k=",length(b@exemplars)," it=",b@it,"\n") }
for (l in c(0.5,0.7,0.9)) { b <- apcluster(s, lam=l, seed=1234); cat("lam=",l," k=",length(b@exemplars)," it=",b@it,"\n") }
b <- apcluster(s, q=0, seed=1234); lab <- integer(150); for(i in seq_along(b@clusters)) lab[b@clusters[[i]]] <- i
print(table(lab, iris$Species))
