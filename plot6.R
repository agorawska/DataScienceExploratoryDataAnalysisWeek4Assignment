####################################################################################
#Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
#Using the base plotting system, make a plot showing the total PM2.5 
#emission from all sources for each of the years 1999, 2002, 2005, and 2008.
####################################################################################
library(ggplot2)

fileName <- "NEI_dataset.zip"

## checks if datasets are available in the current working directory
if (!file.exists(fileName)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileURL, fileName, method="auto")
}  
#checks if datasets were unzipped - generally if we can access it 
if (!file.exists("Source_Classification_Code.rds")) { 
  unzip(fileName) 
}

#reading data
pmData <- readRDS("summarySCC_PM25.rds")
pmSource <- readRDS("Source_Classification_Code.rds")

#subsetting Baltimore City and Los Angeles County data for ON-ROAD types
cityData <- subset(pmData,fips %in% c("24510","06037") & type=="ON-ROAD")

#calculating total emission (source not relevant) per each year
totalEmissions <- cityData %>% 
  group_by(year,fips) %>%
  summarise(totalEmission = sum(Emissions))


totalEmissions$fips[totalEmissions$fips=="24510"]<-"Baltimore, MD"
totalEmissions$fips[totalEmissions$fips=="06037"]<-"Los Angeles, CA"

totalEmissions$fips<-as.factor(totalEmissions$fips)

#ploting
png("plot6.png",width=600)
ggplot(data=totalEmissions,aes(year,totalEmission)) +
ggtitle("Total PM2.5 emission in the Baltimore City, Maryland and Los Angeles County by year") +
xlab("Year")+ylab("Total PM2.5 emission")+geom_bar(stat="identity")+
  facet_grid(. ~ fips)

dev.off()

