# Data

The files in `data-raw/` are the extracts used in <!-- cite @Turra2023 -->Turra et al. (2023)<!-- /cite -->, kept as
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
| `opendatasus-br-vaccination-2022-03-14.csv.7z` (not in this repository) | COVID-19 vaccination records, 387,750,333 rows, approximately 190 GB uncompressed | <!-- cite @Brasil2021b -->Brasil (2021a)<!-- /cite -->, archived as <!-- cite @Fernandes2022 -->Fernandes (2022)<!-- /cite --> | CC BY 4.0 (archive) |
| `ibge-pop-source.csv` | Projected population by state, sex and five-year age group, 2020–2022 | <!-- cite @IBGE2018 -->IBGE (2018)<!-- /cite --> | © IBGE; reproduction of IBGE data is permitted with IBGE cited as the source, not for commercial purposes |
| `ibge-lifetable-source.csv` | Life tables by state and sex, 2010, 2020 and 2021 | <!-- cite @IBGE2018 -->IBGE (2018)<!-- /cite --> | © IBGE; reproduction of IBGE data is permitted with IBGE cited as the source, not for commercial purposes |
| `wpp-pop-source.csv` | Population by sex and five-year age group, Brazil, 1950–2100 | <!-- cite @UnitedNations2019c -->United Nations (2019)<!-- /cite --> | [CC BY 3.0 IGO](https://creativecommons.org/licenses/by/3.0/igo/) |
| `wpp-life-table-source.csv` | Life table by sex, Brazil, 2020–2025 | <!-- cite @UnitedNations2019c -->United Nations (2019)<!-- /cite --> | [CC BY 3.0 IGO](https://creativecommons.org/licenses/by/3.0/igo/) |
| `ipums-br-1960-2010-pop-80-plus.csv` | Population aged 80 and over by single year of age, sex and region, tabulated from the 1960, 1970, 1980, 1991, 2000 and 2010 census samples | <!-- cite @IPUMS-I2020 -->Minnesota Population Center (2020)<!-- /cite -->; IBGE, censuses 1960–2010 | Tabulation published under the IPUMS International conditions of use; the microdata are not redistributed |
| `hmd-lt-source.csv` | Life expectancy by age from HMD life tables, Japan, Sweden and Switzerland, 1751–2019 | <!-- cite @HMD2021 -->Human Mortality Database (2021)<!-- /cite --> | CC BY 4.0 |
| `hmd-pop-swe.csv` | Population by sex and single year of age, Sweden, 1751–2019, from the HMD Input Database | <!-- cite @HMD2021 -->Human Mortality Database (2021)<!-- /cite -->; see [Sweden population series](#sweden-population-series) | Terms of the original providers |
| `hmd-country-codes.csv` | HMD country names and codes | <!-- cite @HMD2021 -->Human Mortality Database (2021)<!-- /cite --> | CC BY 4.0 |
| `conass-excess-mortality-2020.csv`, `conass-excess-mortality-2021.csv`, `conass-overmortality-2020-2021.csv` | Excess deaths from natural causes by epidemiological week and region, and excess mortality by state and sex, 2020–2021 | <!-- cite @CONASS2021 -->CONASS (Conselho Nacional de Secretários de Saúde) (2021)<!-- /cite --> | Published by CONASS; no reuse licence stated (the panel now requires a login) |
| `br-state-codes.csv` | Brazilian federative units: names, IBGE codes and regions | Lookup table | — |

The vaccination records were downloaded from openDataSUS on 14 March 2022, the
HMD files on 1 May 2021 and the CONASS panel on 16 June 2021.

## Sweden population series

`hmd-pop-swe.csv` comes from the HMD Input Database. As <!-- cite @Turra2023 -->Turra et al. (2023)<!-- /cite --> report, the data for
Sweden were drawn from the <!-- cite @HMD2021 -->Human Mortality Database (2021)<!-- /cite -->; the analysis uses the
Swedish raw data for 1992–2019, population by sex and single year of age up to
110 and older. The file's `RefCode` column links each row to its original
source in the HMD reference list for Sweden.

## References

<!-- references Brasil2021c -->

Brasil. 2021a. “Campanha Nacional de Vacinação contra Covid-19 - Registros de Vacinação COVID-19 - Open Data.” Portal de Dados Abertos do SUS. <https://dadosabertos.saude.gov.br/dataset/covid-19-vacinacao>.

Brasil. 2021b. *Plano nacional de operacionalização da vacinação contra a COVID-19*. 9th ed. Brasília, DF.

CONASS (Conselho Nacional de Secretários de Saúde). 2021. “Painel de análise do excesso de mortalidade por causas naturais no Brasil.” <https://www.conass.org.br/indicadores-de-obitos-por-causas-naturais/>.

Fernandes, Fernando. 2022. “Open microdata registers from the Brazilian COVID-19 vaccination campaign.” Version 1.0.0. Zenodo, March 14. <https://doi.org/10.5281/ZENODO.7360803>.

Human Mortality Database. 2021. *HMD*. University of California, Berkeley (USA) and Max Planck Institute for Demographic Research (Germany). <https://www.mortality.org>.

IBGE. 2018. *Projeções da população: Brasil e unidades da federação - revisão 2018*. 2nd ed. Série relatórios metodológicos, volume 40. IBGE, Coordenação de População e Indicadores Sociais. <https://www.ibge.gov.br/estatisticas/sociais/populacao/9109-projecao-da-populacao.html?=&t=resultados>.

Minnesota Population Center. 2020. “Integrated Public Use Microdata Series, International: Version 7.3.” Minneapolis, MN: IPUMS. <https://doi.org/10.18128/D020.V7.3>.

Turra, Cássio M., Fernando Fernandes, Júlia Almeida Calazans, and Marília R. Nepomuceno. 2023. “Age Reporting for the Oldest Old in the Brazilian COVID-19 Vaccination Database: What Can We Learn from It?” *Demographic Research* 48 (28): 829–48. <https://doi.org/10.4054/DemRes.2023.48.28>.

United Nations. 2019. *World Population Prospects 2019: Online Edition*. United Nations, Department of Economic and Social Affairs, Population Division.

<!-- /references -->
