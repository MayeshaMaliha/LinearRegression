library(Lahman)
bat_02 <- Batting %>% filter(yearID == 2002) %>%
  mutate(pa = AB + BB, singles = (H - X2B - X3B - HR)/pa, bb = BB/pa) %>%
  filter(pa >= 100) %>%
  select(playerID, singles, bb)


# Filter data for 1999-2001
bat_99_01 <- Batting %>%
  filter(yearID >= 1999 & yearID <= 2001) %>%
  mutate(pa = AB + BB, 
         singles = (H - X2B - X3B - HR) / pa, 
         bb = BB / pa) %>%
  filter(pa >= 100) %>%
  group_by(playerID) %>%
  summarise(mean_singles = mean(singles, na.rm = TRUE),
            mean_bb = mean(bb, na.rm = TRUE)) %>%
  ungroup()

# Count players with mean_singles > 0.2
num_players_1 <- sum(bat_99_01$mean_singles > 0.2, na.rm = TRUE)
# Count players with mean_singles > 0.2
num_players_2 <- sum(bat_99_01$mean_bb > 0.2, na.rm = TRUE)

# Perform inner join on playerID
combined_data <- inner_join(bat_02, bat_99_01, by = "playerID")

# Display first few rows
head(combined_data)

(cor(combined_data$bb, combined_data$mean_bb))

library(ggplot2)

# Scatterplot: mean_singles vs. singles (1999-2001 vs 2002)
ggplot(combined_data, aes(x = mean_singles, y = singles)) +
  geom_point(alpha = 0.6, color = "blue") +
  labs(title = "Mean Singles (1999-2001) vs. Singles (2002)",
       x = "Mean Singles Rate (1999-2001)",
       y = "Singles Rate (2002)") +
  theme_minimal()

# Scatterplot: mean_bb vs. bb (1999-2001
# Scatterplot: mean_bb vs. bb (1999-2001 vs 2002)
ggplot(combined_data, aes(x = mean_bb, y = bb)) +
  geom_point(alpha = 0.6, color = "red") +
  labs(title = "Mean BB Rate (1999-2001) vs. BB Rate (2002)",
       x = "Mean BB Rate (1999-2001)",
       y = "BB Rate (2002)") +
  theme_minimal()
# Fit linear model: predicting 2002 singles using 1999-2001 mean_singles
model_singles <- lm(bb ~ mean_bb, data = combined_data)

# Extract slope (coefficient of mean_singles)
coef(model_singles)[2]

