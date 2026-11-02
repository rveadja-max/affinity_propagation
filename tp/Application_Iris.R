# Application de l'algorithme Affinity Propagation sur le jeu de données pédagogique "Iris" inclut dans R

#package implémentant l'algorithme Affinity Propagation (ligne suivante à exécuter la première fois)
#install.packages("apcluster")
library(apcluster)

#chargement du dataset
data <- iris
dim(data)
head(data)
summary(data)

#exploration visuelle du jeu de données
plot(data$Petal.Width)
plot(data$Petal.Length)
plot(data$Sepal.Width)
plot(data$Sepal.Length)

#préparation du dataset
data_ap <- data[,1:4]
data_stand <- scale(data_ap)
  

#utilisation de l'algorithme Affinity Propagation
