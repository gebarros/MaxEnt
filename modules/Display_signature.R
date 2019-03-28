#This module shows the replicon signature based on Entropy Maximization of genomic regions.

#Reading file.
table<- read.csv(file="list_EM.csv", header=F, sep="\t", dec=",")
entropy<- as.vector(as.matrix(table))
n <- length(entropy)
genomic_regions <- c(1:n)
median_entropy<- median(entropy)

#Saving signature picture in pdf format.
pdf("Signature.pdf")
plot(genomic_regions,entropy,type="b", main="Signature", xlab="Genomic Regions", ylab="ME (log2)", cex.axis=1,cex.lab=.8, cex.main=1, pch=18, width=40,height=10, paper = "USr")
abline(h=median_entropy, col="red", lty=2)

legend("top", legend="Median", lty=2, col=c("red"), cex=.7, bty="n")

#text(genomic_regions, entropy, genomic_regions, cex=0.5, pos=3, offset=.2,col="red")

dev.off()
