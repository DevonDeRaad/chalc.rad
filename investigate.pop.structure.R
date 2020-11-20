library(RADstackshelpR)
library(vcfR)
library(adegenet)
library(ggplot2)
library(StAMPP)

#read in vcf as vcfR
vcfR <- read.vcfR("~/Desktop/chalcophaps.rad/m3.vcf")

#subset the vcf to remove the 10 samples with problematic batch effects
vcfR@gt<-vcfR@gt[,colnames(vcfR@gt) != "Chalc.indi.WAM.22872" & colnames(vcfR@gt) != "Chalc.indi.AMNH.21441" & colnames(vcfR@gt) != "Chalc.indi.CAS.777" & colnames(vcfR@gt) != "Chalc.indi.ANWC.B55964" & colnames(vcfR@gt) != "Chalc.indi.AMNH.21534" 
               & colnames(vcfR@gt) != "Chalc.indi.AMNH.21572" & colnames(vcfR@gt) != "Chalco.step.KU.27832" & colnames(vcfR@gt) != "Chalco.step.KU.12228" & colnames(vcfR@gt) != "Chalco.step.WAM.26645" & colnames(vcfR@gt) != "Chalc.indi.AMNH.21615"
               & colnames(vcfR@gt) != "Chalco.step.KU.6905" & colnames(vcfR@gt) != "Chalco.step.KU.7287" & colnames(vcfR@gt) != "Chalc.indi.WAM.22720"& colnames(vcfR@gt) != "Chalco.indi.KU.31155"]

#read in sampling file
sampling<-read.csv("~/Desktop/chalcophaps.rad/chalc.sampling.csv")

#subset out the samples that weren't affected by batch effect
new.sampling<-sampling[sampling$id %in% colnames(vcfR@gt),]

#generate new pop
popmap<-data.frame(id=new.sampling$id,pop=new.sampling$Species)

#hard filter to minimum depth of 5, and minimum genotype quality of 30
vcfR<-hard.filter.vcf(vcfR=vcfR, depth = 3, gq = 30)

#execute allele balance filter
vcfR<-filter.allele.balance(vcfR)

#visualize and pick appropriate max depth cutoff
max_depth(vcfR)
#filter vcf by the max depth cutoff you chose
vcfR<-max_depth(vcfR, maxdepth = 200)

#check vcfR to see how many SNPs we have left
vcfR

#missing by sample
dev.off()
miss<-missing.by.sample(vcfR=vcfR, popmap = popmap)

#run function to drop samples above the threshold we want from the vcf
#retain all samples
#vcfR<-missing.by.sample(vcfR=vcfR, cutoff = .91)

#visualize missing data by SNP and the effect of various cutoffs on the missingness of each sample
missing.by.snp(vcfR)

#choose a value that retains an acceptable amount of missing data in each sample
#and maximizes SNPs retained while minimizing overall missing data, and filter vcf
vcfR<-missing.by.snp(vcfR, cutoff = .75)

#use min.mac() to investigate the effect of multiple cutoffs
min_mac(vcfR = vcfR, popmap = popmap)

#do dapc
gen<- vcfR2genlight(vcfR)
grp<-find.clusters(gen, n.pca=30, n.clust=4)
#run dapc, retain all discriminant axes, and enough PC axes to explain 75% of variance
#dapc1<-dapc(gen, grp$grp)
#set manually the values I chose from scree plots
dapc1<-dapc(gen, grp$grp, n.da = 5, n.pca =6)
compoplot(dapc1, legend=FALSE, show.lab =TRUE, cex.names=.4)

#PCA
pca<-glPca(gen, nf=6)

#pull pca scores out of df
pca.scores<-as.data.frame(pca$scores)
pca.scores$species<-new.sampling$Species

#ggplot color by species
ggplot(pca.scores, aes(x=PC1, y=PC2, color=species)) +
  geom_point(cex = 2)

#calculate divergence btwn samples
gen@pop<-new.sampling$Species
inds<-stamppNeisD(gen, pop = FALSE)

#plot tree colored by subspecies
tree <- nj(inds)
plot(tree, type="unrooted", cex=.5)
ggtree(tree)+
  geom_tiplab(cex=1.8)

