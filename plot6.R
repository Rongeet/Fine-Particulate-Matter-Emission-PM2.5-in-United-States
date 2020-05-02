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

# Select observations relating to Los Angeles County CA
vehiclesLosAngelesCounty <- NEI[NEI$SCC %in% vehicles$SCC & NEI$fips == "06037",]

# Merge observations of Baltimore and Los Angeles County
vehiclesCompare <- rbind(vehiclesBaltimore, vehiclesLosAngelesCounty)

# Compute yearly totals
vehiclesCompareYearly <- aggregate(Emissions ~ fips * year, data = vehiclesCompare, FUN = sum )

# Assign location names to variable
vehiclesCompareYearly$county <- ifelse(vehiclesCompareYearly$fips == "06037", "Los Angeles", "Baltimore")

# Plot to screen
qplot(year, Emissions, data = vehiclesCompareYearly, geom = "line", color = county, size = Emissions) + ggtitle("PM2.5 Emissions by Motor Vehicles in Baltimore City, MD, Vs Los Angeles County, CA") + xlab("Year") + ylab("PM2.5 Emissions in Tons")
dev.copy(PNG, file="plot5.PNG", height=480, width=480)
dev.off()
