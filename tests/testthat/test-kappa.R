test_that("Cohen's kappa is computed for two raters", {

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

  expect_s3_class(fit, "scindex_fit")
  expect_equal(fit$kappa_type, "Cohen's kappa")
  expect_equal(fit$n_raters, 2)
  expect_equal(fit$n_items, 4)

  # Observed agreement = 3/4.
  # Marginals:
  # Rater A: P(1)=0.50, P(0)=0.50
  # Rater B: P(1)=0.25, P(0)=0.75
  # Expected agreement = (0.50 * 0.25) + (0.50 * 0.75) = 0.50
  # Kappa = (0.75 - 0.50) / (1 - 0.50) = 0.50

  expect_equal(fit$kappa, 0.5)
  expect_equal(fit$agreement$observed_agreement, 0.75)
  expect_equal(fit$agreement$expected_agreement, 0.5)

})

test_that("Fleiss' kappa is computed for more than two raters", {

  dat <- data.frame(
    item = rep(1:4, each = 3),
    rater = rep(c("A", "B", "C"), times = 4),
    rating = c(
      1, 1, 1,
      0, 0, 0,
      1, 1, 0,
      0, 1, 0
    )
  )

  fit <- scindex(
    data = dat,
    item = item,
    rater = rater,
    rating = rating
  )

  expect_s3_class(fit, "scindex_fit")
  expect_equal(fit$kappa_type, "Fleiss' kappa")
  expect_equal(fit$n_raters, 3)
  expect_equal(fit$n_items, 4)

  # Category counts by item:
  # Item 1: 0 positives? no -> counts (0, 3), P_i = 1
  # Item 2: counts (3, 0), P_i = 1
  # Item 3: counts (1, 2), P_i = 1/3
  # Item 4: counts (2, 1), P_i = 1/3
  # Mean observed agreement = (1 + 1 + 1/3 + 1/3) / 4 = 2/3
  #
  # Total category proportions:
  # zeros = 6/12 = 0.5
  # ones  = 6/12 = 0.5
  # Expected agreement = 0.5^2 + 0.5^2 = 0.5
  #
  # Fleiss' kappa = (2/3 - 0.5) / (1 - 0.5) = 1/3

  expect_equal(fit$kappa, 1 / 3)
  expect_equal(fit$agreement$observed_agreement, 2 / 3)
  expect_equal(fit$agreement$expected_agreement, 0.5)

})

test_that("kappa is returned without SCI when truth is unavailable", {

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

  expect_false(fit$truth_available)
  expect_true(is.na(fit$sci))
  expect_null(fit$thresholds)
  expect_null(fit$sdt)

})
