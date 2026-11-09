#' Compute the Strategic Convergence Index
#'
#' Internal utility for computing the Strategic Convergence Index (SCI)
#' from a vector of SDT decision thresholds.
#'
#' SCI is defined as:
#'
#' \deqn{
#' SCI = 1 - \frac{Var(t_i)}{Var_{max}}
#' }
#'
#' where:
#' - \eqn{Var(t_i)} is the variance of rater thresholds;
#' - \eqn{Var_{max}} is the reference variance under maximal
#'   threshold dispersion.
#'
#' The reference variance is computed as:
#'
#' \deqn{
#' Var_{max} = \frac{(b-a)^2}{12}
#' }
#'
#' where \eqn{a} and \eqn{b} define the admissible threshold interval.
#'
#' If `variance_bounds = NULL`, symmetric empirical bounds are derived
#' from the estimated thresholds using the largest absolute threshold,
#' with a minimum bound of 1.
#'
#' SCI is bounded to the unit interval \eqn{[0,1]}.
#'
#' @param thresholds Numeric vector of SDT thresholds.
#' @param variance_bounds Optional numeric vector of length 2 specifying
#'   lower and upper bounds for threshold dispersion.
#'
#' @return Numeric SCI value.
#'
#' @references
#' Gianeselli, I. (2026). From agreement to epistemic alignment:
#' A signal detection-theoretic model of inter-rater reliability.
#' \emph{Educational and Psychological Measurement}.
#' https://doi.org/10.1177/00131644261417643
#'
#' @noRd
compute_sci <- function(thresholds,
                        variance_bounds = NULL) {

  if (!is.numeric(thresholds)) {
    stop("`thresholds` must be numeric.", call. = FALSE)
  }

  if (length(thresholds) < 2L) {
    stop("At least two thresholds are required.", call. = FALSE)
  }

  if (anyNA(thresholds)) {
    stop("`thresholds` must not contain missing values.", call. = FALSE)
  }

  threshold_variance <- stats::var(thresholds)

  if (is.null(variance_bounds)) {

    bound <- max(abs(thresholds))
    bound <- max(bound, 1)

    lower <- -bound
    upper <- bound

  } else {

    lower <- variance_bounds[1]
    upper <- variance_bounds[2]
  }

  var_max <- ((upper - lower)^2) / 12

  if (isTRUE(all.equal(var_max, 0))) {
    sci <- NA_real_
  } else {
    sci <- 1 - (threshold_variance / var_max)
  }

  sci <- max(min(sci, 1), 0)

  unname(sci)
}
