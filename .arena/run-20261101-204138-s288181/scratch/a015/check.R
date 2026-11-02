suppressMessages({library(apcluster); library(cluster)})
print(args(apcluster:::apcluster.matrix)); 
print(slotNames("APResult"))
x <- scale(iris[,1:4]); s <- negDistMat(x, r=2)
ap <- apcluster(s, seed=1234)
cat("default k=",length(ap@exemplars)," exemplars=",ap@exemplars," it=",ap@it,"\n")
for(q in c(0,0.05,0.1,0.2,0.3,0.5,0.9,1)){a<-apcluster(s,q=q,seed=1234); cat("q",q,"k",length(a@exemplars),"it",a@it,"\n")}
for(l in c(0.5,0.7,0.9)){a<-apcluster(s,lam=l,seed=1234); cat("lam",l,"k",length(a@exemplars),"it",a@it,"\n")}
a0<-apcluster(s,q=0,seed=1234); print(a0@exemplars); print(table(labels(a0,"enum"), iris$Species))
pr<-preferenceRange(s); print(pr)
# pam comparison k=3 sum sq dist
D<-as.matrix(dist(x))^2; k<-length(a0@exemplars)
p<-pam(as.dist(D),k=k,diss=TRUE)
cost<-function(med,cl) sum(D[cbind(seq_len(nrow(D)),med[cl])])
cat("AP cost",cost(a0@exemplars,labels(a0,"enum")),"pam cost",cost(p$id.med,p$clustering),"pam medoids",p$id.med,"\n")
# determinism without seed
e<-replicate(3, paste(apcluster(s)@exemplars,collapse=","));print(e)
