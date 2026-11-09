test_that("scindex_example works with Cohen's kappa", {

  fit <- scindex(
    data = scindex_example,
    item = item,
    rater = rater,
    rating = rating,
    truth = truth,
    variance_bounds = c(-3, 3)
  )

  expect_s3_class(fit, "scindex_fit")
  expect_equal(fit$n_items, 8)
  expect_equal(fit$n_raters, 2)
  expect_true(fit$truth_available)

  expect_equal(fit$kappa_type, "Cohen's kappa")

  expect_true(is.numeric(fit$kappa))
  expect_true(is.numeric(fit$sci))

  expect_true(fit$sci >= 0)
  expect_true(fit$sci <= 1)

})

test_that("scindex_example_multi works with Fleiss' kappa", {

  fit <- scindex(
    data = scindex_example_multi,
    item = item,
    rater = rater,
    rating = rating,
    truth = truth,
    variance_bounds = c(-3, 3)
  )

  expect_s3_class(fit, "scindex_fit")
  expect_equal(fit$n_items, 8)
  expect_equal(fit$n_raters, 3)
  expect_true(fit$truth_available)

  expect_equal(fit$kappa_type, "Fleiss' kappa")

  expect_true(is.numeric(fit$kappa))
  expect_true(is.numeric(fit$sci))

  expect_true(fit$sci >= 0)
  expect_true(fit$sci <= 1)

})
