test_that("scindex requires a data frame", {

  expect_error(
    scindex(
      data = matrix(1:10),
      item = item,
      rater = rater,
      rating = rating
    ),
    "`data` must be a data frame."
  )

})

test_that("required columns must exist", {

  dat <- data.frame(
    item = 1:4,
    rating = c(0, 1, 0, 1)
  )

  expect_error(
    scindex(
      data = dat,
      item = item,
      rater = rater,
      rating = rating
    ),
    "required columns"
  )

})

test_that("ratings must be binary", {

  dat <- data.frame(
    item = rep(1:3, each = 2),
    rater = rep(c("A", "B"), times = 3),
    rating = c(0, 1, 2, 0, 1, 1)
  )

  expect_error(
    scindex(
      data = dat,
      item = item,
      rater = rater,
      rating = rating
    ),
    "exactly two unique categories"
  )

})

test_that("positive class must exist in ratings", {

  dat <- data.frame(
    item = rep(1:3, each = 2),
    rater = rep(c("A", "B"), times = 3),
    rating = c(0, 1, 0, 1, 0, 1)
  )

  expect_error(
    scindex(
      data = dat,
      item = item,
      rater = rater,
      rating = rating,
      positive = 2
    ),
    "`positive` must correspond"
  )

})

test_that("truth labels must be binary", {

  dat <- data.frame(
    item = rep(1:3, each = 2),
    rater = rep(c("A", "B"), times = 3),
    rating = c(0, 1, 0, 1, 0, 1),
    truth = c(0, 1, 2, 0, 1, 1)
  )

  expect_error(
    scindex(
      data = dat,
      item = item,
      rater = rater,
      rating = rating,
      truth = truth
    ),
    "`truth` must contain exactly two unique categories"
  )

})

test_that("duplicate item-rater combinations are rejected", {

  dat <- data.frame(
    item = c(1, 1, 1),
    rater = c("A", "A", "B"),
    rating = c(1, 0, 1)
  )

  expect_error(
    scindex(
      data = dat,
      item = item,
      rater = rater,
      rating = rating
    ),
    "Each item-rater combination must appear only once"
  )

})

test_that("variance bounds must be valid", {

  dat <- data.frame(
    item = rep(1:3, each = 2),
    rater = rep(c("A", "B"), times = 3),
    rating = c(0, 1, 0, 1, 0, 1),
    truth = c(0, 0, 1, 1, 0, 0)
  )

  expect_error(
    scindex(
      data = dat,
      item = item,
      rater = rater,
      rating = rating,
      truth = truth,
      variance_bounds = c(1, 1)
    ),
    "lower variance bound"
  )

})
