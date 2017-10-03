####################################################################################
#Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
#Using the base plotting system, make a plot showing the total PM2.5 
#emission from all sources for each of the years 1999, 2002, 2005, and 2008.
####################################################################################
library(dplyr)

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

#finding SCC values for coal combustion-related sources
sccVal<-grep(pattern = ".+Comb.+Coal",pmSource$Short.Name,ignore.case = TRUE)
sccVal<-pmSource[sccVal,]
sccVal<-sccVal[,"SCC"]

#subsetting data so that it is only for selected SCC's
totalEmissions<-subset(pmData,SCC %in% sccVal)

#calculating total emission (source not relevant) per each year
totalEmissions <- totalEmissions %>% 
  group_by(year) %>% 
  summarise(emission = sum(Emissions))

#ploting
png("plot4.png",width=600)
barplot(totalEmissions$emission,totalEmissions$year,xlab = "Year",ylab="Total PM2.5 emission",names.arg=c("1999","2002","2005","2008"))
title(main = "Total PM2.5 emission from coal combustion-related sources in the USA")
dev.off()

