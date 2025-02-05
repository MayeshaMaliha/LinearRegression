set.seed(1989) #if you are using R 3.5 or earlier
set.seed(1989, sample.kind="Rounding") #if you are using R 3.6 or later
library(HistData)
data("GaltonFamilies")

female_heights <- GaltonFamilies%>%     
  filter(gender == "female") %>%     
  group_by(family) %>%     
  sample_n(1) %>%     
  ungroup() %>%     
  select(mother, childHeight) %>%     
  rename(daughter = childHeight)

m_m <- mean(female_heights$mother)
s_m <- sd(female_heights$mother)
m_d <- mean(female_heights$daughter)
s_d <- sd(female_heights$daughter)
r <- cor(female_heights$mother, female_heights$daughter)
m <-  r * s_d / s_m
b <- m_d - m*m_d

expected_60 <- m_d + ((r*(60-m_m)/s_m)*s_d)