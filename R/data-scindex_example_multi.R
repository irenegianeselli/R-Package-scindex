#' Example Binary Inter-Rater Dataset with Multiple Raters
#'
#' Simulated binary classification ratings from three raters
#' across eight items, including ground-truth labels.
#'
#' The dataset illustrates the computation of Fleiss' kappa and
#' the Strategic Convergence Index (SCI) in a multi-rater setting.
#'
#' @format A data frame with 24 rows and 4 variables:
#' \describe{
#'   \item{item}{Item identifier.}
#'   \item{rater}{Rater identifier.}
#'   \item{rating}{Binary rating assigned by the rater.}
#'   \item{truth}{Ground-truth binary classification.}
#' }
#'
#' @usage data(scindex_example_multi)
#'
#' @examples
#' data(scindex_example_multi)
#'
#' fit <- scindex(
#'   data = scindex_example_multi,
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
"scindex_example_multi"
