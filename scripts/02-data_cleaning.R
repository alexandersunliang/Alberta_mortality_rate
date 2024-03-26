#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 6 April 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(knitr)

#### Clean data ####
#Filter the data by 
clean_data <-
  read_csv(
    "data/raw_data/raw-data-leading-causes-of-death.csv",
    skip = 2,
    col_types = cols(
      `Calendar Year` = col_integer(),
      Cause = col_character(),
      Ranking = col_integer(),
      `Total Deaths` = col_integer()
    )
  ) |>
  clean_names() |>
  add_count(cause) |>
  mutate(cause = str_trunc(cause, 30))

# Filter the dataset
filtered_data <- clean_data %>%
  filter(cause %in% c("All other forms of chronic ...", 
                      "Acute myocardial infarction", 
                      "Atherosclerotic cardiovascu...", 
                      "Diabetes mellitus", 
                      "Congestive heart failure")) %>%
  filter(calendar_year >= 2016 & calendar_year <= 2021)

filtered_data <- filtered_data %>%
  mutate(cause = case_when(
    cause == "All other forms of chronic ..." ~ "All Other Forms of Ischemic Heart Disease",
    cause == "Acute myocardial infarction" ~ "Acute Myocardial Infarction",
    cause == "Atherosclerotic cardiovascu..." ~ "Atherosclerotic Cardiovascular Disease",
    cause == "Diabetes mellitus" ~ "Diabetes Mellitus",
    cause == "Congestive heart failure" ~ "Congestive Heart Failure",
    TRUE ~ cause # Default case to keep cause as is if none of the above matches
  ))


# View the filtered dataset
print(filtered_data)

# Remove all empty data 
filtered_data <- na.omit(filtered_data)
#### Save data ####
write_csv(filtered_data, "data/analysis_data/analysis_data.csv")
