#### Preamble ####
# Purpose: Simulates a dataset depicting causes of death in Alberta
# Author: Alexander Sun
# Date: 15 March 2024
# Contact: alexander.sun@mail.utoronto.ca
# License: MIT
# Pre-requisites: n/a


#### Workspace setup ####
library(tidyverse)

#### Test data ####
#Test for deaths being at least 0
alberta_death_simulation$deaths |> min() >= 0 
#Test for all causes being in the data set
all(c("Heart Attack", "Heart Disease", "Diabetes") %in% alberta_death_simulation$cause) 
#Test so that death count doesn't exceed reasonable values
lberta_death_simulation$deaths |> max() <= 20000