# 18.3 Least Squares Estimates

## Understanding Least Squares Estimates (LSE)

### What is LSE?
Least squares estimation finds the best-fitting line (or model) for data by minimizing the differences (errors) between predicted and actual values.

### Why use a linear model?
- A linear model describes the relationship between two variables using an equation.
- Example: In Galton’s study of father-son heights:
  
  ```
  Y_i = β₀ + β₁xᵢ + εᵢ
  ```

  - `Yᵢ` = son’s height (dependent variable)
  - `xᵢ` = father’s height (independent variable)
  - `β₀` = intercept (predicted height when father’s height is zero)
  - `β₁` = slope (change in son’s height per inch of father’s height)
  - `εᵢ` = error term (random variation)

## 18.3.2 Least Squares Estimates (LSE)

### Finding the Best `β₀` and `β₁`
- We use **Least Squares Estimation (LSE)** to minimize the sum of squared differences between actual and predicted values.
- **Residual Sum of Squares (RSS):**

  ```
  RSS = Σ (yᵢ - (β₀ + β₁xᵢ))²
  ```

### Implementing in R
#### 1. Load and preprocess Galton’s data:

```r
library(HistData)
data("GaltonFamilies")
set.seed(1983)
galton_heights <- GaltonFamilies |>
  filter(gender == "male") |>
  group_by(family) |>
  sample_n(1) |>
  ungroup() |>
  select(father, childHeight) |>
  rename(son = childHeight)
```

#### 2. Define a function to compute RSS:

```r
rss <- function(beta0, beta1, data){
  resid <- galton_heights$son - (beta0 + beta1 * galton_heights$father)
  return(sum(resid^2))
}
```

#### 3. Visualize RSS as a function of `β₁`:

```r
beta1 = seq(0, 1, len = nrow(galton_heights))
results <- data.frame(beta1 = beta1,
                      rss = sapply(beta1, rss, beta0 = 25))
results |> ggplot(aes(beta1, rss)) + geom_line()
```

- The graph helps find the `β₁` value that minimizes RSS.

## 18.3.3 The `lm` Function

Instead of manual calculations, we can use the `lm()` function in R:

```r
fit <- lm(son ~ father, data = galton_heights)
fit$coef
```

### Output:

```
(Intercept)    father 
    37.288      0.461
```

- `β₀ = 37.288` → Hypothetical son’s height when father’s height is 0.
- `β₁ = 0.461` → Each additional inch in father’s height increases the son's height by 0.461 inches.

### Extract More Information

```r
summary(fit)
```

- `R² = 0.188`, meaning father’s height explains **18.8%** of the variance in son’s height.
- LSEs are random variables with a known distribution in statistical theory.

## Key Takeaways
- Least squares estimation finds the best model by minimizing errors.
- The `lm()` function in R simplifies LSE computation.
- The slope `β₁` tells us how much the dependent variable changes per unit increase in the independent variable.
