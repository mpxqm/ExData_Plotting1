################################################################################
##                                                                            ##
##   plot2.R	                         				      ##
##									      ##
##   Exploratory Data Analysis Course Project 1                               ##
##   2020-12                                                                  ##
##                                                                            ##
################################################################################

# Creates the plot for the assignment 
# https://www.coursera.org/learn/exploratory-data-analysis/
# peer/ylVFo/course-project-1

##----------------------------------------------------------------------------##
##    Load libraries and set working directory
##----------------------------------------------------------------------------##

if("dplyr" %in% rownames(installed.packages()) == TRUE) {
	
	library(dplyr)
}else{
	stop("This script requires the package 'dplyr'")
}

if("here" %in% rownames(installed.packages()) == TRUE) {
	library(here)
	set_here()
	working_dir = here()
}else{
	working_dir = file.path(".")
	file.exists(working_dir)
}

# Set working directory
setwd(working_dir)

print(c("Working dir:",getwd()) )

##----------------------------------------------------------------------------##
##    Locate data directory
##----------------------------------------------------------------------------##
filename_zip = "uci_ml_dataset.zip"

data_dir = file.path(working_dir, "data")
file_url = paste0("https://d396qusza40orc.cloudfront.net/",
		  "exdata%2Fdata%2Fhousehold_power_consumption.zip")
filename_data = "household_power_consumption.txt"
filename_full_data =file.path(data_dir,filename_data)


## Check if the dataset is present
if( !file.exists(filename_full_data) )
{
	if( !file.exists(data_dir) )
	{
		print(paste("data dir: '",data_dir,"' is not present.", sep = ""))
		print(paste0("This script will download and extract the data to",
			     " a directory './data'",
			     " in the working directory."))
		
		# Create the directory structure
		data_dir_parent = file.path(working_dir, "data")
		if (!file.exists(data_dir_parent)){
			dir.create( data_dir_parent )
		}
		
	}else{
		print(paste("data dir: '",data_dir,"'"))
	}
	
	## Get the files
	file_dest = file.path(data_dir_parent, filename_zip)
	
	if (!file.exists(file_dest)){
		
		
		download.file(file_url,destfile =file_dest, method="curl" )
	}
	
	if ( !file.exists( file.path(filename_full_data)) ){ 
		unzip(file_dest,exdir = data_dir_parent ) 
	}
	
}

##----------------------------------------------------------------------------##
##                       Load data	                 		      ##
##----------------------------------------------------------------------------##

# Date, Time , numerics
col_classes = c("character","character","double","double","double")

data = read.table(file = filename_full_data,header = TRUE, sep = ";",
		  stringsAsFactors =FALSE, na.strings = "?",
		  colClasses = col_classes)

data.mem = object.size(data)
format(data.mem, units = "GB", standard = "auto", digits = 1L)

print(paste0("The dataset requires ",
	     format(data.mem, units = "MB", standard = "auto", digits = 1L),
	     " RAM."))

## Identify the relevant data
chr_date_min = "2007-02-01" 
chr_date_max = "2007-02-02"

dt_date_min = as.Date(chr_date_min)
dt_date_max = as.Date(chr_date_max)

# convert to dates
data$Date = as.Date(data$Date, c("%d/%m/%Y"))


# Subset the relevant data
data_relevant = subset(data, chr_date_min<=data$Date & data$Date<=chr_date_max)

# Create a new variable combining Time and Date columns
data_relevant$DateTime = as.POSIXct(paste(
	data_relevant$Date, data_relevant$Time), format="%Y-%m-%d %H:%M:%S")

##----------------------------------------------------------------------------##
##                       Plot     	                 		      ##
##----------------------------------------------------------------------------##


# Set locale for correct plotting of times
Sys.setlocale("LC_TIME", "en_US.UTF-8")


## Plot2.R

# Prepare device
png(filename = "plot2.png",
    width = 480, 
    height = 480,
    units = "px",
    bg = "white")

# Plot
plot(data_relevant$DateTime, data_relevant$Global_active_power, 
     type = "l", 
     col = "black", 
     lwd = 1,
     xlab = "",
     ylab =  "Global Active power (kilowatts)"
)

# close and save the image
dev.off()




