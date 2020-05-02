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
typeBaltimore <- ddply(Baltimore, .(year, type), function(x) sum(x$Emissions))
 colnames(typeBaltimore)[3] <- "emissions"
 par(bg = 'grey')
 qplot(year, emissions, data = typeBaltimore, color = type, geom = "line") + ggtitle("PM2.5 Emission by Type and Year in Baltimore City") + xlab("Year") + ylab("Total PM2.5 Emissions in tons") + theme(legend.position = c(0.9, 0.85))
dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()
