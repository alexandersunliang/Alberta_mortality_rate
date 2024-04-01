#### Preamble ####
# Purpose: Simulates a dataset depicting causes of death in Alberta
# Author: Alexander Sun
# Date: 15 March 2024
# Contact: alexander.sun@mail.utoronto.ca
# License: MIT
# Pre-requisites: n/a



#### Workspace setup ####
library(tidyverse)
library(knitr)
library(kableExtra)
library(here)
library(dplyr)
library(bayesplot)
library(rstanarm)
library(gridExtra)
library(ggplot2)
library(modelsummary)
library(broom.mixed)

#### Load data ####
filtered_data <- read.csv(here("data/analysis_data/analysis_data.csv"))

### Replication of Table 1, Yearly death counts for various heart diseases and diabetes ###
summary_table <- tibble(
  Year = rep(2016:2021, times = 5),
  Cause_of_Death = rep(c("Acute Myocardial Infarction",
                         "All Other Forms of Ischemic Heart Disease",
                         "Atherosclerotic Cardiovascular Disease",
                         "Diabetes Mellitus",
                         "Congestive Heart Failure"), each = 6),
  Total_Deaths = c(1102, 1028, 1071, 1061, 1067, 1075,       
                   1626, 1678, 1788, 1886, 1897, 1939,  
                   885, 817, 630, 745, 678, 463,       
                   502, 584, 577, 569, 743, 728, 
                   352, 374, 347, 430, 387, 403)       
) %>%
  pivot_wider(names_from = Cause_of_Death, values_from = Total_Deaths) %>%
  select(Year, "Acute Myocardial Infarction", "All Other Forms of Ischemic Heart Disease",
         "Atherosclerotic Cardiovascular Disease", "Diabetes Mellitus", "Congestive Heart Failure")
kable(summary_table, format = "latex", booktabs = TRUE,) %>%
  kable_styling(latex_options = c("striped", "scale_down"))

### Replication for Figure 1, Trends in Total Deaths per Year by Cause from 2016-2021 ###
ggplot(filtered_data, aes(x = calendar_year, y = total_deaths, color = cause, group = cause)) +
  geom_line() + # Draw lines
  geom_point() + 
  theme_minimal() +
  labs(
    title = "Trends in Total Deaths by Cause (2016-2021)",
    x = "Calendar Year",
    y = "Total Deaths Per Year",
    color = "Cause of Death"
  ) +
  scale_x_continuous(breaks = seq(min(filtered_data$calendar_year), max(filtered_data$calendar_year), by = 1)) # Ensure every year is shown

### Replication for Table 2, Summary Statistics for Number of Yearly Deaths by Cause ###
# Generating the summary statistics 
summary_stats <- filtered_data %>%
  summarise(
    Min = min(total_deaths),
    Mean = mean(total_deaths),
    Max = max(total_deaths),
    SD = sd(total_deaths),
    Var = var(total_deaths),
    N = n()
  )
# Generating the kable table
kable(summary_stats, 
      col.names = c("Minimum", "Mean", "Maximum", "Standard Deviation", "Variance", "Count"), 
      align = 'c') %>%
  kable_styling(latex_options = c("striped", "hold_position"))

### Replication for Table 3, Model Values ###
poisson_summary <- tidy(cause_of_death_poisson)
negbin_summary <- tidy(cause_of_death_neg_binomial)

combined_results <- bind_rows(
  mutate(poisson_summary, Model = "Poisson"),
  mutate(negbin_summary, Model = "Negative Binomial")
)

# Use modelsummary to create the comparison table
modelsummary(
  list(Poisson = cause_of_death_poisson, `Negative Binomial` = cause_of_death_neg_binomial),
  output = "kableExtra"
)

### Replication for Figure 2, Poisson and Binomial Comparison ###
p1 <- pp_check(cause_of_death_poisson) + 
  ggtitle("Poisson Model") +
  theme(legend.position = "bottom")

p2 <- pp_check(cause_of_death_neg_binomial) + 
  ggtitle("Negative Binomial Model") +
  theme(legend.position = "bottom")

gridExtra::grid.arrange(p1, p2, ncol = 2)