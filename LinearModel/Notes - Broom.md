# Linear Regression in the Tidyverse

## Overview
This guide explains how to use **linear regression (`lm`)** in the **tidyverse**, handle grouped data, and simplify workflows using the `broom` package.

---

## 1. Preparing the Baseball Dataset
Filter and transform the `Teams` dataset to include **per-game averages** of Home Runs (HR), Walks (BB), and Runs (R).

```r
library(dplyr)

dat <- Teams |> 
  filter(yearID %in% 1962:2001) |> 
  mutate(HR = round(HR/G, 1), 
         BB = BB/G, 
         R = R/G) |> 
  select(HR, BB, R) |> 
  filter(HR >= 0.4 & HR <= 1.2)
```

---

## 2. Computing Regression Slope Without `lm()`
Using the correlation formula to estimate slopes:

```r
get_slope <- function(x, y) cor(x, y) * sd(y) / sd(x)

dat |>  
  group_by(HR) |>  
  summarize(slope = get_slope(BB, R))
```

---

## 3. Using `lm()` for Regression (Issue with Grouped Tibbles)
`lm()` does **not** work correctly with `group_by()`:

```r
dat |>  
  group_by(HR) |>  
  lm(R ~ BB, data = _) |> coef()
```
Error: `lm()` does not recognize grouped tibbles.

### Solution: Writing a Custom Function

```r
get_slope <- function(x, y){
  fit <- lm(y ~ x)
  tibble(slope = fit$coefficients[2], 
         se = summary(fit)$coefficient[2,2])
}

dat |>  
  group_by(HR) |>  
  summarize(get_slope(BB, R))
```

---

## 4. Extracting More Regression Details
Returning **both intercept and slope**:

```r
get_lse <- function(x, y){
  fit <- lm(y ~ x)
  data.frame(term = names(fit$coefficients),
             slope = fit$coefficients, 
             se = summary(fit)$coefficient[,2])
}

dat |>  
  group_by(HR) |>  
  summarize(get_lse(BB, R))
```
Warning: `summarize()` expects one row per group. Use `reframe()` in **dplyr 1.1.0+**.

---

## 5. Using the `broom` Package
### Extracting Estimates

```r
library(broom)

fit <- lm(R ~ BB, data = dat)
tidy(fit)
```

### Adding Confidence Intervals

```r
tidy(fit, conf.int = TRUE)
```

---

## 6. Visualizing Confidence Intervals with `ggplot2`

```r
dat |>  
  group_by(HR) |>  
  summarize(tidy(lm(R ~ BB), conf.int = TRUE)) |>  
  filter(term == "BB") |>  
  select(HR, estimate, conf.low, conf.high) |>  
  ggplot(aes(HR, y = estimate, ymin = conf.low, ymax = conf.high)) +
  geom_errorbar() +
  geom_point()
```

Interpretation: Overlapping confidence intervals suggest **slopes are similar across HR levels**.

---

## 7. Model Fit Summaries with `broom`

```r
glance(fit)
```
Returns model performance metrics like **R-squared, AIC, and p-value**.

---

## Key Takeaways
- `lm()` **does not work directly** with grouped tibbles.
- Use **custom functions** or the **`broom` package** to handle regression results in the tidyverse.
- Confidence intervals help determine if slopes **differ significantly**.
- **Use `reframe()` instead of `summarize()`** when returning multiple rows per group.
- The `broom` package simplifies regression output handling.

Next Steps: Explore `augment()` from `broom` to analyze predictions and residuals.

---
