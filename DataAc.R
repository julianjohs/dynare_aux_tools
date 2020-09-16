# DataAc_clean - Script to pull data from Eurostat, compile it into a data frame suitable for Dynare
# and save it into specified directory
# Author: Julian Johs

# Goal: One script to replicatably get data sets for multiple countries

# Need to specify data sets inside the get_data function
# Also need to specify target folder

# required packages - install these
library(tidyverse)
library(eurostat)
library(x12)
library(zoo)
library(xts)



# first some useful functions: 
# cc subsets complete cases
# season_adjust transforms data to seasonally adjusted using X13-ARIMA-SEATS
cc <- function(df) {subset(df, complete.cases(df))}
season_adjust <- function(x) {
  xx <- ts(x, frequency = 4)
  return(x12(xx)@d11)
}

# load tables needed (fully; might take some time)
qgovdebt <- get_eurostat("gov_10q_ggdebt")
qgovaccs <- get_eurostat("gov_10q_ggnfa")

# other examples for tables
# gdpaccs <- get_eurostat("namq_10_gdp")
# qfinaccs <- get_eurostat("gov_10q_ggfa")
# nonfinaccs <- get_eurostat("nasq_10_nf_tr")
# qfinwealth <- get_eurostat("nasq_10_f_bs")
# employmentdata <- get_eurostat("namq_10_pe")


# Core: get_data function - starttime defaults to 2000/01/01
# debt, payable interest and government expenditure are given as examples

get_data = function(country, starttime = 10957) {
  
  debt <- qgovdebt %>%
    filter(geo == country & na_item == "GD" & sector == "S13" & unit == "PC_GDP") %>%
    select(c("time", B_obs = "values"))
  
  ipayments <- qgovaccs %>%
    filter(geo == country & na_item == "D41PAY" & sector == "S13" & unit == "PC_GDP" & s_adj == "NSA") %>%
    select(c("time", ipayments = "values")) 
  
  govexp <- qgovaccs %>%
    filter(geo == country & na_item == "TE" & sector == "S13" & unit == "PC_GDP" & s_adj == "NSA") %>%
    select(c("time", EG_obs = "values"))
  
  # then, merge data (and calculate values, if needed, using e.g. mutate)
  mydata = full_join(debt, ipayments) %>%
    full_join(govexp) %>%
    mutate(i_g_obs = ipayments / B_obs) %>%
    cc() %>% # choose complete cases
    map_df(rev) %>% #order df chronologically
    mutate_at(vars(B_obs, ipayments, EG_obs, i_g_obs), season_adjust) # seasonally adjust data - add all unadjusted time series here!
  return(mydata)
}

#store df in project - change path!
storeinProject <- function(dataframe, name = deparse(substitute(dataframe)), path = "C:\\Users\\johs3\\Documents\\Arbeit\\FD3\\ESTIMATE\\") {
  loc <- paste(path, name, ".csv", sep = "")
  print(loc)
  write.table(dataframe, file = loc, sep = ",", row.names = F)
  #return(loc)
}


# then call get_data, using country code as argument
AT_data = get_data("AT")
AT_data = AT_data[,-1] # unselect time column (Matlab somehow gets confused by it)
storeinProject(AT_data)














