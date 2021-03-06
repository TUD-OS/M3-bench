library(extrafont)
library(RColorBrewer)
source("tools/helper.R")

args <- commandArgs(trailingOnly = TRUE)
scaling <- 2
namescale <- 2
colors <- brewer.pal(n = 4, name = "Pastel1")

times   <- list()
stddevs <- list()
for(i in 1:3) {
    # convert back to time (cycles / 3)
    times[[i]]   <- read.table(as.character(args[i * 2]), header=TRUE, sep=" ") / (1000000 * 3)
    stddevs[[i]] <- scan(args[i * 2 + 1]) / (1000000 * 3)
}
zeros <- matrix(rep(c(NA), 3 * 3), nrow=3, ncol=3)

pdf(as.character(args[1]), width=5, height=4)
par(cex.lab=scaling, cex.axis=scaling, cex.main=scaling, cex.sub=scaling, family="Ubuntu")

layout(matrix(c(1,2,3), 1, 3, byrow = TRUE),
    widths=c(1.5,1,1), heights=c(1,1))

par(mar=c(8.5,5.5,4,0))

subs <- c("Total   ", "Reader   ", "Writer   ")
for(i in 1:length(times)) {
    if(i > 1)
        par(mar=c(8.5,0,4,0))

    barplot(as.matrix(zeros), beside=F, ylim=c(0,10), axes=F,
        space=rep(0.2, 3), names.arg=rep("", 3))
    abline(h=c(seq(0,9,3)), col="gray80", lwd=2)

    plot <- barplot(as.matrix(times[[i]]), beside=F, add=T,
        ylim=c(0,10), space=rep(0.2, 3), axes=F, width=rep(c(0.9), 3),
        col=colors,
        cex.names=namescale, las=3, mgp=c(5.5, 0.5, 0),
        names.arg=c("M³-A","M³-B","M³-C"), sub=subs[[i]])
    if(i == 1) {
        axis(2, at = seq(0, 10, 3), las = 2)
        title(ylab = "Time (ms)", mgp=c(3, 1, 0))
    }
    error.bar(plot, colSums(times[[i]]), stddevs[[i]])
}

# legend
par(fig=c(0,1,0,1), oma=c(0,0,0,0), mar=c(0,0,0.1,0), new=TRUE)

plot(0, 0, type="n", bty="n", xaxt="n", yaxt="n")
legend("top", c("Total", "Idle", "OS", "Xfers"), xpd=TRUE, horiz=T, bty="n",
    inset=c(0,0), cex=namescale, fill=rev(colors))

dev.off()
embed_fonts(as.character(args[1]))
