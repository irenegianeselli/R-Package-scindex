#' Summarize a scindex Object
#'
#' Summary method for objects of class `"scindex_fit"`.
#'
#' The method returns a structured summary including the agreement coefficient,
#' SCI when available, SDT threshold estimates, and basic diagnostic information.
#'
#' @param object An object of class `"scindex_fit"`.
#' @param digits Number of digits to print.
#' @param ... Additional arguments (unused).
#'
#' @return Invisibly returns `object`.
#'
#' @export
summary.scindex_fit <- function(object,
                                digits = 3,
                                ...) {

  cat("\n")
  cat("Summary of scindex fit\n")
  cat("----------------------\n\n")

  cat("Agreement\n")
  cat("---------\n")

  cat(
    paste0(
      "Type: ",
      object$kappa_type,
      "\n"
    )
  )

  cat(
    paste0(
      "Kappa: ",
      round(object$kappa, digits),
      "\n"
    )
  )

  cat(
    paste0(
      "Observed agreement: ",
      round(object$agreement$observed_agreement, digits),
      "\n"
    )
  )

  cat(
    paste0(
      "Expected agreement: ",
      round(object$agreement$expected_agreement, digits),
      "\n\n"
    )
  )

  cat("Design\n")
  cat("------\n")

  cat(
    paste0(
      "Number of items: ",
      object$n_items,
      "\n"
    )
  )

  cat(
    paste0(
      "Number of raters: ",
      object$n_raters,
      "\n"
    )
  )

  cat(
    paste0(
      "Ground truth available: ",
      object$truth_available,
      "\n\n"
    )
  )

  cat("Strategic Convergence\n")
  cat("---------------------\n")

  if (isTRUE(object$truth_available)) {

    cat(
      paste0(
        "SCI: ",
        round(object$sci, digits),
        "\n"
      )
    )

    cat(
      paste0(
        "Threshold variance: ",
        round(object$threshold_variance, digits),
        "\n"
      )
    )

    cat(
      paste0(
        "Mean threshold: ",
        round(object$sdt$mean_threshold, digits),
        "\n\n"
      )
    )

    cat("SDT thresholds by rater\n")
    cat("-----------------------\n")

    thresholds <- object$thresholds

    numeric_cols <- vapply(
      thresholds,
      is.numeric,
      logical(1)
    )

    thresholds[numeric_cols] <- lapply(
      thresholds[numeric_cols],
      round,
      digits = digits
    )

    print(
      thresholds,
      row.names = FALSE
    )

    cat("\n")

  } else {

    cat(
      "SCI was not computed because ground truth was not supplied.\n"
    )

    cat(
      "Agreement coefficients describe observed classification agreement only.\n\n"
    )
  }

  cat("Interpretive note\n")
  cat("-----------------\n")

  if (isTRUE(object$truth_available)) {

    cat(
      paste(
        "Kappa summarizes observed agreement.",
        "SCI summarizes convergence in estimated SDT decision thresholds.",
        "The two quantities should be interpreted as complementary, not interchangeable.",
        "\n"
      )
    )

  } else {

    cat(
      paste(
        "Without ground truth, SDT thresholds are not directly estimable by this function.",
        "Consequently, SCI is not reported.",
        "\n"
      )
    )
  }

  invisible(object)
}
