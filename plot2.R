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
# FIlter observations relating to Baltimore MD
Baltimore <- subset(NEI, fips == "24510")

# Total all emissions in Baltimore MD, for the years 1999 to 2008
totalBaltimore <- tapply(Baltimore$Emissions, Baltimore$year, sum)

# Plot to file
par(bg = 'grey')
barplot(totalBaltimore, col = rainbow(5, start = 0, end = 1), xlab = "Year", ylab = "Total PM2.5 Emissions (Tons)", main = "Yearly Emissions (tons) in Baltimore City, Maryland")
dev.copy(png,"plot2.png", width=480, height=480)
dev.off()
