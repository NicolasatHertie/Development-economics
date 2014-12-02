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

wbdata <- c('SH.XPD.OOPC.TO.ZS', 'SP.POP.TOTL')

dataset <- WDI(country='all', indicator=wbdata, start=2000, end=2012, extra=TRUE)

## Dropping regional data
dataset <- dataset[dataset$region != "Aggregates", ]

# Dropping rows where all variables are missing
dataset2 <- dataset[which(rowSums(!is.na(dataset[, wbdata])) > 0), ]

dataset2 <- plyr::rename(dataset2, c("SH.XPD.OOPC.TO.ZS" = "OOP"))
dataset2 <- plyr::rename(dataset2, c("SP.POP.TOTL" = "Population"))

dataset2 <- group_by(dataset2, iso2c)
dataset2 <- arrange(dataset2, iso2c, year)

dataset2 <- dataset2[ which(dataset2$Population > 1000000) , ]

sum(is.na(dataset2$OOP))

dataset2 <- dataset2[!is.na(dataset2$OOP),]
hist(dataset2$OOP)

dataset2$lOOP <- log(dataset2$OOP)
hist(dataset2$lOOP)

shapiro.test(dataset2$OOP)
shapiro.test(dataset2$lOOP)
