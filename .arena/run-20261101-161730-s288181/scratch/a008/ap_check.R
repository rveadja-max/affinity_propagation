library(apcluster)
print(args(apcluster:::apclusterK)); print(head(deparse(selectMethod("apcluster", c("matrix","missing"))@.Data),3))
x <- scale(iris[,1:4]); s <- negDistMat(x, r=2)
a <- apcluster(s, seed=1234); cat("defaut k=",length(a@exemplars)," it=",a@it," ex=",a@exemplars,"\n")
for (q in c(0,0.05,0.1,0.2,0.5,1)) { b<-apcluster(s,q=q,seed=1234); cat("q=",q," k=",length(b@exemplars)," it=",b@it,"\n") }
for (l in c(0.5,0.7,0.9)) { b<-apcluster(s,lam=l,seed=1234); cat("lam=",l," k=",length(b@exemplars)," it=",b@it,"\n") }
b<-apcluster(s,q=0,seed=1234); print(b@exemplars); print(table(labels(b,"enum"), iris$Species))
