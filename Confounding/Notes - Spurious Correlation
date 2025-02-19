# Spurious Correlation

## Key Takeaways

- **Correlation is not causation**: A strong correlation between two variables does not imply one causes the other.
- **Example**: Divorce rates and margarine consumption are highly correlated, but one does not cause the other.
- **Spurious Correlations**: These arise from random patterns in data rather than actual relationships.
- **Data Dredging (Fishing/Snooping)**:
  - Cherry-picking results to support a theory.
  - Finding random correlations in large datasets.
  - Monte Carlo simulations demonstrate how uncorrelated variables can appear correlated by chance.

## Monte Carlo Simulation Example

```r
N <- 25
g <- 1000000
sim_data <- tibble(group = rep(1:g, each=N), 
                   x = rnorm(N * g), 
                   y = rnorm(N * g))
```
- Generates **1,000,000** random groups with independent variables `X` and `Y`.
- **Expectation**: `X` and `Y` are uncorrelated.

### Finding the Maximum Correlation

```r
res <- sim_data |> 
  group_by(group) |> 
  summarize(r = cor(x, y)) |> 
  arrange(desc(r))
res
```
- The highest correlation observed: **0.77**, purely by chance.

### Visualizing the Most Correlated Group

```r
sim_data |> filter(group == res$group[which.max(res$r)]) |>
  ggplot(aes(x, y)) +
  geom_point() + 
  geom_smooth(method = "lm")
```
- Produces a misleading plot suggesting correlation where none exists.

### Distribution of Correlations

```r
res |> ggplot(aes(x=r)) + geom_histogram(binwidth = 0.1, color = "black")
```
- Shows that most correlations are near zero, but some extreme values exist by chance.

## P-Hacking

- **Definition**: Selecting only statistically significant results from multiple tests.
- **Example**: Running many regressions and reporting only the lowest p-value.
- **Problem**: Leads to false claims of significant relationships.

```r
library(broom)
sim_data |> 
  filter(group == res$group[which.max(res$r)]) |>
  summarize(tidy(lm(y ~ x))) |> 
  filter(term == "x")
```
- Produces a statistically significant result (**p = 0.00000670**), but it's purely random.

### Issues with P-Hacking:
- **Scientific bias**: Journals favor positive results.
- **Multiple testing problem**: Increases the likelihood of false discoveries.
- **Solutions**:
  - Adjust for multiple comparisons.
  - Report all tested hypotheses, not just significant ones.
  - Use Bayesian methods or stricter p-value thresholds.

---

