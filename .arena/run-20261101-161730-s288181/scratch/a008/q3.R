suppressMessages({library(apcluster); library(cluster)})
ari <- function(a,b){ t<-table(a,b); n<-sum(t); c2<-function(x) sum(choose(x,2))
  e<-c2(rowSums(t))*c2(colSums(t))/choose(n,2); m<-(c2(rowSums(t))+c2(colSums(t)))/2; (c2(t)-e)/(m-e)}
x <- scale(iris[,1:4]); s <- negDistMat(x, r=2); D <- -s
for (q in c(0,0.5)) {
 ap <- apcluster(s, q=q, seed=1234); k <- length(ap@exemplars); cl <- labels(ap,"enum")
 cost_ap <- sum(D[cbind(1:150, ap@exemplars[cl])])
 pm <- pam(as.dist(D), k=k, diss=TRUE); cost_pam <- sum(D[cbind(1:150, pm$id.med[pm$clustering])])
 set.seed(1234); km <- kmeans(x, k, nstart=25)
 cat(sprintf("q=%.1f k=%d cost_AP=%.2f cost_PAM=%.2f ARI_AP=%.3f ARI_PAM=%.3f ARI_KM=%.3f\n", q,k,cost_ap,cost_pam, ari(cl,iris$Species), ari(pm$clustering,iris$Species), ari(km$cluster,iris$Species)))
}
cat(sum(duplicated(iris[,1:4])), "doublons\n")
