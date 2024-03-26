#### Preamble ####
# Purpose: Simulates a dataset depicting causes of death in Alberta
# Author: Alexander Sun
# Date: 15 March 2024
# Contact: alexander.sun@mail.utoronto.ca
# License: MIT
# Pre-requisites: n/a


#### Workspace setup ####
library(tidyverse)

#### Simulate data ####
set.seed(1111)
alberta_death_simulation <-
  tibble(
    cause = rep(x = c("Heart Attack", "Heart Disease", "Diabetes"), times = 10),
    year = rep(x = 2016:2018, times = 10),
    deaths = rnbinom(n = 30, size = 20, prob = 0.1)
  )

alberta_death_simulation
summary(alberta_death_simulation)
write_csv(alberta_death_simulation, "data/raw_data/simulated_data.csv") 

#Test for deaths being at least 0
alberta_death_simulation$deaths |> min() >= 0 
#Test for all causes being in the data set
all(c("Heart Attack", "Heart Disease", "Diabetes") %in% alberta_death_simulation$cause) 
#Test so that death count doesn't exceed reasonable values
lberta_death_simulation$deaths |> max() <= 20000
