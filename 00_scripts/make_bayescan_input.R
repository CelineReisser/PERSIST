###############################
## R code for bayescan input ##
###############################
#CMO. Reisser Jan. 2020



#Get VCF into R
library(vcfR)
library(plyr)

setwd("/PERSIST")

#Read VCF
vcf<-read.vcfR("05_freebayes/PERSIST_noComplex_Collector.recode.vcf")
vcf
#get allelic frequencies
test2<-gt.to.popsum(vcf)

#Create a new variable to store number of alleles at each site for the population
test2$nAlleles<-rep("2",length(rownames(test2)))
test2

#Create a new variable to transform the counts of the homozygous loci for reference allele
i<-0
test2$Alleles_counts2<-rep("NA",length(rownames(test2)))
for(i in 1:length(rownames(test2))){
  if(test2$Allele_counts[i]==as.character(test2$n[1]*2)){
    test2$Allele_counts2[i]=paste(test2$n[1]*2,",",0,sep="")}
  else
    test2$Allele_counts2[i]=as.character(test2$Allele_counts[i])
}

#Replace comma by space in allelic count column
test2$Allele_counts2<-sapply(test2$Allele_counts2, gsub, pattern=",", replacement=" ")

#Create object with all the data necessary
pop1<-cbind(rownames(test2),test2$n*2,test2$nAlleles,test2$Allele_counts2)
write.table(pop1,"06_bayescan/Collector_bayescan_input.txt",sep="\t",quote=F,row.names=F,col.names=F)


# Do the same for pop2:
vcf<-read.vcfR("05_freebayes/PERSIST_noComplex_Exploited.recode.vcf")
vcf
test<-gt.to.popsum(vcf)
test
nn<-test$n[1]*2
test$nAlleles<-rep("2",length(rownames(test)))

i<-0
test$Alleles_counts2<-rep("NA",length(rownames(test)))
for(i in 1:length(rownames(test))){
  if(test$Allele_counts[i]==as.character(test$n[1]*2)){
    test$Allele_counts2[i]=paste(test$n[1]*2,",",0,sep="")}
  else
    test$Allele_counts2[i]=as.character(test$Allele_counts[i])
}

test$Allele_counts2<-sapply(test$Allele_counts2, gsub, pattern=",", replacement=" ")

pop2<-cbind(rownames(test),test$n*2,test$nAlleles,test$Allele_counts2)
write.table(pop2,"06_bayescan/Exploited_bayescan_input.txt",sep="\t",quote=F,row.names=F,col.names=F)

# Do the same for pop3:
vcf<-read.vcfR("05_freebayes/PERSIST_noComplex_Natural.recode.vcf")
vcf
test<-gt.to.popsum(vcf)
test
nn<-test$n[1]*2
test$nAlleles<-rep("2",length(rownames(test)))

i<-0
test$Alleles_counts2<-rep("NA",length(rownames(test)))
for(i in 1:length(rownames(test))){
    if(test$Allele_counts[i]==as.character(test$n[1]*2)){
        test$Allele_counts2[i]=paste(test$n[1]*2,",",0,sep="")}
    else
    test$Allele_counts2[i]=as.character(test$Allele_counts[i])
}

test$Allele_counts2<-sapply(test$Allele_counts2, gsub, pattern=",", replacement=" ")

pop2<-cbind(rownames(test),test$n*2,test$nAlleles,test$Allele_counts2)
write.table(pop2,"06_bayescan/Natural_bayescan_input.txt",sep="\t",quote=F,row.names=F,col.names=F)

