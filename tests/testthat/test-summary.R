test_that("print.scindex_fit works", {

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

  expect_output(
    print(fit),
    "scindex"
  )

  expect_output(
    print(fit),
    "Cohen's kappa"
  )

})

test_that("summary.scindex_fit works without truth", {

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

  expect_output(
    summary(fit),
    "Summary of scindex fit"
  )

  expect_output(
    summary(fit),
    "SCI was not computed"
  )

})

test_that("summary.scindex_fit works with truth", {

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

  expect_output(
    summary(fit),
    "Strategic Convergence"
  )

  expect_output(
    summary(fit),
    "SDT thresholds by rater"
  )

  expect_output(
    summary(fit),
    "SCI"
  )

})
