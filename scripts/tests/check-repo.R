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
    # The paper's registered Crossref record (committed snapshot, also read
    # by demographyandme.com's bibliography gate): the citation must match it.
    reg <- yaml::yaml.load(read_text("scripts/tests/crossref-10.4054_demres.2023.48.28.json"))
    if (!is.null(cff)) {
      if (!identical(tolower(pc$doi), reg[["doi"]])) fail("citation: preferred-citation doi is %s, not the paper's", format(pc$doi))
      if (!identical(pc$title, reg[["title"]])) {
        fail("citation: preferred-citation title is not the registered title '%s'", reg[["title"]])
      }
      cff_names <- vapply(pc$authors, function(a) paste(a$`given-names`, a$`family-names`), "")
      reg_names <- vapply(reg[["authors"]], function(a) paste(a$given, a$family), "")
      cff_families <- vapply(pc$authors, function(a) a$`family-names`, "")
      reg_families <- vapply(reg[["authors"]], function(a) a$family, "")
      if (!identical(cff_names, reg_names) || !identical(cff_families, reg_families)) {
        fail("citation: preferred-citation authors (%s) are not the registered byline (%s)",
             paste(cff_names, collapse = "; "), paste(reg_names, collapse = "; "))
      }
      pages <- strsplit(reg[["page"]], "-", fixed = TRUE)[[1]]
      if (!identical(as.character(c(pc$volume, pc$start, pc$end, pc$year)),
                     c(reg[["volume"]], pages, substr(reg[["issued"]], 1, 4)))) {
        fail("citation: preferred-citation volume, pages or year differ from the registered record")
      }
      if (!is.null(pc[["issue"]]) && is.null(reg[["issue"]])) {
        fail("citation: preferred-citation has an issue, but %s is an article number, not an issue", format(pc[["issue"]]))
      }
    }
  }
  if (length(failures) == n_before) ok("citation: CITATION.cff parses and cites the published paper")

  # 3f. DemoTools (GitHub only) installs from a fixed commit, not the moving master branch
  n_before <- length(failures)
  pkgs <- read_text("r-scripts/packages.R")
  if (!grepl('demotools_ref <- "[0-9a-f]{40}"', pkgs)) fail("packages: DemoTools is not pinned to a full commit SHA in r-scripts/packages.R")
  gh_calls <- regmatches(pkgs, gregexpr("install_github\\([^)]*\\)", pkgs))[[1]]
  if (!length(gh_calls) || !all(grepl("ref = demotools_ref", gh_calls, fixed = TRUE))) {
    fail("packages: an install_github() call in r-scripts/packages.R has no pinned ref")
  }
  if (length(failures) == n_before) ok("packages: DemoTools installs from a pinned commit")

  failures <- unique(failures)
  if (length(failures)) {
    cat(paste0("FAIL ", failures, collapse = "\n"), "\n")
    quit(status = 1)
  }
}

main()
