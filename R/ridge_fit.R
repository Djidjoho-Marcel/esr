#' Fit a Ridge regression model
#'
#' Fits a Ridge regression model using a regularization parameter.
#'
#' @param X A numeric matrix of predictors.
#' @param y A numeric response vector.
#' @param lambda A non-negative regularization parameter.
#'
#' @return A vector containing the estimated Ridge coefficients.
#'
#' @examples
#' X <- matrix(c(1, 2,
#'               2, 3,
#'               3, 4,
#'               4, 5,
#'               5, 6),
#'             ncol = 2, byrow = TRUE)
#' y <- c(2, 3, 5, 7, 8)
#'
#' ridge_fit(X, y, lambda = 1)
#'
#' @export
ridge_fit <- function(X, y, lambda = 1) {

  beta <- ridge(X, y, lambda)

  return(beta)
}
