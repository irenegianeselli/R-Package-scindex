#' Prepare Data for scindex
#'
#' Internal preprocessing utility for `scindex()`.
#'
#' The function:
#' - standardizes rating coding;
#' - orders items and raters consistently;
#' - creates an item-by-rater rating matrix;
#' - optionally attaches ground-truth labels.
#'
#' @param data A data frame.
#' @param item_col Character string identifying the item column.
#' @param rater_col Character string identifying the rater column.
#' @param rating_col Character string identifying the rating column.
#' @param truth_col Optional character string identifying the truth column.
#' @param positive Value representing the positive class.
#'
#' @return A list containing:
#' \describe{
#'   \item{long}{Standardized long-format data frame.}
#'   \item{wide_ratings}{Item-by-rater rating matrix.}
#'   \item{truth}{Optional truth vector.}
#' }
#'
#' @noRd
prepare_scindex_data <- function(data,
                                  item_col,
                                  rater_col,
                                  rating_col,
                                  truth_col = NULL,
                                  positive = 1) {

  dat <- data

  rating_values <- sort(unique(dat[[rating_col]]))

  negative <- setdiff(rating_values, positive)

  dat[[rating_col]] <- ifelse(
    dat[[rating_col]] == positive,
    1L,
    0L
  )

  if (!is.null(truth_col)) {

    dat[[truth_col]] <- ifelse(
      dat[[truth_col]] == positive,
      1L,
      0L
    )
  }

  dat <- dat[order(
    dat[[item_col]],
    dat[[rater_col]]
  ), ]

  item_ids <- unique(dat[[item_col]])
  rater_ids <- unique(dat[[rater_col]])

  wide <- matrix(
    NA_integer_,
    nrow = length(item_ids),
    ncol = length(rater_ids),
    dimnames = list(item_ids, rater_ids)
  )

  for (i in seq_len(nrow(dat))) {

    current_item <- dat[[item_col]][i]
    current_rater <- dat[[rater_col]][i]

    wide[
      as.character(current_item),
      as.character(current_rater)
    ] <- dat[[rating_col]][i]
  }

  truth_vector <- NULL

  if (!is.null(truth_col)) {

    truth_df <- dat[
      !duplicated(dat[[item_col]]),
      c(item_col, truth_col)
    ]

    truth_vector <- truth_df[[truth_col]]

    names(truth_vector) <- truth_df[[item_col]]
  }

  out <- list(
    long = dat,
    wide_ratings = wide,
    truth = truth_vector,
    positive = positive,
    negative = negative,
    item_ids = item_ids,
    rater_ids = rater_ids
  )

  out
}
