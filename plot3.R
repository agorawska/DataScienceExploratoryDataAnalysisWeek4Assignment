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

#subsetting Baltimore City data
baltimoreData <- subset(pmData,fips == "24510")
#changing type from numeric to factor
baltimoreData$type <- as.factor(baltimoreData$type)

#calculating total emission (source not relevant) per each year
totalEmissions <- baltimoreData %>% 
  group_by(year,type) %>%
  summarise(totalEmission = sum(Emissions))

#ploting
png("plot3.png")
ggplot(totalEmissions,aes(year,totalEmission,color=type)) +
  geom_line(lwd=2)+
  ggtitle("Total PM2.5 emission in the Baltimore City, Maryland by year")+
  xlab("Year")+ylab("Total PM2.5 emission")
dev.off()

