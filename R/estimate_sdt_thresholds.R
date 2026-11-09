#' Estimate SDT Decision Thresholds
#'
#' Internal utility for estimating signal-detection-theoretic
#' decision thresholds from binary ratings and observed truth labels.
#'
#' For each rater, the function computes:
#'
#' - hit rate;
#' - false-alarm rate;
#' - SDT decision threshold.
#'
#' Thresholds are estimated as:
#'
#' \deqn{
#' t_i = -\frac{1}{2}[z(H_i) + z(F_i)]
#' }
#'
#' where:
#' - \eqn{H_i} is the hit rate;
#' - \eqn{F_i} is the false-alarm rate;
#' - \eqn{z(\cdot)} is the inverse standard normal CDF.
#'
#' A log-linear correction is applied to avoid infinite z-values.
#'
#' @param data Standardized long-format data frame.
#' @param item_col Character string identifying the item column.
#' @param rater_col Character string identifying the rater column.
#' @param rating_col Character string identifying the rating column.
#' @param truth_col Character string identifying the truth column.
#' @param positive Positive class value.
#'
#' @return A list containing:
#' \describe{
#'   \item{thresholds}{Data frame with SDT quantities for each rater.}
#'   \item{mean_threshold}{Mean threshold across raters.}
#'   \item{threshold_variance}{Variance of thresholds.}
#' }
#'
#' @references
#' DeCarlo, L. T. (1998). Signal detection theory and generalized
#' linear models. \emph{Psychological Methods, 3}(2), 186--205.
#' https://doi.org/10.1037/1082-989X.3.2.186
#'
#' Macmillan, N. A., & Creelman, C. D. (2004).
#' \emph{Detection theory: A user's guide} (2nd ed.).
#' New York, NY: Psychology Press.
#' https://doi.org/10.4324/9781410611147

estimate_sdt_thresholds <- function(data,
                                     item_col,
                                     rater_col,
                                     rating_col,
                                     truth_col,
                                     positive = 1) {

  raters <- unique(data[[rater_col]])

  out <- vector("list", length(raters))

  for (i in seq_along(raters)) {

    current_rater <- raters[i]

    dat_r <- data[
      data[[rater_col]] == current_rater,
      ,
      drop = FALSE
    ]

    truth <- dat_r[[truth_col]]
    rating <- dat_r[[rating_col]]

    hits <- sum(rating == 1L & truth == 1L)
    misses <- sum(rating == 0L & truth == 1L)

    false_alarms <- sum(rating == 1L & truth == 0L)
    correct_rejections <- sum(rating == 0L & truth == 0L)

    n_signal <- hits + misses
    n_noise <- false_alarms + correct_rejections

    hit_rate <- (hits + 0.5) / (n_signal + 1)

    false_alarm_rate <- (false_alarms + 0.5) /
      (n_noise + 1)

    z_hit <- stats::qnorm(hit_rate)

    z_fa <- stats::qnorm(false_alarm_rate)

    threshold <- -0.5 * (z_hit + z_fa)

    sensitivity <- hits / n_signal

    specificity <- correct_rejections / n_noise

    accuracy <- mean(rating == truth)

    out[[i]] <- data.frame(
      rater = current_rater,
      hit_rate = hit_rate,
      false_alarm_rate = false_alarm_rate,
      z_hit = z_hit,
      z_false_alarm = z_fa,
      threshold = threshold,
      sensitivity = sensitivity,
      specificity = specificity,
      accuracy = accuracy,
      stringsAsFactors = FALSE
    )
  }

  thresholds <- do.call(rbind, out)

  rownames(thresholds) <- NULL

  out <- list(
    thresholds = thresholds,
    mean_threshold = mean(thresholds$threshold),
    threshold_variance = stats::var(
      thresholds$threshold
    )
  )

  out
}
