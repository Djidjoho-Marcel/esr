# esr : Ridge Regression Tools in R

Package R pour ajuster un modele de regression Ridge avec selection automatique de l'hyperparametre `lambda` par validation croisee (acceleree en C++ avec `RcppArmadillo`), visualisation et prediction.

## Installation

```r
remotes::install_github("Djidjoho-Marcel/esr")
```

## Exemple d'utilisation

```r
library(esr)
set.seed(42)
X <- matrix(rnorm(200), 40, 5)
y <- X %*% c(2, -1, 0.5, 0, 0) + rnorm(40)

# Ajustement du modele Ridge avec validation croisee
mod <- ridge(X, y)
print(mod)
plot(mod)

# Predictions sur de nouvelles observations
preds <- predict(mod, X[1:5, ])
```
