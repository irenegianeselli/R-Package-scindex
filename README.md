
# scindex

**Strategic Convergence Index for Inter-Rater Reliability**

`scindex` is an R package for analysing inter-rater reliability in binary classification tasks involving two or more raters.

The package combines classical agreement coefficients with signal detection theory (SDT) estimates of rater-specific decision criteria.

It computes Cohen's kappa for two raters and Fleiss' kappa for multiple raters. When reference classifications are available, it also estimates hit rates, false-alarm rates, sensitivity, specificity, decision thresholds, and the Strategic Convergence Index (SCI).

SCI is a model-based summary of convergence in raters' decision thresholds. It complements agreement coefficients by describing a property of the decision structure underlying observed classifications.

**Version:** 0.1.0  
**CRAN:** https://cran.r-project.org/package=scindex  
**R version:** 4.1.0 or later

## Installation

Install the released package from CRAN:

```r
install.packages("scindex")
library(scindex)
```

## Statistical framework

In binary rating tasks, agreement coefficients summarise concordance between observed classifications. Their values depend on the marginal response distributions and may change with case prevalence.

Within an SDT framework, each rater's binary classification is represented as a decision based on latent evidence and an individual decision threshold.

The distinction between these quantities is central to the package:

- Agreement concerns the correspondence between observed categorical responses.
- Threshold alignment concerns the dispersion of raters' estimated decision criteria.

When reference classifications are available, `scindex` estimates each rater's decision threshold from the corresponding hit rate and false-alarm rate.

The threshold estimate uses the inverse standard normal cumulative distribution function:

```text
threshold_i = -0.5 * (z(H_i) + z(F_i))
```

Here, `H_i` is the hit rate and `F_i` the false-alarm rate for rater `i`. The function `z()` denotes the inverse standard normal cumulative distribution function.

A log-linear correction is applied to avoid infinite transformed values when observed rates are zero or one.

Threshold estimates are expressed on the centred SDT criterion scale.

## Strategic Convergence Index

SCI summarises the dispersion of rater-specific decision thresholds relative to a reference variance:

```text
SCI = 1 - Var(thresholds) / Var_ref
```

Here:

- `Var(thresholds)` is the variance of estimated rater-specific decision thresholds.
- `Var_ref` is the reference variance used for normalisation.

SCI approaches one as estimated thresholds converge.

The index describes alignment in decision criteria under the specified SDT model. It is not an alternative chance-corrected agreement coefficient and does not directly measure diagnostic accuracy.

The reference variance can be specified through the `variance_bounds` argument. When this argument is omitted, the package derives the bounds from the estimated thresholds.

The choice of reference bounds is relevant to the numerical interpretation of SCI and should be documented when reporting results.

## Main function

The principal function is `scindex()`:

```r
scindex(
  data,
  item,
  rater,
  rating,
  truth = NULL,
  positive = 1,
  variance_bounds = NULL
)
```

The arguments are:

| Argument | Description |
|---|---|
| `data` | Data frame containing the ratings. |
| `item` | Column identifying the rated item or case. |
| `rater` | Column identifying the rater. |
| `rating` | Column containing the binary classification. |
| `truth` | Optional column containing reference classifications. |
| `positive` | Value identifying the positive class; defaults to 1. |
| `variance_bounds` | Optional lower and upper bounds used to define the reference variance for SCI. |

Column names are supplied without quotation marks.

The current version supports binary ratings.

## Example 1: Two raters

The package includes a simulated dataset containing binary classifications from two raters across eight items.

```r
library(scindex)

data(scindex_example)

fit <- scindex(
  data = scindex_example,
  item = item,
  rater = rater,
  rating = rating,
  truth = truth
)

print(fit)
summary(fit)
```

With two raters, the package computes Cohen's kappa.

Because the example includes reference classifications, the analysis also estimates SDT decision thresholds and SCI.

The fitted object provides the agreement coefficient, its type, threshold estimates, SCI, and associated diagnostic information.

## Example 2: Multiple raters

A second simulated dataset contains classifications from three raters.

```r
data(scindex_example_multi)

fit_multi <- scindex(
  data = scindex_example_multi,
  item = item,
  rater = rater,
  rating = rating,
  truth = truth
)

print(fit_multi)
summary(fit_multi)
```

When more than two raters are supplied, `scindex()` computes Fleiss' kappa.

Fleiss' kappa and the arithmetic mean of all pairwise Cohen's kappa coefficients are distinct statistics. The multi-rater coefficient returned by `scindex()` should not be described as mean pairwise Cohen's kappa.

When reference classifications are supplied, the package also estimates rater-specific SDT thresholds and SCI.

## Example 3: Agreement without reference classifications

Agreement can be calculated when reference classifications are unavailable.

```r
fit_agreement <- scindex(
  data = scindex_example,
  item = item,
  rater = rater,
  rating = rating
)

print(fit_agreement)
summary(fit_agreement)
```

In this case, the agreement coefficient can be calculated from the observed ratings.

SDT threshold estimation and SCI require reference classifications and are not computed when the `truth` argument is omitted.

## Example 4: Specifying reference bounds

The reference interval for SCI can be supplied explicitly through `variance_bounds`.

```r
fit_bounds <- scindex(
  data = scindex_example_multi,
  item = item,
  rater = rater,
  rating = rating,
  truth = truth,
  variance_bounds = c(-4, 5)
)

print(fit_bounds)
summary(fit_bounds)
```

The interval from -4 to 5 defines a uniform-reference variance:

```text
Var_ref = (5 - (-4))^2 / 12 = 6.75
```

This reference variance is a normalisation constant. It is not the mathematical maximum variance attainable by a bounded variable on that interval.

For studies comparing SCI values across panels or conditions, the reference specification should be kept fixed when the intended interpretation requires a common scale.

## Data requirements

`scindex` expects ratings in long format, with one row for each item–rater combination.

The required information includes:

- An item identifier.
- A rater identifier.
- A binary rating.

Reference classifications are optional for agreement analysis but required for SDT threshold estimation and SCI.

When reference classifications are supplied, they identify the true class of each item and must be compatible with the binary rating structure.

The package standardises the supplied data and returns structured summaries of the available estimates.

## Interpretation and limitations

The statistical interpretation of the results depends on the distinction between agreement and threshold alignment.

**Agreement coefficients**

Cohen's kappa and Fleiss' kappa quantify categorical agreement under their respective definitions. They do not directly establish the accuracy of classifications or the similarity of raters' decision thresholds.

**SDT threshold estimates**

Estimated thresholds depend on the SDT representation of binary classifications and the availability of reference labels.

The transformations used by the package provide centred decision criteria. Their interpretation depends on the assumed evidence scale and model specification.

**SCI**

SCI quantifies convergence in estimated decision thresholds relative to a reference variance.

A high SCI value indicates limited dispersion among the estimated thresholds under the adopted model and normalisation. It does not establish that the raters are accurate or that their classifications are valid.

**Reference classifications**

Without reference classifications, the package does not estimate the SDT thresholds required to calculate SCI.

Inference about decision criteria without known reference labels requires additional assumptions and an assessment of identifiability.

**Scope**

The package is intended for binary inter-rater classification tasks. The available functions do not constitute a general latent-class estimation procedure, a hierarchical SDT model, or a prospective prediction system for future raters.

## Reproducibility

Analyses should report the package version, the number of raters, the definition of the positive class, the availability of reference classifications, and the reference bounds used for SCI.

```r
packageVersion("scindex")
sessionInfo()
```

The interpretation of a reported kappa coefficient should specify whether it is Cohen's kappa or Fleiss' kappa.

When reporting SCI, the method used to estimate thresholds and the reference variance should also be stated.

## Documentation

Function-level documentation is available in R:

```r
help("scindex", package = "scindex")
help("scindex_example", package = "scindex")
help("scindex_example_multi", package = "scindex")
help("summary.scindex_fit", package = "scindex")
```

The package reference manual is available on [CRAN](https://cran.r-project.org/package=scindex).

## Citation

Gianeselli, I. (2026). A tool for agreement and alignment analysis in binary rating tasks: The R package scindex. *Applied Psychological Measurement*. https://doi.org/10.1177/01466216261465629

## Theoretical background

Gianeselli, I. (2026). From agreement to epistemic alignment: A signal detection–theoretic model of inter-rater reliability. *Educational and Psychological Measurement, 86*(5), 883–908. https://doi.org/10.1177/00131644261417643

Gianeselli, I. (2026). Agreement and alignment in binary rating tasks: Strategic convergence as an equilibrium outcome. *Educational and Psychological Measurement*. https://doi.org/10.1177/00131644261455307

## Author

Irene Gianeselli.

**Maintainer:** Irene Gianeselli.

## Licence

GPL-3.
