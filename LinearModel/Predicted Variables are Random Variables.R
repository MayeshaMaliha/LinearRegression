galton_heights %>% ggplot(aes(son, father)) +
  geom_point() + 
  geom_smooth(method = "lm")

galton_heights %>%
  mutate(Y_hat = predict(lm(son ~ father, data = .))) %>%
  ggplot(aes(father, Y_hat)) + 
  geom_line()

# predict Y directly
fit <- galton_heights %>% lm(son ~ father, data = .) 
Y_hat <- predict(fit, se.fit = TRUE)
names(Y_hat)