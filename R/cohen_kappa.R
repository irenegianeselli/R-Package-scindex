#' Compute Cohen's Kappa
#'
#' Internal utility for computing Cohen's kappa for two raters.
#'
#' The function expects a binary item-by-rater matrix with exactly
#' two columns and computes:
#'
#' - observed agreement;
#' - expected agreement;
#' - Cohen's kappa.
#'
#' @param ratings A binary item-by-rater matrix with two columns.
#'
#' @return A list containing:
#' \describe{
#'   \item{kappa}{Cohen's kappa coefficient.}
#'   \item{observed_agreement}{Observed agreement proportion.}
#'   \item{expected_agreement}{Chance-expected agreement proportion.}
#'   \item{confusion_matrix}{2 × 2 contingency table.}
#' }
#'
#' @noRd
cohen_kappa <- function(ratings) {

  if (!is.matrix(ratings)) {
    stop(
      "`ratings` must be a matrix.",
      call. = FALSE
    )
  }

  if (ncol(ratings) != 2L) {
    stop(
      "Cohen's kappa requires exactly two raters.",
      call. = FALSE
    )
  }

  complete_rows <- stats::complete.cases(ratings)

  ratings <- ratings[complete_rows, , drop = FALSE]

  r1 <- ratings[, 1]
  r2 <- ratings[, 2]

  tab <- table(r1, r2)

  po <- mean(r1 == r2)

  p1 <- prop.table(table(r1))
  p2 <- prop.table(table(r2))

  pe <- sum(p1 * p2)

  if (isTRUE(all.equal(1 - pe, 0))) {

    kappa <- NA_real_

  } else {

    kappa <- (po - pe) / (1 - pe)
  }

  out <- list(
    kappa = unname(kappa),
    observed_agreement = unname(po),
    expected_agreement = unname(pe),
    confusion_matrix = tab,
    n_items = length(r1)
  )

  out
}
