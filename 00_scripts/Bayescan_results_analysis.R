#############################
## Analyse Bayescan output ##
#############################
# CMO Reisser Mar. 2020

ls()
rm(list=ls())
ls()



# Install and load the packages necessary for the analysis of Bayescan output
library(coda)
library(ggplot2)
library(vcfR)

# Change path to fit your needs
setwd("/PERSIST")
fst_tab="06_bayescan/PERSIST_bayescan_out_fst.txt"
sel_table="06_bayescan/PERSIST_bayescan_out.sel"
vcf_file="05_freebayes/PERSIST_noComplex_Collector.recode.vcf"
outdir="06_bayescan"

#Read the data in:
chain <- read.table(sel_table,header=TRUE)
chain<-chain[-c(1)]

#Create an MCMC object with the correct thinning interval (in GAMMA it is 10).
chain <- mcmc(chain,thin=10)

# Open a pdf file
#pdf("rplot_GAMMA_bayescan_chain.pdf")
#plot(chain)
# Close the pdf file
#dev.off() 


#Obtaining summary statistics for the MCMC chain
sum<-summary(chain)
stats<-sum$statistics[1:2,]
quant<-sum$quantiles[1:2,]
stats
quant

write.table(stats, paste(outdir,"Statistics_Fsts.txt",sep=""),row.names=T,col.names=T,quote=F,sep="\t")
write.table(quant, paste(outdir,"Quantiles_Fsts.txt",sep=""),row.names=T,col.names=T,quote=F,sep="\t")

acceptanceRate <- 1 - rejectionRate(chain)
acceptanceRate


#Plot the result with the function provided in bayescan2:
plot_bayescan<-function(res,FDR=0.05,size=1,pos=0.35,highlight=NULL,name_highlighted=F,add_text=T)
{
  if (is.character(res))
    res=read.table(res)
  
  colfstat=5
  colq=colfstat-2
  
  highlight_rows=which(is.element(as.numeric(row.names(res)),highlight))
  non_highlight_rows=setdiff(1:nrow(res),highlight_rows)
  
  outliers=as.integer(row.names(res[res[,colq]<=FDR,]))
  
  ok_outliers=TRUE
  if (sum(res[,colq]<=FDR)==0)
    ok_outliers=FALSE;
  
  res[res[,colq]<=0.0001,colq]=0.0001
  
  # plot
  plot(log10(res[,colq]),res[,colfstat],xlim=rev(range(log10(res[,colq]))),xlab="log10(q value)",ylab=names(res[colfstat]),type="n")
  points(log10(res[non_highlight_rows,colq]),res[non_highlight_rows,colfstat],pch=19,cex=size)
  
  if (name_highlighted) {
    if (length(highlight_rows)>0) {
      text(log10(res[highlight_rows,colq]),res[highlight_rows,colfstat],row.names(res[highlight_rows,]),col="red",cex=size*1.2,font=2)
    }
  }
  else {
    points(log10(res[highlight_rows,colq]),res[highlight_rows,colfstat],col="red",pch=19,cex=size)
    # add names of loci over p and vertical line
    if (ok_outliers & add_text) {
      text(log10(res[res[,colq]<=FDR,][,colq])+pos*(round(runif(nrow(res[res[,colq]<=FDR,]),1,2))*2-3),res[res[,colq]<=FDR,][,colfstat],row.names(res[res[,colq]<=FDR,]),cex=size)
    }
  }
  lines(c(log10(FDR),log10(FDR)),c(-1,1),lwd=2)
  
  return(list("outliers"=outliers,"nb_outliers"=length(outliers)))
}


#Plotting results:
fst<-read.table(fst_tab,header=T,row.names = 1)
pdf(paste(outdir,"rplot_bayescan_fst.pdf",sep=""))
plot_bayescan(fst)
dev.off() 


# Get the significant ones:
sig<-fst[fst$qval<0.05,]

vcf<-read.vcfR(vcf_file)
dim(vcf)

names<-cbind(c(1:nrow(vcf@fix)),vcf@fix[,1],vcf@fix[,2])

write.table(names,paste(outdir,"locus_id.txt",sep=""),row.names=F,col.names=F,quote=F,sep="\t")
write.table(sig,paste(outdir,"PERSIST_bayescan_significant.txt",sep=""),row.names=T,col.names=T,quote=F,sep="\t")
               
#Make a manhattan like plot:


pdf(paste(outdir,"rplot_manhattan-like_fst.pdf",sep=""))
plot(-log(fst$qval,10),pch=20,frame=F,ylim=c(0,5),xlim=c(0,30000),ylab="-log(q-value)")
abline(a=-log(0.05,10),b=0,col="red")
dev.off()

