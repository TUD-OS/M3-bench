library(extrafont)
library(RColorBrewer)
source("tools/helper.R")

scaling <- 1.1
args <- commandArgs(trailingOnly = TRUE)
colors <- brewer.pal(n = 4, name = "Pastel1")

pdf(as.character(args[1]), width=8, height=2.2)
par(cex.lab=scaling, cex.axis=scaling, cex.main=scaling, cex.sub=scaling, family="Ubuntu")

syscv  = rev(scan(args[2]))
syscd  = rev(scan(args[3]))

par(mar=c(4.5,1,3,1))

plot = barplot(
    as.matrix(syscv),
    beside=T,
    horiz=TRUE,
    xlab = "Duration (Cycles)",
    xlim = c(0, 1100),
    space = c(0.3),
    col=rev(colors)
)
error.bar(plot, syscv, syscd, horizontal=T)

legend("top", c("M³-A", "M³-B", "M³-C", "M³-C*"), xpd=TRUE, horiz=T, bty="n",
    inset=c(0,-0.55), cex=scaling, fill=colors)

dev.off()
embed_fonts(as.character(args[1]))
