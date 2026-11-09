#' Validate Inputs for scindex
#'
#' Internal validation utility for `scindex()`.
#'
#' This function checks:
#' - data structure;
#' - required columns;
#' - binary ratings;
#' - consistency of truth labels;
#' - validity of SCI variance bounds.
#'
#' @param data A data frame.
#' @param item_col Character string identifying the item column.
#' @param rater_col Character string identifying the rater column.
#' @param rating_col Character string identifying the rating column.
#' @param truth_col Optional character string identifying the truth column.
#' @param positive Value representing the positive class.
#' @param variance_bounds Optional numeric vector of length 2.
#'
#' @return Invisibly returns `TRUE`.
#'
#' @noRd
validate_scindex_input <- function(data,
                                    item_col,
                                    rater_col,
                                    rating_col,
                                    truth_col = NULL,
                                    positive = 1,
                                    variance_bounds = NULL) {

  if (!is.data.frame(data)) {
    stop("`data` must be a data frame.", call. = FALSE)
  }

  required_cols <- c(
    item_col,
    rater_col,
    rating_col
  )

  if (!is.null(truth_col)) {
    required_cols <- c(required_cols, truth_col)
  }

  missing_cols <- setdiff(required_cols, names(data))

  if (length(missing_cols) > 0L) {
    stop(
      paste0(
        "The following required columns are missing from `data`: ",
        paste(missing_cols, collapse = ", "),
        "."
      ),
      call. = FALSE
    )
  }

  if (anyNA(data[[item_col]])) {
    stop("`item` contains missing values.", call. = FALSE)
  }

  if (anyNA(data[[rater_col]])) {
    stop("`rater` contains missing values.", call. = FALSE)
  }

  if (anyNA(data[[rating_col]])) {
    stop("`rating` contains missing values.", call. = FALSE)
  }

  ratings <- unique(stats::na.omit(data[[rating_col]]))

  if (length(ratings) != 2L) {
    stop(
      "`rating` must contain exactly two unique categories.",
      call. = FALSE
    )
  }

  if (!(positive %in% ratings)) {
    stop(
      "`positive` must correspond to one of the observed rating values.",
      call. = FALSE
    )
  }

  if (!is.null(truth_col)) {

    if (anyNA(data[[truth_col]])) {
      stop("`truth` contains missing values.", call. = FALSE)
    }

    truth_values <- unique(stats::na.omit(data[[truth_col]]))

    if (length(truth_values) != 2L) {
      stop(
        "`truth` must contain exactly two unique categories.",
        call. = FALSE
      )
    }

    if (!all(truth_values %in% ratings)) {
      stop(
        "`truth` and `rating` must use the same category coding.",
        call. = FALSE
      )
    }
  }

  duplicated_ratings <- duplicated(
    data[, c(item_col, rater_col)]
  )

  if (any(duplicated_ratings)) {
    stop(
      "Each item-rater combination must appear only once.",
      call. = FALSE
    )
  }

  if (!is.null(variance_bounds)) {

    if (!is.numeric(variance_bounds)) {
      stop(
        "`variance_bounds` must be numeric.",
        call. = FALSE
      )
    }

    if (length(variance_bounds) != 2L) {
      stop(
        "`variance_bounds` must contain exactly two values.",
        call. = FALSE
      )
    }

    if (variance_bounds[1] >= variance_bounds[2]) {
      stop(
        "The lower variance bound must be smaller than the upper bound.",
        call. = FALSE
      )
    }
  }

  invisible(TRUE)
}
