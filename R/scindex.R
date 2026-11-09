#' Compute Agreement and the Strategic Convergence Index
#'
#' `scindex()` computes classical inter-rater agreement and, when a ground-truth
#' variable is available, the Strategic Convergence Index (SCI). The function
#' automatically returns Cohen's kappa for two raters and Fleiss' kappa for more
#' than two raters.
#'
#' SCI is computed from signal-detection-theoretic decision thresholds and should
#' be interpreted as a model-based index of convergence in rater decision criteria,
#' not as a replacement for agreement coefficients.
#'
#' @param data A data frame containing item identifiers, rater identifiers, ratings,
#'   and optionally ground-truth labels.
#' @param item Unquoted column name identifying the rated item or case.
#' @param rater Unquoted column name identifying the rater.
#' @param rating Unquoted column name containing the categorical rating. In the
#'   current version, ratings must be binary.
#' @param truth Optional unquoted column name containing the ground-truth label.
#'   If supplied, SDT thresholds and SCI are computed.
#' @param positive Value identifying the positive class. Defaults to `1`.
#' @param variance_bounds Optional numeric vector of length 2 defining the lower
#'   and upper bounds used to compute the reference variance for SCI. If `NULL`,
#'   bounds are derived from the estimated thresholds.
#'
#' @return An object of class `"scindex_fit"` containing the agreement coefficient,
#'   its type, SDT thresholds when available, SCI when available, and diagnostic
#'   information.
#'
#' @examples
#' ratings <- data.frame(
#'   item = rep(1:6, each = 2),
#'   rater = rep(c("A", "B"), times = 6),
#'   rating = c(1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1),
#'   truth = rep(c(1, 0, 1, 1, 0, 1), each = 2)
#' )
#'
#' fit <- scindex(
#'   data = ratings,
#'   item = item,
#'   rater = rater,
#'   rating = rating,
#'   truth = truth
#' )
#'
#' fit
#'
#' @export
scindex <- function(data,
                    item,
                    rater,
                    rating,
                    truth = NULL,
                    positive = 1,
                    variance_bounds = NULL) {

  item_col <- deparse(substitute(item))
  rater_col <- deparse(substitute(rater))
  rating_col <- deparse(substitute(rating))
  truth_col <- deparse(substitute(truth))

  truth_supplied <- !identical(truth_col, "NULL")

  validate_scindex_input(
    data = data,
    item_col = item_col,
    rater_col = rater_col,
    rating_col = rating_col,
    truth_col = if (truth_supplied) truth_col else NULL,
    positive = positive,
    variance_bounds = variance_bounds
  )

  prepared <- prepare_scindex_data(
    data = data,
    item_col = item_col,
    rater_col = rater_col,
    rating_col = rating_col,
    truth_col = if (truth_supplied) truth_col else NULL,
    positive = positive
  )

  n_raters <- length(unique(prepared$long[[rater_col]]))
  n_items <- length(unique(prepared$long[[item_col]]))

  if (n_raters == 2L) {
    agreement <- cohen_kappa(prepared$wide_ratings)
    kappa_type <- "Cohen's kappa"
  } else {
    agreement <- fleiss_kappa(prepared$wide_ratings)
    kappa_type <- "Fleiss' kappa"
  }

  thresholds <- NULL
  sdt <- NULL
  sci <- NA_real_
  threshold_variance <- NA_real_

  if (truth_supplied) {
    sdt <- estimate_sdt_thresholds(
      data = prepared$long,
      item_col = item_col,
      rater_col = rater_col,
      rating_col = rating_col,
      truth_col = truth_col,
      positive = positive
    )

    thresholds <- sdt$thresholds
    threshold_variance <- stats::var(thresholds$threshold)

    sci <- compute_sci(
      thresholds = thresholds$threshold,
      variance_bounds = variance_bounds
    )
  }

  out <- list(
    kappa = agreement$kappa,
    kappa_type = kappa_type,
    agreement = agreement,
    sci = sci,
    thresholds = thresholds,
    sdt = sdt,
    threshold_variance = threshold_variance,
    n_raters = n_raters,
    n_items = n_items,
    truth_available = truth_supplied,
    positive = positive,
    call = match.call()
  )

  class(out) <- "scindex_fit"
  out
}
