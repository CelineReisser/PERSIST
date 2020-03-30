#############################################
##     Unsupervised clustering and DAPC    ##
#############################################
# Reisser et al. 2020


##  I.   clear environment and set working directory
####################################################

ls()
rm(list=ls())
ls()
set.seed(99)

#     SET WD TO SOURCE FILE LOCATION (SCRIPT FOLDER)




##  II.   load packages
############################################################

#Load all the packages needed:
library(radiator)
library(adegenet)
library(vcfR)
library(ggplot2)
library(plotly)
library(plyr)
library(dplyr)
library(hierfstat)
library(cluster)
library(zoo)
library(dartR)
library(vegan)
library(reshape)
library(ggpubr)
library(assigner)




##  III.   Get data in and set it up
############################################################

# Performing assignation of collected individuals on dapc2
#Load data input:
# VCF/genotypes
#vcf<-read.vcfR("../02_data/All_data_selected.vcf")
vcf2<-read.vcfR("../02_data/All_data_neutral.vcf")
data2<-vcfR2genlight(vcf2)



#adding metadata to genlight object

data2$pop<-as.factor(substr(data2$ind.names,1,2))
data2$pop

metadata<-read.table("../02_data/Metadata.txt",header=T)
metadata
str(metadata)
strata<-cbind(as.character(metadata$ind),as.character(metadata$site))
strata<-as.data.frame(strata)
names(strata)<-c("INDIVIDUALS","STRATA")
strata



## IV.  FST calculations:
############################################################

# Put data in a radiator object:
dat<-tidy_genomic_data(data2,strata=strata)
dat$POP_ID

fst.ci <- fst_WC84(data = dat, 
                   pop.levels = c("C1","C2","C3", "C4", "C5", "E1", "E2", "E3", "E4", "E5", "E6", "S2", "S3", "S4", "S5", "S6", "S7"),
                   pairwise = TRUE,
                   ci = TRUE,
                   iteration.ci=5000,
                   quantiles.ci = c(0.025, 0.975),
                   parallel.core = 12,
                   filename = "testing_fst",
                   verbose = TRUE)

# Do the heatmap prettier:
fst.matrix <- fst.ci$pairwise.fst.full.matrix
fst.ci.matrix<-fst.ci$pairwise.fst.ci.matrix

heatmap_fst(fst.matrix, fst.ci.matrix, n.s = TRUE,
            digits = 3, color.low = "yellow", color.mid = "orange",
            color.high = "brown", text.size = 4, plot.size = 40,
            pop.levels = c("C1","C2","C3", "C4", "C5", "E1", "E2", "E3", "E4", "E5", "E6", "S2", "S3", "S4", "S5", "S6", "S7"), path.folder = NULL, filename = NULL)

fst.ci
save(fst.ci, file="../03_results/Fst_CI_all_populations.R")
names(fst.ci)
df <- fst.ci$pairwise.fst


# to see as a tibble:
fst.matrix <- tibble::as_tibble(fst.ci$pairwise.fst.full.matrix, rownames = "POP")
# to keep matrix:
fst.matrix <- fst.ci$pairwise.fst.full.matrix
fst.ci.matrix<-fst.ci$pairwise.fst.ci.matrix
write.table(fst.matrix,"../03_results/PairwiseFst_sites_bootstraps_imputed.txt",quote=F)
write.table(fst.ci.matrix,"../03_results/PairwiseFst_sites_bootstraps_CI_imputed.txt",quote=F)

#make a clustering of samples based on Fst values
fst.matrix2<-as.dist(fst.matrix)
test<-hclust(fst.matrix2,method="average")
plot(test,xlab="UPGMA tree based on individual pairwise Fst values")



## V. Identify the number of clusters in the data (unsupervised):
############################################################
data<-gl2gi(data2)
data@pop
unsup.clust<-find.clusters(data,stat="AIC")
180
2
table(unsup.clust$grp)


## VI. Check the number of axes relevant for DAPC analysis using groupings from the find cluster result:
############################################################

xval <- xvalDapc(as.data.frame(data@tab),grp=unsup.clust$grp,result = "groupMean", center = T, scale = FALSE, n.rep = 30, xval.plot = TRUE)
xval #80 axes as optimum


## VII. Now perform the DAPC using groupings from the unsupervised clustering:
############################################################

dapc1<-dapc(data,pop=unsup.clust$grp,n.pca=80,n.da=1)


#extract info to construct plots:
dapc1.plot<-as.matrix(dapc1$ind.coord)
dapc1.plot
dapc1.plot2<-cbind(as.numeric(dapc1.plot[,1]),unsup.clust$grp,substr(rownames(dapc1.plot),1,2))
colnames(dapc1.plot2)<-c("DA1","clustGrp","site")
dapc1.plot2
final<-as.data.frame(dapc1.plot2)
final


## VIII. Plotting DAPC results
############################################################

#defining colour palettes:
couleurs=c(c("grey","grey40","gray39","gray17","black"),c("chocolate","brown","darkorange4","indianred3","magenta","plum"),c("cadetblue1","dodgerblue","navyblue","forestgreen","olivedrab","darkgreen"))
mycol=c("black","grey")

#scatter of unsupervised clusters:
p <- ggplot(data = final,aes(x=dapc1.plot[,1],fill=unsup.clust$grp)) + geom_density() + scale_fill_manual(name="Assignation",values=mycol,labels=c("Cluster1","Cluster2"))
p <- p + xlab("DA1") + theme_light(base_size = 15) + guides(color=guide_legend(ncol=2))
p

#See how populations are distributed in the clusters (pop info):
dapc.results <- as.data.frame(dapc1$posterior)
dapc.results
dapc.results$pop <- as.factor(data$pop)
dapc.results$indNames <- rownames(dapc.results)
dapc.results$clust <- final$clustGrp
dapc.results <- melt(dapc.results)
colnames(dapc.results) <- c("Original_Pop","Sample","Assigned_Pop","variable","Posterior_membership_probability")
dapc.results
levels(dapc.results$Assigned_Pop)<-c("Cluster1","Cluster2")

t <- ggplot(dapc.results, aes(x=Sample, y=Posterior_membership_probability, fill=Assigned_Pop))  + ylab(" ")
t <- t + geom_bar(stat='identity',width=1)
t <- t + scale_fill_manual(values = mycol,name="site") 
t <- t + facet_grid(~Original_Pop, scales = "free")
t <- t + theme_gray(base_size = 15) + guides(fill=guide_legend(ncol=1))
t <- t + theme(axis.text.x = element_blank(),axis.ticks = element_blank())
t

r <- ggarrange(p,t,nrow=2,ncol=1,labels = c("A","B"))
r

# Get the assignment table:
write.table(dapc.results,"../03_results/DAPC_2_cluster_compoplot_results.txt",quote=F,row.names=F)

