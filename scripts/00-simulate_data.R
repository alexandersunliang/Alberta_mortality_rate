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

