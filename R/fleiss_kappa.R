#' Compute Fleiss' Kappa
#'
#' Internal utility for computing Fleiss' kappa for multiple raters.
#'
#' The function expects a binary item-by-rater matrix and computes:
#'
#' - item-level agreement;
#' - expected agreement;
#' - Fleiss' kappa.
#'
#' @param ratings A binary item-by-rater matrix.
#'
#' @return A list containing:
#' \describe{
#'   \item{kappa}{Fleiss' kappa coefficient.}
#'   \item{observed_agreement}{Mean observed agreement.}
#'   \item{expected_agreement}{Chance-expected agreement.}
#'   \item{item_agreement}{Agreement for each item.}
#' }
#'
#' @references
#' Fleiss, J. L. (1971). Measuring nominal scale agreement among
#' many raters. \emph{Psychological Bulletin, 76}(5), 378-382.
#'
#' @noRd
fleiss_kappa <- function(ratings) {

  if (!is.matrix(ratings)) {
    stop(
      "`ratings` must be a matrix.",
      call. = FALSE
    )
  }

  complete_rows <- stats::complete.cases(ratings)

  ratings <- ratings[complete_rows, , drop = FALSE]

  n_items <- nrow(ratings)
  n_raters <- ncol(ratings)

  if (n_raters < 2L) {
    stop(
      "Fleiss' kappa requires at least two raters.",
      call. = FALSE
    )
  }

  category_counts <- t(
    apply(
      ratings,
      1,
      function(x) {
        c(
          sum(x == 0L),
          sum(x == 1L)
        )
      }
    )
  )

  colnames(category_counts) <- c("0", "1")

  item_agreement <- apply(
    category_counts,
    1,
    function(counts) {

      numerator <- sum(counts * (counts - 1))

      numerator / (n_raters * (n_raters - 1))
    }
  )

  p_j <- colSums(category_counts) /
    (n_items * n_raters)

  p_bar <- mean(item_agreement)

  p_e <- sum(p_j^2)

  if (isTRUE(all.equal(1 - p_e, 0))) {

    kappa <- NA_real_

  } else {

    kappa <- (p_bar - p_e) / (1 - p_e)
  }

  out <- list(
    kappa = unname(kappa),
    observed_agreement = unname(p_bar),
    expected_agreement = unname(p_e),
    item_agreement = item_agreement,
    category_proportions = p_j,
    n_items = n_items,
    n_raters = n_raters
  )

  out
}
