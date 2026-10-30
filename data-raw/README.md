# Data

The files in `data-raw/` are the extracts used in Turra et al. (2023), kept as
they were used so that the results can be reproduced. Newer releases of the
same series may differ. Each file remains under the terms of
its original provider; please cite the original sources listed below.

The scripts read these files by their exact names from this folder, which must
stay flat (no subfolders). `SHA256SUMS` holds the checksum of every file
committed here; `shasum -a 256 -c SHA256SUMS` (or `sha256sum -c SHA256SUMS`)
confirms a copy is unchanged.

## Microdata

The vaccination records are not in this repository. Download
`opendatasus-br-vaccination-2022-03-14.csv.7z` (40.8 GB) from Zenodo,
[doi:10.5281/zenodo.7360803](https://doi.org/10.5281/zenodo.7360803), and
extract it into this folder, so that the script finds
`data-raw/opendatasus-br-vaccination-2022-03-14.csv` (about 190 GB):

```sh
7z x opendatasus-br-vaccination-2022-03-14.csv.7z -odata-raw
```

## Files and sources

| File | Content | Source | Terms |
|---|---|---|---|
| `opendatasus-br-vaccination-2022-03-14.csv.7z` (not in this repository) | COVID-19 vaccination records, 387,750,333 rows, approximately 190 GB uncompressed | Brasil (2021a), archived as Fernandes (2022) | CC BY 4.0 (archive) |
| `ibge-pop-source.csv` | Projected population by state, sex and five-year age group, 2020–2022 | IBGE (2018) | © IBGE; reproduction of IBGE data is permitted with IBGE cited as the source, not for commercial purposes |
| `ibge-lifetable-source.csv` | Life tables by state and sex, 2010, 2020 and 2021 | IBGE (2018) | © IBGE; reproduction of IBGE data is permitted with IBGE cited as the source, not for commercial purposes |
| `wpp-pop-source.csv` | Population by sex and five-year age group, Brazil, 1950–2100 | United Nations (2019) | [CC BY 3.0 IGO](https://creativecommons.org/licenses/by/3.0/igo/) |
| `wpp-life-table-source.csv` | Life table by sex, Brazil, 2020–2025 | United Nations (2019) | [CC BY 3.0 IGO](https://creativecommons.org/licenses/by/3.0/igo/) |
| `ipums-br-1960-2010-pop-80-plus.csv` | Population aged 80 and over by single year of age, sex and region, tabulated from the 1960, 1970, 1980, 1991, 2000 and 2010 census samples | Minnesota Population Center (2020); IBGE, censuses 1960–2010 | Tabulation published under the IPUMS International conditions of use; the microdata are not redistributed |
| `hmd-lt-source.csv` | Life expectancy by age from HMD life tables, Japan, Sweden and Switzerland, 1751–2019 | Human Mortality Database (2021) | CC BY 4.0 |
| `hmd-pop-swe.csv` | Population by sex and single year of age, Sweden, 1751–2019, from the HMD Input Database | Human Mortality Database (2021); see [Sweden population series](#sweden-population-series) | Terms of the original providers |
| `hmd-country-codes.csv` | HMD country names and codes | Human Mortality Database (2021) | CC BY 4.0 |
| `conass-excess-mortality-2020.csv`, `conass-excess-mortality-2021.csv`, `conass-overmortality-2020-2021.csv` | Excess deaths from natural causes by epidemiological week and region, and excess mortality by state and sex, 2020–2021 | CONASS (2021) | Published by CONASS; no reuse licence stated (the panel now requires a login) |
| `br-state-codes.csv` | Brazilian federative units: names, IBGE codes and regions | Lookup table | — |

The vaccination records were downloaded from openDataSUS on 14 March 2022, the
HMD files on 1 May 2021 and the CONASS panel on 16 June 2021.

## Sweden population series

`hmd-pop-swe.csv` comes from the HMD Input Database. As Turra et al. (2023) report, the data for
Sweden were drawn from the Human Mortality Database (2021); the analysis uses the
Swedish raw data for 1992–2019, population by sex and single year of age up to
110 and older. The file's `RefCode` column links each row to its original
source in the HMD reference list for Sweden.

## References

Brasil. 2021a. *Campanha Nacional de Vacinação contra Covid-19: Registros de
Vacinação COVID-19, Open Data*. Ministério da Saúde, Sistema de Informação do
Programa Nacional de Imunizações (SI-PNI). openDataSUS.
https://opendatasus.saude.gov.br/dataset/covid-19-vacinacao/ (accessed 14 March
2022, the extract `opendatasus-br-vaccination-2022-03-14.csv`).

Brasil. 2021b. *Plano Nacional de Operacionalização da Vacinação contra a
COVID-19*. 9th ed. Brasília, DF: Ministério da Saúde.

CONASS (Conselho Nacional de Secretários de Saúde). 2021. *Painel de Análise do
Excesso de Mortalidade por Causas Naturais no Brasil*.
https://www.conass.org.br/indicadores-de-obitos-por-causas-naturais/ (accessed 16 June 2021).

Fernandes, F. 2022. *Open microdata registers from the Brazilian COVID-19
vaccination campaign* [dataset], version 1.0.0. Zenodo.
https://doi.org/10.5281/zenodo.7360803.

*Human Mortality Database*. 2021. University of California, Berkeley (USA) and
Max Planck Institute for Demographic Research (Germany). www.mortality.org,
www.humanmortality.de (data downloaded on 1 May 2021).

IBGE. 2018. *Projeções da População: Brasil e Unidades da Federação, Revisão
2018*. 2nd ed. Série Relatórios Metodológicos, volume 40. Rio de Janeiro: IBGE,
Coordenação de População e Indicadores Sociais.

Minnesota Population Center. 2020. *Integrated Public Use Microdata Series,
International: Version 7.3* [dataset]. Minneapolis, MN: IPUMS.
https://doi.org/10.18128/D020.V7.3. Census microdata for Brazil (1960, 1970,
1980, 1991, 2000 and 2010) provided by the Instituto Brasileiro de Geografia e
Estatística (IBGE).

Turra, C. M., F. Fernandes, J. Almeida Calazans, and M. R. Nepomuceno. 2023.
"Age reporting for the oldest old in the Brazilian COVID-19 vaccination
database: What can we learn from it?" *Demographic Research* 48(28): 829–848.
https://doi.org/10.4054/DemRes.2023.48.28.

United Nations. 2019. *World Population Prospects 2019: Online Edition*. New
York: United Nations, Department of Economic and Social Affairs, Population
Division.
