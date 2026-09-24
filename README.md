# Age reporting in the Brazilian COVID-19 vaccination database: code and data

The R code and reference data behind:

> Turra, Cássio M., Fernando Fernandes, Júlia Almeida Calazans, and Marília R.
> Nepomuceno. 2023. "Age Reporting in the Brazilian COVID-19 Vaccination
> Database: What Can We Learn from It?" *Demographic Research* 48 (28): 829–848.
> [doi:10.4054/DemRes.2023.48.28](https://doi.org/10.4054/DemRes.2023.48.28)

The vaccination microdata are archived on Zenodo,
[doi:10.5281/zenodo.7360803](https://doi.org/10.5281/zenodo.7360803). The
companion page presents the study, its figures and data:
[demographyandme.github.io/covid-19-datasus-vaccine](https://demographyandme.github.io/covid-19-datasus-vaccine/).

## Repository

| Path | Content |
|---|---|
| `r-scripts/1-covid-19-datasus-vaccine.R` | Reads, cleans, tabulates and analyses the data |
| `r-scripts/2-covid-19-datasus-vaccine-plots.R` | Reproduces the figures |
| `r-scripts/packages.R` | Installs the R packages the scripts use |
| `data-raw/` | The reference data used in the paper, with their sources ([`data-raw/README.md`](data-raw/README.md)) |
| `data-treated/` | Intermediate files written by the first script (empty in the repository) |
| `output/` | The figures and tables the scripts produce |
| `scripts/tests/` | Checks run on every change to the repository |

The two scripts are the analysis code for the paper, as kept in the project's
repository; the additions here (`packages.R`, the tests) are separate files.

## Reproducing the results

1. Install R and the packages: `source("r-scripts/packages.R")`. Versions are
   not pinned; no versions were recorded when the analysis was run.
2. Download the microdata from Zenodo and extract it into `data-raw/`
   ([instructions](data-raw/README.md#microdata)).
3. Open `covid-19-vaccine.Rproj`, or start R in this folder, so that `here()`
   finds the project root.
4. Run `r-scripts/1-covid-19-datasus-vaccine.R`, then
   `r-scripts/2-covid-19-datasus-vaccine-plots.R`, **in the same R session**:
   the second script uses the objects the first one creates.

The first script writes its intermediate files to `data-treated/` and the
second writes the figures to `output/`. A full run needs about 240 GB of free
disk: 40.8 GB for the archive, about 190 GB for the extracted records and
8.7 GB for the intermediate files.

## Data

`data-raw/` holds the reference files exactly as they were used (IBGE, United
Nations, IPUMS International, Human Mortality Database, CONASS), with a
checksum for each. [`data-raw/README.md`](data-raw/README.md) documents every
file: its content, source, terms and full citation.

## Licences

- Code: [MIT](LICENSE.md).
- Figures in `output/`: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/),
  Cássio M. Turra, Fernando Fernandes, Júlia Almeida Calazans and Marília R.
  Nepomuceno.
- Data in `data-raw/`: each file remains under its provider's terms, listed in
  [`data-raw/README.md`](data-raw/README.md).

## Citation

Please cite the paper. To cite this repository, see [`CITATION.cff`](CITATION.cff)
(GitHub shows it under "Cite this repository"); to cite the microdata, use
[doi:10.5281/zenodo.7360803](https://doi.org/10.5281/zenodo.7360803).
