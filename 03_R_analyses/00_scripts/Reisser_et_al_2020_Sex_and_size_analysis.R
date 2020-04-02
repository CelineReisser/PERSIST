#############################################
##        Sex and size comparisons         ##
#############################################
# Reisser et al. 2020


##  I.   clear environment and set working directory
ls()
rm(list=ls())
ls()
set.seed(99)

library(ggplot2)
library(ggpubr)

data<-read.table("../02_data/sex_size_input.txt",header=T)
data
names(data)
levels(data$stock)<-c("Exploited","Natural")
is.numeric(data$L)
data2<-as.matrix(data)
data2
data2

couleurs=c(c("chocolate","brown","darkorange4","indianred3","magenta","plum"),c("blue","cadetblue1","dodgerblue","navyblue","forestgreen","olivedrab","darkgreen"))

q <- ggplot(data,aes(x=site,y=L,fill=site))+ geom_boxplot(alpha=0.7) + stat_summary(fun.y=median, geom="point", size=1, color="black")
q <- q + xlab("Sites") + ylab("Length (cm)")+ scale_fill_manual(values=couleurs) + theme_gray() + guides(fill=guide_legend(ncol=2))
q <- q + facet_grid(cols=vars(data$stock),scales="free") +theme_gray(base_size = 18)
q

#get the density plot of length (removed from article)
p <- ggplot(data, aes(x=L,fill=stock)) + 
  geom_density(alpha=0.6) + scale_fill_manual(values=c("brown","cadetblue")) 
p <- p + xlab("Length (cm)")+theme_gray(base_size = 18)
p
r <- ggarrange(p,q,nrow=2,ncol=1,labels=c("A","B"))


# Dealing with sex info:
Df<-data
Df$cut <- cut(Df$L, seq(5,25,by=2))
s <- ggplot(Df,aes(x=cut,fill=sex))+ geom_histogram(stat="count") + facet_grid(stock ~ .) + xlab("Length range (cm)") + scale_fill_manual(values=c("brown","grey28","dodgerblue"),labels=c("Female","Undetermined","Male"))
s <- s +theme_gray(base_size = 18)
s

#see sex ratio per site:
Df<-data
t <- ggplot(Df,aes(x=site,fill=sex))+ geom_histogram(stat="count") + facet_grid("stock", scales = "free") + xlab("Populations") + scale_fill_manual(values=c("brown","grey28","dodgerblue"),labels=c("Female","Undetermined","Male"))
t <- t +theme_gray(base_size = 18)
t

r <- ggarrange(q,s,t,nrow=3,ncol=1,labels=c("A","B","C"),heights = c(1, 1.1, 1.1))
r

# get values of sex ratio for all sites sampled:

data$site
E1<-data[data$site=="E1",]
E1
nrow(E1[E1$sex=="F",])/(nrow(E1[E1$sex=="F",])+nrow(E1[E1$sex=="M",]))

E2<-data[data$site=="E2",]
E2 
nrow(E2[E2$sex=="F",])/(nrow(E2[E2$sex=="F",])+nrow(E2[E2$sex=="M",]))

E3<-data[data$site=="E3",]
E3 
nrow(E3[E3$sex=="F",])/(nrow(E3[E3$sex=="F",])+nrow(E3[E3$sex=="M",]))

E4<-data[data$site=="E4",]
E4 
nrow(E4[E4$sex=="F",])/(nrow(E4[E4$sex=="F",])+nrow(E4[E4$sex=="M",]))

E5<-data[data$site=="E5",]
E5 
nrow(E5[E5$sex=="F",])/(nrow(E5[E5$sex=="F",])+nrow(E5[E5$sex=="M",]))

E6<-data[data$site=="E6",]
E6 
nrow(E6[E6$sex=="F",])/(nrow(E6[E6$sex=="F",])+nrow(E6[E6$sex=="M",]))

S1<-data[data$site=="N1",]
S1 
nrow(S1[S1$sex=="F",])/(nrow(S1[S1$sex=="F",])+nrow(S1[S1$sex=="M",]))

S2<-data[data$site=="N2",]
S2 
nrow(S2[S2$sex=="F",])/(nrow(S2[S2$sex=="F",])+nrow(S2[S2$sex=="M",]))

S3<-data[data$site=="N3",]
S3 
nrow(S3[S3$sex=="F",])/(nrow(S3[S3$sex=="F",])+nrow(S3[S3$sex=="M",]))

S4<-data[data$site=="N4",]
S4 
nrow(S4[S4$sex=="F",])/(nrow(S4[S4$sex=="F",])+nrow(S4[S4$sex=="M",]))

S5<-data[data$site=="N5",]
S5 
nrow(S5[S5$sex=="F",])/(nrow(S5[S5$sex=="F",])+nrow(S5[S5$sex=="M",]))

S6<-data[data$site=="N6",]
S6 
nrow(S6[S6$sex=="F",])/(nrow(S6[S6$sex=="F",])+nrow(S6[S6$sex=="M",]))

S7<-data[data$site=="N7",]
S7
nrow(S7[S7$sex=="F",])/(nrow(S7[S7$sex=="F",])+nrow(S7[S7$sex=="M",]))

