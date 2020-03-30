###############################################
##  Heatmap plot of the modelled dispersion  ##
###############################################
# Reisser et al 2020. 



ls()
rm(ls())

library(ggplot2)

# Change working directory to source file location



# Load the dataset:
data<-read.table("../02_data/Modelling_heatmap_input.txt")

# transform data to fit ggplot:
input<-as.data.frame(cbind(as.vector(t(data)),sort(rep(rownames(data),13)),c(rep(colnames(data),5)),rep(c(rep("Natural",7),rep("Exploited",6)),5)))
names(input)<-c("count","pop","source","stock")
input

# Plot the heatmap with geom_tile:
p<-ggplot(input,aes(x=source,y=pop)) +geom_tile(aes(fill=as.numeric(as.character(count)))) + scale_fill_gradient(low="white", high="red")
p<-p+ labs(fill="Larvae count") + facet_grid(~stock,scales="free")
p
