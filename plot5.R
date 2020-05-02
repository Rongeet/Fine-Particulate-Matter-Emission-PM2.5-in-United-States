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
# Filter with regular expression names containing "Vehicles" or "vehicles"
vehicles1 <- unique(grep("Vehicles", SCC$EI.Sector, ignore.case = TRUE, value = TRUE))
vehicles <- SCC[SCC$EI.Sector %in% vehicles1, ]["SCC"]

# Select observations relating to Baltimore MD
vehiclesBaltimore <- NEI[NEI$SCC %in% vehicles$SCC & NEI$fips == "24510",]

# Compute yearly totals
vehiclesBaltimoreYearly <- ddply(vehiclesBaltimore, .(year), function(x) sum(x$Emissions))

# Rename columns meaningfully
colnames(vehiclesBaltimoreYearly)[2] <- "emissions"

# Plot to screen
qplot(year, emissions, data = vehiclesBaltimoreYearly, geom = "line", color = emissions, size = 1) + ggtitle("PM2.5 Emissions by Motor Vehicles in Baltimore City") + xlab("Year") + ylab("PM2.5 Emissions in Tons")
dev.copy(png, file="plot5.png", height=480, width=480)
dev.off()
