test_that("ridge_fit returns two coefficients", {

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

  result <- ridge_fit(X, y)

  expect_length(result, 2)
})


test_that("ridge_fit returns correct coefficients", {

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

  result <- ridge_fit(X, y)

  expect_equal(
    as.numeric(result),
    c(0.8214286, 0.6428571),
    tolerance = 1e-6
  )
})


test_that("lambda affects the ridge coefficients", {

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

  result_1 <- ridge_fit(X, y, lambda = 1)
  result_10 <- ridge_fit(X, y, lambda = 10)

  expect_false(
    isTRUE(all.equal(result_1, result_10))
  )
})
