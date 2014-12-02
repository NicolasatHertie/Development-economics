####################################################################################
########## SETTING THE WORKING DIRECTORY AND LOADING REQUIRED PACKAGES #############
####################################################################################

# setwd("/Users/Meilin/Desktop/Collaborative Social Data/FinalProject")
setwd("/Users/Nico/Documents/Hertie/Social science data analysis/Final project/FinalProject")

# 1. Loading Required Packages

# install.packages("RJOSONIO")  
library(RJSONIO)
# install.packages("WDI")  
library(WDI)
# install.packages("dplyr")  
library(dplyr) 
# install.packages("tidyr")  
library(tidyr)
# install.packages("httr")  
library(httr) 
# install.packages("knitr")  
library(knitr)
# install.packages("XML")  
library(XML)
#install.packages("plyr")
library(plyr)
# install.packages("Amelia")  
library(Amelia) 
#install.packages("XLConnect")
library(XLConnect)    
# install.packages("countrycode")
library("countrycode")
# install.packages ("ggplot2")
library(ggplot2)
# # install.packages ("magrittr") ???
library(magrittr)
# install.packages ("fmsb")
library(fmsb)
# install.packages ("car")
library(car)
# install.packages("DataCombine")
library(DataCombine)
# install.packages("lmtest")
library(lmtest)

wbdata <- c('SH.DYN.AIDS.ZS', 'SP.POP.TOTL')

dataset <- WDI(country='all', indicator=wbdata, start=2000, end=2012, extra=TRUE)

## Dropping regional data
dataset <- dataset[dataset$region != "Aggregates", ]

# Dropping rows where all variables are missing
dataset2 <- dataset[which(rowSums(!is.na(dataset[, wbdata])) > 0), ]

dataset2 <- plyr::rename(dataset2, c("SH.DYN.AIDS.ZS" = "Prevalence"))
dataset2 <- plyr::rename(dataset2, c("SP.POP.TOTL" = "Population"))

dataset2 <- group_by(dataset2, iso2c)
dataset2 <- arrange(dataset2, iso2c, year)

dataset2 <- dataset2[ which(dataset2$Population > 1000000) , ]

sum(is.na(dataset2$Prevalence))

dataset2 <- dataset2[!is.na(dataset2$Prevalence),]
hist(dataset2$Prevalence)

dataset2$lPrevalence <- log(dataset2$Prevalence)
hist(dataset2$lPrevalence)

shapiro.test(dataset2$lPrevalence)
shapiro.test(dataset2$Prevalence)

####################################################################################
################# LOADING AND CLEANING UNAIDS DATASET ##############################
####################################################################################

# 4. Downloading and preparing UNDAIDS data

# The data is publicly available at 
# 'http://www.google.de/url?sa=t&rct=j&q&esrc=s&source=web&cd=1&ved=0CCgQFjAA&url=http%3A%2F%2Fwww.unaids.org%2Fen%2Fmedia%2Funaids%2Fcontentassets%2Fdocuments%2Fdocument%2F2014%2F2014gapreportslides%2FHIV2013Estimates_1990-2013_22July2014.xlsx&ei=0I9XVJyZGoK6af6HAQ&usg=AFQjCNHEjs7Cc82jkTRwrRc8Jq4p2nKqbw&bvm=bv.78677474%2Cd.d2s' #
# Save the Excel file in your working directory

# Loading the data into R                
HIV = loadWorkbook("Nico.xlsx") 
HIVcountry = readWorksheet(HIV, sheet="Prevalence")

# Removing unnecessary columns  
HIVcountry <- HIVcountry[-c(1:5),-c(3:8,10:41)]

