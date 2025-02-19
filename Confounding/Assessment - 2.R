library(tidyverse)
library(broom)
library(Lahman)
Teams_small <- Teams %>% 
  filter(yearID %in% 1961:2001) %>% 
  mutate(avg_attendance = attendance/G, R = R/G, HR = HR/G)
# Fit a linear model using runs per game to predict average attendance
fit_attendance <- lm(W ~ R , data = Teams_small)
tidy(fit_attendance)

dat <- Teams_small %>%
  mutate(W_strata = round(W/10)) %>%
  filter(W_strata >= 5 & W_strata <= 10)

sum(dat$W_strata == 8)
# calculate slope of regression line after stratifying by R per game
dat %>%  
  group_by(W_strata) %>%
  summarize(slope = cor(R/G, avg_attendance)*sd(avg_attendance)/sd(R/G))

dat %>%  
  group_by(W_strata) %>%
  summarize(slope = cor(HR/G, avg_attendance)*sd(avg_attendance)/sd(HR/G))


# Fit a multivariate regression model to determine the effects of runs per game, home runs per game, wins, and year on average attendance
fit_multivariate <- lm(avg_attendance ~ R + HR + W + yearID, data = Teams_small)
tidy(fit_multivariate)

# Step 1: Prepare the 2002 data
Teams_2002 <- Teams %>%
  filter(yearID == 2002) %>%
  mutate(R = R/G, HR = HR/G, avg_attendance = attendance/G)

# Step 2: Use the model to predict attendance for 2002
predicted_attendance_2002 <- predict(fit_multivariate, newdata = Teams_2002)

# Step 3: Calculate the correlation between predicted and actual attendance
correlation <- cor(predicted_attendance_2002, Teams_2002$avg_attendance)

# Print the correlation
correlation