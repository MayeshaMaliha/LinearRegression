library(tidyverse)
library(HistData)
library(broom)
data("GaltonFamilies")

# set.seed(1) # if you are using R 3.5 or earlier
set.seed(1, sample.kind = "Rounding") # if you are using R 3.6 or later
galton <- GaltonFamilies %>%
  group_by(family, gender) %>%
  sample_n(1) %>%
  ungroup() %>% 
  gather(parent, parentHeight, father:mother) %>%
  mutate(child = ifelse(gender == "female", "daughter", "son")) %>%
  unite(pair, c("parent", "child"))

galton %>%
  group_by(pair) %>%
  summarize(count = n())

library(dplyr)

# Compute correlation for each parent-child pair
correlations <- galton %>%
  group_by(pair) %>%
  summarize(correlation = cor(parentHeight, childHeight, use = "complete.obs"))

# Display results
print(correlations)

galton %>%
  group_by(pair) %>%
  summarize(tidy(lm(childHeight ~ parentHeight, data = across()), conf.int = TRUE)) %>%
  filter(term == "parentHeight" & p.value < .05)
