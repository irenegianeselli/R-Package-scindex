#' Example Binary Inter-Rater Dataset
#'
#' Simulated binary classification ratings from two raters across
#' eight items, including ground-truth labels.
#'
#' The dataset illustrates the computation of Cohen's kappa and
#' the Strategic Convergence Index (SCI).
#'
#' @format A data frame with 16 rows and 4 variables:
#' \describe{
#'   \item{item}{Item identifier.}
#'   \item{rater}{Rater identifier.}
#'   \item{rating}{Binary rating assigned by the rater.}
#'   \item{truth}{Ground-truth binary classification.}
#' }
#'
#' @usage data(scindex_example)
#'
#' @examples
#' data(scindex_example)
#'
#' fit <- scindex(
#'   data = scindex_example,
#'   item = item,
#'   rater = rater,
#'   rating = rating,
#'   truth = truth
#' )
#'
#' fit
#' summary(fit)
#'
#' @source Simulated example data.
"scindex_example"
