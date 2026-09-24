#!/usr/bin/env Rscript
# Repository checks that need R; run by scripts/tests/run-all.sh from the repo root.
# Base R plus the yaml package (for CITATION.cff).

main <- function() {
  failures <- character()
  fail <- function(...) failures <<- c(failures, sprintf(...))
  ok <- function(...) cat("ok   ", sprintf(...), "\n", sep = "")
  read_text <- function(path) paste(readLines(path, warn = FALSE, encoding = "UTF-8"), collapse = "\n")

  committed <- system2("git", c("ls-files"), stdout = TRUE)
  microdata <- "opendatasus-br-vaccination-2022-03-14.csv"
  scripts <- c("r-scripts/1-covid-19-datasus-vaccine.R", "r-scripts/2-covid-19-datasus-vaccine-plots.R")

  # 3a. the scripts parse
  for (s in scripts) {
    res <- tryCatch({ parse(s); NULL }, error = function(e) conditionMessage(e))
    if (!is.null(res)) fail("parse: %s does not parse: %s", s, res)
  }
  if (!length(failures)) ok("parse: both analysis scripts parse")

  # 3b. the path contract: every here() path the scripts use exists in a fresh clone
  n_before <- length(failures)
  code <- paste(vapply(scripts, read_text, ""), collapse = "\n")
  calls <- regmatches(code, gregexpr('here\\(\\s*"[^"]+"(\\s*,\\s*"[^"]+")?\\s*\\)', code))[[1]]
  parts <- lapply(calls, function(x) regmatches(x, gregexpr('"[^"]+"', x))[[1]] |> gsub(pattern = '"', replacement = ""))
  for (p in parts) {
    dir <- p[1]
    if (!dir %in% c("data-raw", "data-treated", "output")) { fail("paths: unexpected folder in here(%s)", paste(p, collapse = ", ")); next }
    if (!dir.exists(dir)) fail("paths: folder %s/ is missing (the scripts write or read there)", dir)
    if (dir == "data-raw" && length(p) == 2 && p[2] != microdata && !paste0("data-raw/", p[2]) %in% committed) {
      fail("paths: data-raw/%s is read by the scripts but not committed", p[2])
    }
  }
  if (any(grepl("^data-raw/[^/]+/", committed))) fail("paths: data-raw/ has a subfolder; the scripts read it flat")
  if (!"data-treated/.gitkeep" %in% committed) fail("paths: data-treated/.gitkeep is not committed, so a fresh clone lacks the folder")
  if (length(failures) == n_before) ok("paths: all %d here() paths resolve; data-raw/ is flat; data-treated/ and output/ exist", length(parts))

  # 3c. every committed data file is documented, and every documented file exists
  n_before <- length(failures)
  readme <- read_text("data-raw/README.md")
  data_files <- sub("^data-raw/", "", grep("^data-raw/", committed, value = TRUE))
  data_files <- setdiff(data_files, c("README.md", "SHA256SUMS"))
  table_rows <- regmatches(readme, gregexpr("(?m)^\\| `[^|]+\\|", readme, perl = TRUE))[[1]]
  documented <- unique(unlist(regmatches(table_rows, gregexpr("`[^`]+\\.(csv|7z)`", table_rows))))
  documented <- gsub("`", "", documented)
  for (f in setdiff(data_files, documented)) fail("docs: data-raw/%s has no row in data-raw/README.md", f)
  for (f in setdiff(documented, c(data_files, paste0(microdata, ".7z")))) fail("docs: data-raw/README.md documents %s, which is not committed", f)
  if (length(failures) == n_before) ok("docs: all %d data files documented in data-raw/README.md", length(data_files))

  # 3d. every HMD reference code in the Sweden file has a source, and no extra code is listed
  n_before <- length(failures)
  swe <- utils::read.csv("data-raw/hmd-pop-swe.csv", fileEncoding = "UTF-8-BOM", colClasses = "character")
  in_file <- sort(unique(as.integer(swe$RefCode)))
  sweden <- sub("(?s).*## Original sources of the Sweden population series(.*?)## References.*", "\\1", readme, perl = TRUE)
  first_cells <- sub("^\\| ([^|]+) \\|.*", "\\1", regmatches(sweden, gregexpr("(?m)^\\| [0-9][^|]*\\|", sweden, perl = TRUE))[[1]])
  # ranges such as "32–38" use an en dash; replace it byte-wise so this works in any locale
  first_cells <- gsub("–", "-", first_cells, fixed = TRUE, useBytes = TRUE)
  codes <- unlist(lapply(strsplit(first_cells, ",\\s*"), function(tokens) unlist(lapply(tokens, function(t) {
    r <- as.integer(strsplit(trimws(t), "-", fixed = TRUE)[[1]])
    if (length(r) == 2) seq(r[1], r[2]) else r
  }))))
  listed <- sort(unique(codes))
  for (c in setdiff(in_file, listed)) fail("sweden: RefCode %d is in hmd-pop-swe.csv but has no source in data-raw/README.md", c)
  for (c in setdiff(listed, in_file)) fail("sweden: data-raw/README.md lists RefCode %d, which hmd-pop-swe.csv does not use", c)
  if (length(failures) == n_before) ok("sweden: all %d reference codes of hmd-pop-swe.csv have a source", length(in_file))

  # 3e. CITATION.cff parses and cites the paper
  n_before <- length(failures)
  if (!requireNamespace("yaml", quietly = TRUE)) {
    fail("citation: the yaml package is required to read CITATION.cff")
  } else {
    # read as UTF-8 explicitly: yaml::read_yaml() fails on non-ASCII names under a C locale
    cff <- tryCatch(yaml::yaml.load(read_text("CITATION.cff")), error = function(e) { fail("citation: CITATION.cff does not parse: %s", conditionMessage(e)); NULL })
    pc <- cff$`preferred-citation`
    if (!is.null(cff)) {
      if (!identical(pc$doi, "10.4054/DemRes.2023.48.28")) fail("citation: preferred-citation doi is %s, not the paper's", format(pc$doi))
      if (!identical(pc$title, "Age Reporting in the Brazilian COVID-19 Vaccination Database: What Can We Learn from It?")) {
        fail("citation: preferred-citation title is not the published title")
      }
    }
  }
  if (length(failures) == n_before) ok("citation: CITATION.cff parses and cites the published paper")

  failures <- unique(failures)
  if (length(failures)) {
    cat(paste0("FAIL ", failures, collapse = "\n"), "\n")
    quit(status = 1)
  }
}

main()
