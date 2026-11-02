suppressMessages(library(apcluster)); library(cluster)
x <- scale(iris[,1:4]); s <- negDistMat(x, r=2)
cat("formals:\n"); f <- formals(getMethod("apcluster", signature("matrix","missing"))); print(f[c("p","q","maxits","convits","lam","nonoise","seed")])
for (q in c(0,0.05,0.1,0.2,0.3,0.5,0.9,1)) { a <- apcluster(s, q=q, seed=1234); cat(sprintf("q=%.2f k=%d it=%d conv=%s\n", q, length(a@exemplars), a@it, a@it < 1000)) }
for (l in c(0.5,0.7,0.9)) { a <- apcluster(s, lam=l, seed=1234); cat(sprintf("lam=%.1f k=%d it=%d\n", l, length(a@exemplars), a@it)) }
a <- apcluster(s, q=0, seed=1234); print(a@exemplars); print(table(labels(a,"enum"), iris$Species))
a5 <- apcluster(s, seed=1234); print(a5@exemplars)
a6 <- apcluster(s, lam=0.5, maxits=50, convits=10, seed=1234); cat("lam.5 maxits50 conv=",a6@it," k=",length(a6@exemplars),"\n")
print(R.version.string)
