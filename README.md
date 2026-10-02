esr
Ridge Regression Tools in R

esr is an R package developed as an academic project to implement and test a Ridge regression model.

The main function of the package is ridge_fit(), which estimates regression coefficients using Ridge regularization.

Ridge regression adds a regularization parameter, lambda, to the least-squares estimation. This parameter controls the amount of shrinkage applied to the regression coefficients.

Installation

You can install the development version of esr from GitHub with:

# install.packages("pak")
pak::pak("Djidjoho-Marcel/esr")


You can then load the package with:

library(esr)

Usage

The main function is:

ridge_fit(X, y, lambda = 1)

Arguments

X: A numeric matrix containing the predictor variables.

y: A numeric response vector.

lambda: A non-negative regularization parameter. The default value is 1.

The function returns a vector containing the estimated Ridge regression coefficients.

Example

The following example creates a small dataset and fits a Ridge regression model:

library(esr)

X <- matrix(
  c(1, 2,
    2, 3,
    3, 4,
    4, 5,
    5, 6),
  ncol = 2,
  byrow = TRUE
)

y <- c(2, 3, 5, 7, 8)

ridge_fit(X, y, lambda = 1)

Effect of lambda

The regularization parameter lambda controls the strength of the Ridge penalty.

For example:

fit_1 <- ridge_fit(X, y, lambda = 1)
fit_10 <- ridge_fit(X, y, lambda = 10)

fit_1
fit_10


Changing lambda changes the estimated coefficients. A larger value of lambda applies stronger regularization.

Mathematical formulation

The Ridge estimator implemented in this package is based on:

β̂ = (XᵀX + λI)⁻¹Xᵀy


where:

X is the predictor matrix;

y is the response vector;

λ is the regularization parameter;

I is the identity matrix;

β̂ represents the estimated regression coefficients.

Tests

The package includes tests using testthat.

The tests verify that:

ridge_fit() returns the expected number of coefficients;

the estimated coefficients match the expected values for the example dataset;

changing lambda changes the Ridge coefficients.

Tests can be run with:

devtools::test()

Project structure

The main components of the package are:

esr/
├── R/
│   ├── ridge.R
│   └── ridge_fit.R
├── tests/
│   └── testthat/
│       └── test-ridge_fit.R
├── man/
├── DESCRIPTION
├── LICENSE
└── README.md

License

This project is licensed under the MIT License.

Author

HOUNKONNOU DJIDJOHO MARCEL

GitHub: https://github.com/Djidjoho-Marcel
