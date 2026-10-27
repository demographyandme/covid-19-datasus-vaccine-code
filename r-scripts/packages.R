# Install the R packages the two scripts use. Run once, before the scripts:
#   source("r-scripts/packages.R")
# CRAN versions are not pinned: no versions were recorded when the analysis was
# run, so this installs the current CRAN releases. DemoTools (GitHub only) is
# pinned to the commit that was current on its master branch when the microdata
# were extracted (2022-03-14): d1251fc, 2022-01-17, DemoTools 01.13.76. This is
# a reconstruction, not a record. The functions the analysis calls
# (check_heaping_myers, check_heaping_spoorenberg, check_heaping_bachi, in
# R/check_heaping.R) last changed on 2021-06-25, so they are the same at this
# commit as at any later one.

cran <- c(
  "bigreadr", "conflicted", "dtplyr", "ggrepel", "ggtext", "glue", "here",
  "janitor", "lubridate", "patchwork", "purrr", "ragg", "rio", "scales",
  "styler", "systemfonts", "tidyverse", "viridis", "vroom"
)
missing <- setdiff(cran, rownames(installed.packages()))
if (length(missing)) install.packages(missing)

# DemoTools is not on CRAN.
demotools_ref <- "d1251fce24298ad586e38698e18e1e3f4f635244"
if (!requireNamespace("DemoTools", quietly = TRUE)) {
  if (!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes")
  remotes::install_github("timriffe/DemoTools", ref = demotools_ref)
}
