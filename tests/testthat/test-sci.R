test_that("SCI is computed when truth is available", {

  dat <- data.frame(
    item = rep(1:8, each = 2),
    rater = rep(c("A", "B"), times = 8),
    rating = c(
      1, 1,
      1, 0,
      1, 1,
      0, 0,
      1, 1,
      0, 0,
      0, 1,
      0, 0
    ),
    truth = rep(
      c(1, 1, 1, 1, 0, 0, 0, 0),
      each = 2
    )
  )

  fit <- scindex(
    data = dat,
    item = item,
    rater = rater,
    rating = rating,
    truth = truth,
    variance_bounds = c(-3, 3)
  )

  expect_true(is.numeric(fit$sci))
  expect_length(fit$sci, 1)
  expect_true(fit$sci >= 0)
  expect_true(fit$sci <= 1)

})

test_that("SCI is not computed when truth is unavailable", {

  dat <- data.frame(
    item = rep(1:4, each = 2),
    rater = rep(c("A", "B"), times = 4),
    rating = c(
      1, 1,
      0, 0,
      1, 0,
      0, 0
    )
  )

  fit <- scindex(
    data = dat,
    item = item,
    rater = rater,
    rating = rating
  )

  expect_true(is.na(fit$sci))
  expect_null(fit$thresholds)
  expect_null(fit$sdt)

})

test_that("SCI equals one when thresholds are identical", {

  sci_fun <- getFromNamespace("compute_sci", "scindex")

  thresholds <- c(0.5, 0.5, 0.5)

  sci <- sci_fun(
    thresholds = thresholds,
    variance_bounds = c(-3, 3)
  )

  expect_equal(sci, 1)

})

test_that("SCI is bounded to the unit interval", {

  sci_fun <- getFromNamespace("compute_sci", "scindex")

  thresholds <- c(-10, 0, 10)

  sci <- sci_fun(
    thresholds = thresholds,
    variance_bounds = c(-1, 1)
  )

  expect_true(sci >= 0)
  expect_true(sci <= 1)

})

test_that("SCI uses supplied variance bounds", {

  sci_fun <- getFromNamespace("compute_sci", "scindex")

  thresholds <- c(-1, 0, 1)

  sci <- sci_fun(
    thresholds = thresholds,
    variance_bounds = c(-3, 3)
  )

  expected_var <- stats::var(thresholds)
  expected_var_max <- ((3 - (-3))^2) / 12
  expected_sci <- 1 - (expected_var / expected_var_max)

  expect_equal(sci, expected_sci)

})

test_that("SCI uses symmetric empirical bounds when variance_bounds is NULL", {

  sci_fun <- getFromNamespace("compute_sci", "scindex")

  thresholds <- c(-0.5, 0, 0.5)

  sci <- sci_fun(
    thresholds = thresholds,
    variance_bounds = NULL
  )

  bound <- max(abs(thresholds))
  bound <- max(bound, 1)

  expected_var <- stats::var(thresholds)
  expected_var_max <- ((bound - (-bound))^2) / 12
  expected_sci <- 1 - (expected_var / expected_var_max)
  expected_sci <- max(min(expected_sci, 1), 0)

  expect_equal(sci, expected_sci)

})
