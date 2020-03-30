####################################################
## Heterozygosity and inbreeding coeff. plotting  ##
####################################################
# C. Reisser


##  I.   clear environment and set working directory
######################################################

ls()
rm(list=ls())
ls()
set.seed(99)

#Load all the packages needed:

library(ggplot2)
library(reshape)
library(ggpubr)
library(dplyr)
library(plyr)
library(dunn.test)
library(FSA)
library(related)
library(ggpubr)
#install.packages("related",repos="http://R-Forge.R-project.org")



# Calculating inbreeding coefficients:

data<-readgenotypedata("../../02_data/relatedness/input_related_global_transposed_final.txt")
data

# with guellergt:
outfile<-coancestry(data$gdata,quellergt = 2,ci95.num.bootstrap=1000)
mat<-cbind(outfile$relatedness$pair.no,outfile$relatedness$quellergt)


names(outfile)
outfile$inbreeding #quelque chose a faire avec ca...
outfile$relatedness[1,]
min(outfile$relatedness$quellergt)
max(outfile$relatedness$quellergt)
mean(outfile$relatedness$quellergt)

mat<-cbind(outfile$relatedness$pair.no,outfile$relatedness$quellergt)


#see inbreeding:
outfile$inbreeding

E1<-1:25
E2<-26:56
E3<-57:81
E4<-82:92
E5<-93:120
E6<-121:136
S2<-137:147
S3<-148:164
S4<-165:184
S5<-185:195
S6<-196:210
S7<-211:220
C1<-221:224
C2<-225:225
C3<-226:246
C4<-247:250
C5<-251:258


#outfile$inbreeding$LH[md]
#NHD<-outfile$inbreeding$LH[md]
#NHS<-outfile$inbreeding$LH[ms]
#UA<-outfile$inbreeding$LH[mu]
#KA<-outfile$inbreeding$LH[ka]
#AR<-outfile$inbreeding$LH[ar]
#TK<-outfile$inbreeding$LH[tk]
#AU<-outfile$inbreeding$LH[au]

outfile$inbreeding$LH[md]# grab inbreeding values for each populations
e1<-outfile$inbreeding$LH[E1]
e2<-outfile$inbreeding$LH[E2]
e3<-outfile$inbreeding$LH[E3]
e4<-outfile$inbreeding$LH[E4]
e5<-outfile$inbreeding$LH[E5]
e6<-outfile$inbreeding$LH[E6]
s2<-outfile$inbreeding$LH[S2]
s3<-outfile$inbreeding$LH[S3]
s4<-outfile$inbreeding$LH[S4]
s5<-outfile$inbreeding$LH[S5]
s6<-outfile$inbreeding$LH[S6]
s7<-outfile$inbreeding$LH[S7]
c1<-outfile$inbreeding$LH[C1]
c2<-outfile$inbreeding$LH[C2]
c3<-outfile$inbreeding$LH[C3]
c4<-outfile$inbreeding$LH[C4]
c5<-outfile$inbreeding$LH[C5]

# test normality
shapiro.test(e1)
shapiro.test(e2)
shapiro.test(e3) #normal
shapiro.test(e4) #normal
shapiro.test(e5) #normal
shapiro.test(e6) #normal
shapiro.test(s2) #normal
shapiro.test(s3) #normal
shapiro.test(s4)
shapiro.test(s5) #normal
shapiro.test(s6) #normal
shapiro.test(s7) #normal
shapiro.test(c1) #normal
shapiro.test(c2) #normal
shapiro.test(c3) #normal
shapiro.test(c4) #normal
shapiro.test(c5) #normal


# Krustal Wallis for non parametric and multiple samples comparison:

values<-as.vector(c(e1,e2,e3,e4,e5,e6,s2,s3,s4,s5,s6,s7,c1,c2,c3,c4,c5))
values
names<-as.vector(c(rep("e1",length(e1)),rep("e2",length(e2)),rep("e3",length(e3)),rep("e4",length(e4)),rep("e5",length(e5)),rep("e6",length(e6)),rep("s2",length(s2)),rep("s3",length(s3)),rep("s4",length(s4)),rep("s5",length(s5)),rep("s6",length(s6)),rep("s7",length(s7)),rep("c1",length(c1)),rep("c2",length(c2)),rep("c3",length(c3)),rep("c4",length(c4)),rep("c5",length(c5))))
names
tt<-matrix(data=c(names,values),nrow=2,byrow = T)
tt2<-as.data.frame(t(tt))
names(tt2)<-c("POP","LH")
tt2

kruskal.test(LH ~ POP, data = tt2)

#make boxplot of inbreeding coefficient:
boxplot(e1,e2,e3,e4,e5,e6,s2,s3,s4,s5,s6,s7,c1,c2,c3,c4,c5,xaxt='n')
axis(side = 1, at = 1:17, lab = c("E1","E2","E3","E4","E5","E6","S2","S3","S4","S5","S6","S7","C1","C2","C3","C4","C5"),cex.axis=0.8)

couleurs=c(c("grey","grey40","gray39","gray17","black"),c("chocolate","brown","darkorange4","indianred3","magenta","plum"),c("cadetblue1","dodgerblue","navyblue","forestgreen","olivedrab","darkgreen"))

p<-ggplot(tt2,aes(factor(tt2$POP),as.numeric(as.character(tt2$LH))))+geom_boxplot(aes(fill=tt2$POP),notch = F) + scale_fill_manual(name="Populations",values=couleurs) + ylab("Inbreeding coefficient") + xlab("Populations") +scale_x_discrete(labels= c("C1","C2","C3","C4","C5","E1","E2","E3","E4","E5","E6","S2","S3","S4","S5","S6","S7")) + theme(legend.position = "none")
p





###############################################################################################
###############################################################################################
###     Plotting heterozygosity:
###############################################################################################
###############################################################################################



collhet<-read.table("../../02_data/stats_popVCF/Collector_het.txt",header=T)
exphet<-read.table("../../02_data/stats_popVCF/Exploited_het.txt",header=T)
nathet<-read.table("../../02_data/stats_popVCF/Natural_het.txt",header=T)


collhet<-as.numeric(collhet$O.HOM./collhet$N_SITES)
popcoll<-c("C3","C3","C3","C5","C3","C1","C4","C3","C3","C5","C5","C3","C3","C4","C5","C5","C4","C3","C1","C3","C4","C3","C3","C3","C5","C3","C3","C3","C3","C5","C3","C2","C1","C3","C3","C5","C3","C1")
exphet<-as.numeric(exphet$O.HOM./exphet$N_SITES)
popexp<-c("E3","E5","E1","E2","E3","E2","E1","E2","E5","E6","E1","E6","E4","E3","E4","E5","E2","E2","E2","E2","E3","E1","E4","E6","E2","E2","E2","E3","E6","E5","E2","E2","E6","E1","E1","E2","E5","E5","E6","E6","E3","E1","E2","E5","E3","E6","E5","E3","E1","E1","E3","E5","E3","E3","E3","E2","E6","E4","E3","E5","E1","E4","E2","E3","E1","E5","E3","E1","E4","E2","E4","E3","E6","E2","E1","E1","E2","E2","E3","E2","E1","E5","E2","E1","E5","E1","E1","E5","E2","E1","E5","E5","E6","E6","E5","E1","E1","E3","E4","E3","E5","E1","E6","E4","E4","E3","E3","E5","E2","E1","E5","E4","E2","E5","E6","E2","E1","E3","E3","E2","E5","E3","E2","E5","E5","E3","E5","E5","E6","E2","E1","E2","E5","E6","E5","E2")
nathet<-as.numeric(nathet$O.HOM./nathet$N_SITES)
popnat<-c("S3","S4","S4","S5","S7","S6","S4","S4","S3","S6","S4","S7","S2","S3","S4","S3","S6","S4","S3","S6","S4","S4","S4","S7","S5","S3","S2","S4","S2","S3","S7","S5","S6","S5","S4","S3","S2","S2","S7","S6","S4","S6","S6","S5","S2","S4","S2","S3","S6","S7","S5","S3","S3","S6","S4","S6","S6","S4","S2","S6","S3","S2","S3","S3","S3","S7","S3","S5","S5","S7","S3","S7","S6","S4","S2","S4","S4","S4","S6","S2","S5","S5","S5","S7")
het<-1-as.numeric(c(collhet,exphet,nathet))

het
pop<-c(rep(1,length(collhet)),rep(2,length(exphet)),rep(3,length(nathet)))
pop
site<-c(popcoll,popexp,popnat)

data<-matrix(data=NA,nrow=length(het),ncol=3)
data[,1]<-het
data[,2]<-pop
data[,3]<-site
colnames(data)<-c("het","pop","site")
data
data2<-as.data.frame(data)
data2
data2$pop<-as.factor(data2$pop)
data2$pop<-revalue(data2$pop, c("1"="Collected", "2"="Exploited","3"="Natural"))
data2

couleurs=c(c("grey","grey40","gray39","gray17","black"),c("chocolate","brown","darkorange4","indianred3","magenta","plum"),c("cadetblue1","dodgerblue","navyblue","forestgreen","olivedrab","darkgreen"))

#see het per stock:
q <- ggplot(data2,aes(x=as.factor(pop),y=as.numeric(as.character(het)))) + geom_jitter(aes(colour=site),shape=16, position=position_jitter(0.2),size=4,alpha=0.7)+ geom_boxplot(alpha = 0)
q <- q + xlab("populations") + ylab("Observed heterozygosity within individuals") + scale_colour_manual(values=couleurs) + facet_grid(~pop,scales="free")
q


#performing test of Kruskal wallis on stock:
data2
as.numeric(as.character(data2$het))
kruskal.test(as.numeric(as.character(data2$het)) ~ data2$pop)
dunnTest(as.numeric(as.character(data2$het)),data2$pop,method="bonferroni")

#try to separate the northeast natural from the southwest natural
data2$relevel<-data2$site
data2$relevel<-revalue(data2$relevel, c("S2"="Natural_SW","S3"="Natural_SW","S4"="Natural_SW","S5"="Natural_NE","S6"="Natural_NE","S7"="Natural_NE","E1"="Exploited","E2"="Exploited","E3"="Exploited","E4"="Exploited","E5"="Exploited","E6"="Exploited","C1"="Collector","C2"="Collector","C3"="Collector","C4"="Collector","C5"="Collector"))
data2

kruskal.test(as.numeric(as.character(data2$het)) ~ data2$relevel)
dunnTest(as.numeric(as.character(data2$het)),data2$relevel,method="bonferroni")


#Make a global plot of heterozygosity and inbreeding coefficient:

library(ggpubr)
ggarrange(q,p,labels=c("A","B"),ncol=2)
