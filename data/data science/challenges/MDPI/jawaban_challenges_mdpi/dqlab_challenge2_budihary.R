#data preparation
big.fish<-read.csv("mdpi-DQLab-challenge/Big_Fish.csv",header=TRUE)
small.fish<-read.csv("mdpi-DQLab-challenge/Small_Fish.csv",header=TRUE)
big.fish$Size<-1
small.fish$Size<-0
fish<-rbind(small.fish,big.fish)
fish$Size<-factor(fish$Size,labels=c("Small","Big"))
head(fish)
fYear<-rep(fish$Year,fish$raising_factor)
fGear<-rep(fish$Gear,fish$raising_factor)
fSpecies<-rep(fish$Species,fish$raising_factor)
fLength<-rep(fish$Length,fish$raising_factor)
fSize<-rep(fish$Size,fish$raising_factor)
fish2<-data.frame(cbind(fYear,fGear,fSpecies,fLength,fSize))
colnames(fish2)<-c("Year","Gear","Species","Length","Size")
fish2$Gear<-factor(fish2$Gear,labels=c("C","D"))
fish2$Species<-factor(fish2$Species,labels=c("A","B"))
fish2$Size<-factor(fish2$Size,labels=c("Small","Big"))
fish2$size100<-ifelse(fish2$Length>100,1,0)
fish2$size100<-factor(fish2$size100,labels=c("<=100",">100"))
 


#data visualization
require(ggplot2) #untuk penyusunan grafik
require(gridExtra) #untuk penggabungan grafik dalam satu gambarf

gfishAC2 <- ggplot(fish2[(fish2$Gear=="C") & (fish2$Species=="A"),], 
                  aes(x=Length,fill=size100))
gfishAD2 <- ggplot(fish2[(fish2$Gear=="D") & (fish2$Species=="A"),], 
                  aes(x=Length,fill=size100))
gfishBC2 <- ggplot(fish2[(fish2$Gear=="C") & (fish2$Species=="B"),], 
                  aes(x=Length,fill=size100))
gfishBD2 <- ggplot(fish2[(fish2$Gear=="D") & (fish2$Species=="B"),], 
                  aes(x=Length,fill=size100))

g1<- gfishAC2 + 
  geom_histogram(color="black", binwidth=10,boundary=100) + 
  geom_vline(aes(xintercept=100),size=2)+coord_cartesian(xlim=c(0,200))+
  labs(title="Frequency Length Fish A C",subtitle="Location 2018",
       y="Frequency",x="Length (cm)")+geom_hline(aes(yintercept=0))+
  theme(legend.position = "none")

g2<-gfishBC2 +  
  geom_histogram(color="black",binwidth=10,boundary=100) + 
  geom_vline(aes(xintercept=100),size=2)+coord_cartesian(xlim=c(0,200))+
  labs(title="Frequency Length Fish B C",subtitle="Location 2018",
       y="Frequency",x="Length (cm)")+geom_hline(aes(yintercept=0))+
  theme(legend.position = "none")

g3<- gfishAD2 + 
  geom_histogram(color="black", binwidth=10,boundary=100) + 
  geom_vline(aes(xintercept=100),size=2)+coord_cartesian(xlim=c(0,200))+
  labs(title="Frequency Length Fish A D",subtitle="Location 2018",
       y="Frequency",x="Length (cm)")+geom_hline(aes(yintercept=0))+
  theme(legend.position = "none")

g4<- gfishBD2 +  
  geom_histogram(color="black",binwidth=10,boundary=100) + 
  geom_vline(aes(xintercept=100),size=2)+coord_cartesian(xlim=c(0,200))+
  labs(title="Frequency Length Fish B D",subtitle="Location 2018",
       y="Frequency",x="Length (cm)") + 
  scale_fill_manual(values=c("#33DDFF"))+geom_hline(aes(yintercept=0))+
  theme(legend.position = "none") 

grid.arrange(g1,g2,g3,g4,ncol=2)
