suppressMessages(library(apcluster)); library(cluster)
print(args(apcluster::apcluster)); print(formals(apcluster:::apclusterK)$lam)
showMethods("apcluster")
X <- scale(iris[,1:4])
ap <- apcluster(negDistMat(r=2), X, seed=1234)
cat("default k=", length(ap@exemplars), "it=", ap@it, "ex=", ap@exemplars, "\n")
for(q in c(0,0.05,0.1,0.2,0.5,1)){a<-apcluster(negDistMat(r=2),X,q=q,seed=1234); cat("q",q,"k",length(a@exemplars),"it",a@it,"\n")}
for(l in c(0.5,0.7,0.9)){a<-apcluster(negDistMat(r=2),X,lam=l,seed=1234); cat("lam",l,"k",length(a@exemplars),"it",a@it,"conv",a@convergence %||% NA,"\n")}
a0<-apcluster(negDistMat(r=2),X,q=0,seed=1234); print(a0@exemplars)
cl<-integer(150); for(i in seq_along(a0@clusters)) cl[a0@clusters[[i]]]<-i; print(table(cl,iris$Species))
print(preferenceRange(negDistMat(r=2,X)))
