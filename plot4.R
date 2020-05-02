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
# Filter with regular expression names containing "Coal" or "coal"
NEI2 <- NEI[NEI$SCC %in% SCC[grep("Coal", SCC$EI.Sector), 1], ]
SCC2 <- SCC[, c(1, 4)]
coalClass <- grep("coal", SCC$Short.Name, ignore.case = TRUE)
coalClass <- SCC[coalClass, ]
SCC.identifiers <- as.character(coalClass$SCC)

# Select observations relating to coal emissions
NEI$SCC <- as.character(NEI$SCC)
coalNEI <- NEI[NEI$SCC %in% SCC.identifiers, ]
coalTotal <- with(coalNEI, aggregate(Emissions, by = list(year), sum))
colnames(coalTotal) <- c("year", "Emissions")

# Plot to file
ggplot(data = coalTotal, aes(x = year, y = Emissions)) + geom_line() + geom_point(size=5, shape=21, fill="red") + ggtitle("PM2.5 Emission by Coal Combustion in USA") + theme(axis.text.x = element_text(angle = 45, hjust = 1))
dev.copy(png, file="plot4.png", height=480, width=480)
dev.off()
