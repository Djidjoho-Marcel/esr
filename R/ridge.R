#' Regression Ridge
#' @param X Matrice X.
#' @param y Vecteur y.
#' @param lambdas Penalites lambda.
#' @param K Nombre de plis.
#' @param use_cpp Utiliser C++.
#' @return Objet ridge.
#' @export
ridge <- function(X, y, lambdas = 10^seq(-3, 3, length.out = 50), K = 5, use_cpp = TRUE) { if (!is.matrix(X)) X <- as.matrix(X); if (any(lambdas < 0)) stop('lambda negatif'); if (nrow(X) != length(y)) stop('Dimensions invalides'); cv_mse <- NULL; best_lambda <- lambdas[1]; if (length(lambdas) > 1) { cv_mse <- if (use_cpp) as.vector(cv_ridge_cpp(X, y, lambdas, K)) else cv_ridge_r(X, y, lambdas, K); best_lambda <- lambdas[which.min(cv_mse)] }; p <- ncol(X); beta <- as.vector(solve(crossprod(X) + diag(best_lambda, p), crossprod(X, y))); names(beta) <- if (is.null(colnames(X))) paste0('V', seq_len(p)) else colnames(X); structure(list(coefficients = beta, lambda_min = best_lambda, lambdas = lambdas, cv_mse = cv_mse, call = match.call()), class = 'ridge') }
#' @export
print.ridge <- function(x, ...) { cat('Modele Ridge | Lambda :', round(x$lambda_min, 4), '\n'); print(round(x$coefficients, 4)); invisible(x) }
#' @export
plot.ridge <- function(x, ...) { if (is.null(x$cv_mse)) stop('Pas de CV'); graphics::plot(x$lambdas, x$cv_mse, log = 'x', type = 'b', pch = 19, col = 'steelblue', xlab = 'Lambda', ylab = 'MSE', main = 'Validation croisee', ...); graphics::abline(v = x$lambda_min, col = 'firebrick', lty = 2) }
#' @export
predict.ridge <- function(object, newdata, ...) { if (!is.matrix(newdata)) newdata <- as.matrix(newdata); if (ncol(newdata) != length(object$coefficients)) stop('Colonnes invalides'); as.vector(newdata %*% object$coefficients) }
