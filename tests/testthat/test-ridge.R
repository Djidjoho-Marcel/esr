
test_that("L'estimation et la prédiction Ridge fonctionnent", {
  X <- matrix(rnorm(100), ncol = 2)
  beta_vrai <- c(1.5, -2)
  y <- X %*% beta_vrai + rnorm(50, sd = 0.1)

  b_ridge <- estimer_ridge(X, y, lambda = 0.5)
  expect_length(b_ridge, 2)
  expect_type(b_ridge, "double")

  preds <- predire_ridge(X, b_ridge)
  expect_length(preds, 50)
  expect_type(preds, "double")
})
test_that("Les fonctions de validation croisée (R et C++) retournent des structures valides", {
  X <- matrix(rnorm(100), ncol = 2)
  y <- X %*% c(1, -1) + rnorm(50)
  lambdas <- c(0.1, 0.5, 1.0)

  res_r <- cv_ridge_r(X, y, lambdas = lambdas, k = 3)
  res_cpp <- cv_ridge_cpp(X, y, lambdas = lambdas, k = 3)

  expect_length(res_r, 3)
  expect_false(any(is.na(res_r)))

  expect_length(res_cpp, 3)
  expect_false(any(is.na(res_cpp)))
})
test_that("La fonction graphique génère bien un objet ggplot2 valide", {
  g <- plot_cv_ridge(c(0.1, 0.5, 1.0), c(0.45, 0.48, 0.55))
  expect_s3_class(g, "ggplot")
})
