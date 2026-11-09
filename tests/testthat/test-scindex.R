test_that("scindex returns the expected object structure with truth", {

  dat <- data.frame(
    item = rep(1:8, each = 3),
    rater = rep(c("A", "B", "C"), times = 8),
    rating = c(
      1, 1, 1,
      0, 0, 1,
      1, 1, 0,
      0, 0, 0,
      1, 1, 1,
      0, 1, 0,
      1, 1, 1,
      0, 0, 0
    ),
    truth = rep(
      c(1, 0, 1, 0, 1, 0, 1, 0),
      each = 3
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

  expect_s3_class(fit, "scindex_fit")

  expect_named(
    fit,
    c(
      "kappa",
      "kappa_type",
      "agreement",
      "sci",
      "thresholds",
      "sdt",
      "threshold_variance",
      "n_raters",
      "n_items",
      "truth_available",
      "positive",
      "call"
    )
  )

  expect_equal(fit$kappa_type, "Fleiss' kappa")
  expect_true(fit$truth_available)
  expect_equal(fit$n_raters, 3)
  expect_equal(fit$n_items, 8)

  expect_true(is.numeric(fit$kappa))
  expect_true(is.numeric(fit$sci))
  expect_true(fit$sci >= 0)
  expect_true(fit$sci <= 1)

  expect_true(is.data.frame(fit$thresholds))
  expect_equal(nrow(fit$thresholds), 3)

})

test_that("scindex returns the expected object structure without truth", {

  dat <- data.frame(
    item = rep(1:6, each = 2),
    rater = rep(c("A", "B"), times = 6),
    rating = c(
      1, 1,
      0, 0,
      1, 0,
      1, 1,
      0, 0,
      1, 1
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
  expect_false(fit$truth_available)

  expect_true(is.numeric(fit$kappa))
  expect_true(is.na(fit$sci))
  expect_null(fit$thresholds)
  expect_null(fit$sdt)

})

test_that("scindex handles non-numeric binary labels", {

  dat <- data.frame(
    item = rep(1:6, each = 2),
    rater = rep(c("A", "B"), times = 6),
    rating = c(
      "yes", "yes",
      "no", "no",
      "yes", "no",
      "yes", "yes",
      "no", "no",
      "yes", "yes"
    ),
    truth = rep(
      c("yes", "no", "yes", "yes", "no", "yes"),
      each = 2
    )
  )

  fit <- scindex(
    data = dat,
    item = item,
    rater = rater,
    rating = rating,
    truth = truth,
    positive = "yes",
    variance_bounds = c(-3, 3)
  )

  expect_s3_class(fit, "scindex_fit")
  expect_equal(fit$kappa_type, "Cohen's kappa")
  expect_true(fit$truth_available)
  expect_true(is.numeric(fit$sci))
  expect_true(fit$sci >= 0)
  expect_true(fit$sci <= 1)

})
