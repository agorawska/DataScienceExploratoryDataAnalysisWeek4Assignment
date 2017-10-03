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

#calculating total emission (source not relevant) per each year
totalEmissions <- pmData %>% 
  group_by(year) %>% 
  summarise(emission = sum(Emissions))

#ploting
png("plot1.png")
barplot(height = totalEmissions$emission,width = totalEmissions$year,xlab = "Year",ylab="Total PM2.5 emission",names.arg=c("2009","2002","2005","2008"))
title(main = "Total PM2.5 emission in the USA by year")
dev.off()

