# Recherche bibliographique — stratégie et références initiales

## Requêtes Google ciblées
Les requêtes `intitle:"index of"` cherchent des répertoires exposés ; elles ne filtrent pas nécessairement les publications scientifiques et peuvent renvoyer des fichiers non pertinents. Privilégier d'abord les pages d'éditeurs, dépôts institutionnels, DOI, PubMed Central, NeurIPS et sites universitaires.

### Répertoires PDF récents
```text
intitle:"index of" ("affinity propagation" OR affinity_propagation) (2025 OR 2026) (pdf OR papers OR publications) -cgi-bin -icons -login
intitle:"index of" ("affinity propagation") ("2025" OR "2026") (pdf) (papers OR attachments OR publications) -cgi-bin -icons
intitle:"index of" /attachments/papers/ "affinity propagation" (pdf OR 2025 OR 2026)
intitle:"index of" /papers/ "affinity propagation" filetype:pdf
intitle:"index of" ("affinity propagation" OR "message passing clustering") (2024 OR 2025 OR 2026) filetype:pdf
```

### Stanford et MIT
```text
site:stanford.edu "affinity propagation" (filetype:pdf OR paper OR clustering)
site:ai.stanford.edu "affinity propagation" filetype:pdf
site:mit.edu "affinity propagation" (filetype:pdf OR clustering)
site:csail.mit.edu "affinity propagation" filetype:pdf
site:edu "affinity propagation" (2024 OR 2025 OR 2026) filetype:pdf
```

### Cas d'usage précis
```text
"affinity propagation" case study experimental data 2025 pdf
"affinity propagation" real-world dataset benchmark 2024 2025 pdf
"affinity propagation" exemplars image segmentation gene expression application
"affinity propagation" intrusion detection NSL-KDD 2024
"affinity propagation" experimental condition selection combustion 2024
"incremental affinity propagation" diachronic corpus 2025 pdf
```

### Limites et comparaisons
```text
"affinity propagation" limitations preference parameter sensitivity benchmark
"affinity propagation" versus k-medoids hierarchical clustering empirical comparison
"affinity propagation" O(n^2) memory scalability large dataset
"soft-constraint affinity propagation" gene expression 2007 pdf
```

## Références vérifiées au niveau de la notice / page éditeur

1. Frey, B. J. & Dueck, D. (2007). *Clustering by passing messages between data points*. Science, 315, 972–976. DOI: https://doi.org/10.1126/science.1136800. Notice : https://pubmed.ncbi.nlm.nih.gov/17218491/
2. Frey, B. J. & Dueck, D. (2005). *Mixture Modeling by Affinity Propagation*. NeurIPS 18. https://proceedings.neurips.cc/paper/2005/hash/327708dd10d68b1361ad3addbaca01f2-Abstract.html
3. Leone, M., Sumedha & Weigt, M. (2007). *Clustering by soft-constraint affinity propagation: applications to gene-expression data*. Bioinformatics, 23(20), 2708–2715. DOI: https://doi.org/10.1093/bioinformatics/btm414
4. Duan, G. & Zou, C. (2024). *A clustering effectiveness measurement model based on merging similar clusters*. PeerJ Computer Science, 10:e1863. DOI: https://doi.org/10.7717/peerj-cs.1863. Open access: https://pmc.ncbi.nlm.nih.gov/articles/PMC10909172/
5. Wang, Y. et al. (2024). *Clustering algorithm for experimental datasets using global sensitivity-based affinity propagation (GSAP)*. Combustion and Flame, 259, 113121. DOI: https://doi.org/10.1016/j.combustflame.2023.113121
6. Periti, F. et al. (2025). *Incremental Affinity Propagation Based on Cluster Consolidation and Stratification*. Neural Processing Letters, 57, article 44. DOI: https://doi.org/10.1007/s11063-025-11752-y. Open access.
7. Almazroi, A. A. & Atwa, W. (2024). *Semi-Supervised Clustering Algorithms Through Active Constraints*. International Journal of Advanced Computer Science and Applications, 15(7). DOI: https://doi.org/10.14569/IJACSA.2024.0150733. Open access.
8. *Constructing Treatment Portfolios Using Affinity Propagation* (PDF hosted at Stanford AI; affiliations span Toronto and Microsoft Research, including a Stanford affiliation among the authors): https://ai.stanford.edu/~vjojic/recomb08.pdf. Treat the hosting domain and author affiliations as separate facts.

## Fiche d'extraction à remplir pour chaque article
- Référence complète / DOI / date :
- Institution et affiliation réelle des auteurs :
- Type de publication et revue/conférence :
- Accès intégral et licence :
- Question pratique :
- Jeu de données, taille, provenance :
- Similarité / distance et prétraitement :
- Version AP et paramètres :
- Comparateurs et métriques :
- Résultats effectivement rapportés :
- Code/données disponibles :
- Limites et risques de biais :
- Utilité pour notre projet :
