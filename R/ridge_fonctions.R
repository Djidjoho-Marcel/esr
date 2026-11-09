#' Estimation des coefficients Ridge
#'
#' Calcule les coefficients de regression Ridge pour une valeur de lambda fixe.
#'
#' @param X Matrice des variables explicatives de dimension (n x p).
#' @param y Vecteur de la variable reponse de longueur n.
#' @param lambda Valeur du parametre de penalite (par defaut = 0.1).
#' @return Un vecteur numerique contenant les coefficients estimes.
#' @export
#' @examples
#' X <- matrix(rnorm(100), ncol = 2)
#' y <- X %*% c(1.5, -2) + rnorm(50)
#' estimer_ridge(X, y, lambda = 0.5)
estimer_ridge <- function(X, y, lambda = 0.1) {
  X <- as.matrix(X)
  y <- as.vector(y)
  p <- ncol(X)
  beta_ridge <- solve(t(X) %*% X + lambda * diag(p)) %*% t(X) %*% y
  return(as.vector(beta_ridge))
}

#' Prediction pour un modele Ridge
#'
#' Calcule les valeurs predites Y chapeau a partir d'une matrice de donnees et de coefficients.
#'
#' @param X Nouvelle matrice de donnees de dimension (m x p).
#' @param beta Vecteur des coefficients de longueur p.
#' @return Un vecteur numerique contenant les valeurs predites de longueur m.
#' @export
predire_ridge <- function(X, beta) {
  X <- as.matrix(X)
  beta <- as.vector(beta)
  return(as.vector(X %*% beta))
}

#' Validation croisee K-Fold pour Ridge (Version R)
#'
#' Evalue la performance de la regression Ridge par validation croisee pour une liste de lambdas.
#'
#' @param X Matrice des variables explicatives (n x p).
#' @param y Vecteur de la variable reponse (n).
#' @param lambdas Vecteur des valeurs de lambda a tester (par defaut = seq(0, 2, length.out = 20)).
#' @param k Nombre de plis pour la validation croisee (par defaut = 5).
#' @return Un vecteur numerique contenant l'erreur quadratique moyenne (MSE) pour chaque lambda.
#' @export
cv_ridge_r <- function(X, y, lambdas = seq(0, 2, length.out = 20), k = 5) {
  X <- as.matrix(X)
  y <- as.vector(y)
  n <- nrow(X)
  set.seed(42)
  plis <- sample(rep(1:k, length.out = n))
  mses <- numeric(length(lambdas))
  for (i in seq_along(lambdas)) {
    lam <- lambdas[i]
    mse_folds <- numeric(k)
    for (j in 1:k) {
      idx_test <- which(plis == j)
      X_train <- X[-idx_test, , drop = FALSE]
      y_train <- y[-idx_test]
      X_test  <- X[idx_test, , drop = FALSE]
      y_test  <- y[idx_test]
      b_hat <- estimer_ridge(X_train, y_train, lambda = lam)
      preds <- predire_ridge(X_test, b_hat)
      mse_folds[j] <- mean((y_test - preds)^2)
    }
    mses[i] <- mean(mse_folds)
  }
  return(mses)
}

#' Graphique de la performance de la validation croisee
#'
#' Genere un graphique ggplot2 montrant l'evolution du MSE selon la valeur de lambda.
#'
#' @param lambdas Vecteur des valeurs de lambda testees.
#' @param mses Vecteur des erreurs quadratiques moyennes correspondantes.
#' @return Un objet graphique de classe ggplot.
#' @export
plot_cv_ridge <- function(lambdas, mses) {
  if (length(lambdas) != length(mses)) {
    stop('Les vecteurs lambdas et mses doivent avoir la meme longueur.')
  }
  df <- data.frame(Lambda = lambdas, MSE = mses)
  p <- ggplot2::ggplot(df, ggplot2::aes(x = Lambda, y = MSE)) +
    ggplot2::geom_line(color = 'steelblue', linewidth = 1) +
    ggplot2::geom_point(color = 'darkblue', size = 2) +
    ggplot2::theme_minimal() +
    ggplot2::labs(
      title = 'Validation croisee pour la regression Ridge',
      subtitle = 'Performance du modele selon le parametre de regularisation',
      x = 'Valeur de Lambda',
      y = 'Erreur Quadratique Moyenne (MSE)'
    )
  return(p)
}

# Déclaration pour éviter la note CRAN sur les variables globales de ggplot2
if (getRversion() >= '2.15.1') utils::globalVariables(c('Lambda', 'MSE'))
