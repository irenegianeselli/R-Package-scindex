#' Print a scindex Object
#'
#' Print method for objects of class `"scindex_fit"`.
#'
#' The method displays:
#' - agreement coefficient;
#' - agreement type;
#' - SCI when available;
#' - basic sample information.
#'
#' @param x An object of class `"scindex_fit"`.
#' @param digits Number of digits to print.
#' @param ... Additional arguments (unused).
#'
#' @return Invisibly returns `x`.
#'
#' @export
print.scindex_fit <- function(x,
                              digits = 3,
                              ...) {

  cat("\n")

  cat("scindex\n")

  cat(
    paste0(
      strrep("-", 8),
      "\n"
    )
  )

  cat(
    paste0(
      "Agreement coefficient: ",
      x$kappa_type,
      "\n"
    )
  )

  cat(
    paste0(
      "Kappa: ",
      round(x$kappa, digits),
      "\n"
    )
  )

  if (isTRUE(x$truth_available)) {

    cat(
      paste0(
        "SCI: ",
        round(x$sci, digits),
        "\n"
      )
    )

    cat(
      paste0(
        "Threshold variance: ",
        round(x$threshold_variance, digits),
        "\n"
      )
    )

  } else {

    cat(
      "SCI: not computed (ground truth unavailable)\n"
    )
  }

  cat(
    paste0(
      "Raters: ",
      x$n_raters,
      "\n"
    )
  )

  cat(
    paste0(
      "Items: ",
      x$n_items,
      "\n"
    )
  )

  cat("\n")

  invisible(x)
}
