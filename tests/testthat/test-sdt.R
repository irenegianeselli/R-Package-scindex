test_that("SDT quantities are correctly estimated", {

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
    truth = truth
  )

  expect_true(fit$truth_available)

  expect_true(is.data.frame(fit$thresholds))

  expect_true(all(
    c(
      "rater",
      "hit_rate",
      "false_alarm_rate",
      "threshold",
      "sensitivity",
      "specificity",
      "accuracy"
    ) %in% names(fit$thresholds)
  ))

  expect_equal(nrow(fit$thresholds), 2)

})

test_that("hit and false-alarm rates are bounded", {

  dat <- data.frame(
    item = rep(1:6, each = 2),
    rater = rep(c("A", "B"), times = 6),
    rating = c(
      1, 1,
      1, 1,
      1, 1,
      0, 0,
      0, 0,
      0, 0
    ),
    truth = rep(
      c(1, 1, 1, 0, 0, 0),
      each = 2
    )
  )

  fit <- scindex(
    data = dat,
    item = item,
    rater = rater,
    rating = rating,
    truth = truth
  )

  expect_true(all(
    fit$thresholds$hit_rate > 0 &
      fit$thresholds$hit_rate < 1
  ))

  expect_true(all(
    fit$thresholds$false_alarm_rate > 0 &
      fit$thresholds$false_alarm_rate < 1
  ))

})

test_that("perfect performance does not produce infinite thresholds", {

  dat <- data.frame(
    item = rep(1:8, each = 2),
    rater = rep(c("A", "B"), times = 8),
    rating = rep(
      c(1, 1, 1, 1, 0, 0, 0, 0),
      each = 2
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
    truth = truth
  )

  expect_false(any(is.infinite(
    fit$thresholds$threshold
  )))

  expect_false(any(is.nan(
    fit$thresholds$threshold
  )))

})

test_that("threshold variance is computed", {

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
    truth = truth
  )

  expect_true(is.numeric(
    fit$threshold_variance
  ))

  expect_length(
    fit$threshold_variance,
    1
  )

  expect_true(
    fit$threshold_variance >= 0
  )

})
