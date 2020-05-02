library(devtools)
library(dyplyr)
library(ggplot2)
library(RColorBrewer)
# Download and unzip the file:
dir.create("./air_pollution")
urlzip <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(urlzip, destfile = "./air_pollution.zip" )
unzip("./air_pollution.zip", exdir = "./air_pollution" )
NEI <- readRDS("./air_pollution/summarySCC_PM25.rds")
SCC <- readRDS("./air_pollution/Source_Classification_Code.rds")
str(NEI)
str(SCC)
totalNEI <- tapply(NEI$Emissions, NEI$year, sum)

# Plot output to file
par(bg = 'grey')
barplot(totalNEI, col = rainbow(10, start = 0, end = 1), xlab = "Year", ylab = "Total PM2.5 Emissions in Tons", main = "Total PM 2.5 Emissions (tons) in USA")
dev.copy(png, file="plot1.png", height=480, width=480)
dev.off()

