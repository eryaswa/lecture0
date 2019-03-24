#fishcode.R
#tanthingheng@gmail.com

# Requirements ---------------------------------------------------
# library to use
# plyr
# ggplot2
# gridExtra

# References ----------------------------------------------------
#http://www.fao.org/docrep/x5684e/x5684e05.htm#3.2.6%20raising%20factors
#https://learningportal.iiep.unesco.org/en/glossary/raising-factor
#https://www.iccat.int/Documents/SCRS/Manual/CH4/CH4_3-ENG.pdf 

# Load libraries ------------------------------------------------

library(plyr) #to subset data & apply function to subset of data
library(ggplot2) #to plot
library(gridExtra) #to display multiple plots in a grid with grid.arrange function (similar to par in base R) 

# Read data and merge data -----------------------------------------------------

smallfish <- read.csv("Small_Fish.csv")
bigfish <- read.csv("Big_Fish.csv")
smallfish$Size <- rep("Small",nrow(smallfish))
bigfish$Size <- rep("Big",nrow(bigfish))
allfish <- rbind(bigfish,smallfish) #combine data from 2 csv files to 1 data frame

str(smallfish)
str(bigfish)
str(allfish)
head(allfish)
tail(allfish)
summary(allfish)

ddply(
   allfish,
   .(Species, Gear, Size),
   summarize,
   rfmin = min(raising_factor),
   rfmean = mean(raising_factor),
   rfmedian = median(raising_factor),
   rfmax = max(raising_factor)
)

# Estimate fish population --------------------------------------

#Histograms in hints suggest frequencies of fish lengths plotted are from population while data of fish lengths on 2 CSV files are samples from population. 
#The only exceptions are fish of species A caught with gear D length > 100 cms and fish of species B caught with gear D having length > 100 cms.
#Population of fish is estimated by multiplying frequencies in sample with raising factor. (See reference from iccat page 9)

n <- as.integer(allfish$raising_factor)
popfish <- allfish[rep(seq_len(nrow(allfish)),times=n),]
summary(popfish)

# raising factor examination ------------------------------------

ddply(
   popfish,
   .(Species, Gear, Size),
   summarize,
   rfmin = min(raising_factor),
   rfmean = mean(raising_factor),
   rfmedian = median(raising_factor),
   rfmax = max(raising_factor)
)


# filter data ---------------------------------------------------

fishAC <- subset(popfish,Species=="A" & Gear=="C")
fishAD <- subset(popfish,Species=="A" & Gear=="D")
fishBC <- subset(popfish,Species=="B" & Gear=="C")
fishBD <- subset(popfish,Species=="B" & Gear=="D")
fishADle100 <- subset(fishAD,Length <= 100)
fishADgt100 <- subset(fishAD,Length > 100)


# plot fish population data

gBC <- ggplot(data=fishBC,mapping = aes(x=Length)) +  
   geom_histogram(binwidth = 10,color="black",fill="lightcoral",boundary=0) +
   labs(title="Frequency Length Fish B C\nLocation 2018",x="Length (cm)",y="Frequency") +
   geom_vline(xintercept = 100,size=1) +
   xlim(0,200) +
   theme_bw() + theme(
      panel.border = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.line = element_line(colour = "black")
   )

gBD <- ggplot(data=fishBD,mapping = aes(x=Length)) +  
   geom_histogram(binwidth = 10,color="black",fill="palegreen",boundary=0) +
   labs(title="Frequency Length Fish B D\nLocation 2018",x="Length (cm)",y="Frequency") +
   geom_vline(xintercept = 100,size=1) +
   xlim(0,200) +
   theme_bw() + theme(
      panel.border = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.line = element_line(colour = "black")
   )

gAC <- ggplot(data=fishAC,mapping = aes(x=Length)) +  
   geom_histogram(binwidth = 10,color="black",fill="lightcoral",boundary=0) +
   labs(title="Frequency Length Fish A C\nLocation 2018",x="Length (cm)",y="Frequency") +
   geom_vline(xintercept = 100,size=1) +
   xlim(0,200) +
   theme_bw() + theme(
      panel.border = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.line = element_line(colour = "black")
   )

gAD <- ggplot(data = fishADle100, mapping = aes(x = Length))  +
   geom_histogram(
      binwidth = 10,
      color = "black",
      fill = "lightcoral",
      boundary = 0
   ) +
   labs(title = "Frequency Length Fish A D\nLocation 2018", x = "Length (cm)", y =
           "Frequency") +
   geom_histogram(
      data = fishADgt100,
      color = "black",
      fill = "palegreen",
      binwidth = 10,
      boundary = 0
   ) +
   geom_vline(xintercept = 100, size = 1) +
   xlim(0, 200) +
   theme_bw() + theme(
      panel.border = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.line = element_line(colour = "black")
   )

fishplot <- grid.arrange(gBC,gBD,gAC,gAD,nrow=2)

# save outputs ---------------------------------------------------
write.csv(allfish,file="allfishsample.csv",row.names = FALSE)
write.csv(popfish,file="allfishpopulation.csv",row.names = FALSE)
ggsave("LengthFreqFishPopulationPlots.pdf",fishplot)

graphs <- c("LengthFreqBC","LengthFreqBD","LengthFreqAC","LengthFreqAD")
plotlist <- list(gBC,gBD,gAC,gAD)
for (j in seq_along(plotlist)){
   jpeg(paste0(graphs[j],".jpg"))
   print(plotlist[[j]])
   dev.off()
}

save.image("fish.RData")

