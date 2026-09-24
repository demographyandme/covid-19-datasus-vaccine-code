# Install the R packages the two scripts use. Run once, before the scripts:
#   source("r-scripts/packages.R")
# Versions are not pinned: no versions were recorded when the analysis was run,
# so this installs the current releases.

cran <- c(
  "bigreadr", "conflicted", "dtplyr", "ggrepel", "ggtext", "glue", "here",
  "janitor", "lubridate", "patchwork", "purrr", "ragg", "rio", "scales",
  "styler", "systemfonts", "tidyverse", "viridis", "vroom"
)
missing <- setdiff(cran, rownames(installed.packages()))
if (length(missing)) install.packages(missing)

# DemoTools is not on CRAN.
if (!requireNamespace("DemoTools", quietly = TRUE)) {
  if (!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes")
  remotes::install_github("timriffe/DemoTools")
}
