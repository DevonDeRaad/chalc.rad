#
#investigate missing data in the chlacophaps dataset

#devtools::install_github("DevonDeRaad/RADstackshelpR")
library(RADstackshelpR)

#check out what's going on with missingness between samples
vcf<-vcfR::read.vcfR("~/Desktop/chalcophaps.rad/m3.vcf")
missing.by.sample(vcf)
missing.by.snp(vcf)
#we have 41 samples, with 4664 SNPs retained at 60% completeness, and 346 SNPs retained at 80% completeness

light.vcf<-missing.by.sample(vcf, cutoff=.9)
missing.by.snp(light.vcf)
#after light filtering, we retain 38 samples, with 5694 SNPs at 60% complete, and 376 SNPs at 80% complete

#the strongly bimodal distribution of missing data by sample indicates potential batch effect or just bimodal sequencing outcomes
vcf.agg<-missing.by.sample(vcf, cutoff = .85)
missing.by.snp(vcf.agg)
#surprisingly, removing the most missing samples isn't accounting for this bimodality, and isn't fixing our problem

#I feel relatively confident that this is a batch effect because the samples driving it
#are not simply the ones with the most missing data 
#I think this means that even though the samples sequenced fine, the SNPs retained are largely non-overlapping
#it is only after filtering to 60% missing data that the batch effect appears
#Need to drop the samples that are missing data outliers after filtering
vcf.60<-missing.by.snp(vcf, cutoff=.6)
#shows me the list of the 10 problem samples

#subset the vcf to remove these 10 samples only
vcf@gt<-vcf@gt[,colnames(vcf@gt) != "Chalc.indi.WAM.22872" & colnames(vcf@gt) != "Chalc.indi.AMNH.21441" & colnames(vcf@gt) != "Chalc.indi.CAS.777" & colnames(vcf@gt) != "Chalc.indi.ANWC.B55964" & colnames(vcf@gt) != "Chalc.indi.AMNH.21534" 
               & colnames(vcf@gt) != "Chalc.indi.AMNH.21572" & colnames(vcf@gt) != "Chalco.step.KU.27832" & colnames(vcf@gt) != "Chalco.step.KU.12228" & colnames(vcf@gt) != "Chalco.step.WAM.26645" & colnames(vcf@gt) != "Chalc.indi.AMNH.21615"]

vcf
missing.by.snp(vcf)

#by removing potential batch effect samples, we retain 31 samples with 10846 SNPs at 60% complete, 3912 SNPs at 80% complete

sampling<-read.csv("chalc.sampling.csv")

new.sampling<-sampling[sampling$id %in% colnames(vcf@gt),]

new.sampling[,c(1,9,10)]
