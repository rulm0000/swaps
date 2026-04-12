# swaps

SWAPS replication pipeline for manuscript tables and figure source exports.

## Run

1. Open Stata in `swaps/`.
2. Run `do "00_global_paths.do"`.
3. The public GitHub entrypoint reruns exports from prepared files in `data/share/Output/`.
4. `01_dataprep_master.do` is left in the repo for private use but is skipped by default because it imports restricted/licensed product data that is not uploaded.

## Generated Deliverables

- `output/tables/manuscript/table1_participant_characteristics.xlsx`
- `output/tables/manuscript/table2_effects_of_swaps.xlsx`
- `output/tables/manuscript/s5_table_bh_corrected_pvalues.xlsx`
- `output/tables/manuscript/s6_table_effects_by_food_group.xlsx`
- `output/figures/manuscript/figure3_source_primary_means_se_by_visit.csv`
- `output/figures/manuscript/s1_figure_acceptability_of_online_store.csv`

## Submission Crosswalk

- `s5_table_bh_corrected_pvalues.xlsx` aligns to `K01Swaps_R1_S5 Table_BH corrected pvalues.docx`.
- `s6_table_effects_by_food_group.xlsx` aligns to `K01Swaps_R1_S6 Table_Effects by Food Group.docx`.
- `s1_figure_acceptability_of_online_store.csv` is the source export for `K01Swaps_R1_S1 Figure.docx`.
- `figure3_source_primary_means_se_by_visit.csv` is the source export for `Figure3.tif`.
- `table1_participant_characteristics.xlsx` and `table2_effects_of_swaps.xlsx` feed the main manuscript tables.

## Repo Directory

```text
swaps/
|-- 00_global_paths.do
|-- 01_dataprep_master.do
|-- 06_output_exports.do
|-- data/
|   `-- share/
|      `-- Output/
|         |-- dataset A_nutri and carbon.dta
|         |-- dataset B_psych data with demog_add-ons.dta
|         |-- dataset C_Visit3 other outcomes.dta
|         |-- dataset D_Visit1 demog polsup.dta
|         `-- Int dataset A_nutri and carbon_all rows.dta
|-- output/
|   |-- tables/
|   |   `-- manuscript/
|   |      |-- table1_participant_characteristics.xlsx
|   |      |-- table2_effects_of_swaps.xlsx
|   |      |-- s5_table_bh_corrected_pvalues.xlsx
|   |      `-- s6_table_effects_by_food_group.xlsx
|   `-- figures/
|      `-- manuscript/
|         |-- figure3_source_primary_means_se_by_visit.csv
|         `-- s1_figure_acceptability_of_online_store.csv
```

## Pipeline Steps

- `00_global_paths.do`: public entrypoint, sets paths, skips the private raw-data rebuild, and runs `06_output_exports.do` from `data/share/Output/`.
- `01_dataprep_master.do`: private raw-data rebuild that depends on restricted/licensed product data not included on GitHub.
- `06_output_exports.do`: orchestrates manuscript exports:
  - `02_descriptive_tables.do` (Table 1 and S1 figure source)
  - `03_main_analysis.do` (Table 2 and Figure 3 source)
  - `05_sensitivity_exposure.do` (S6 table)
  - `08_s5_bonferroni_holm_supplement.do` (S5 Bonferroni-Holm corrected p-values table)
- `07_ctgov_reporting_replication.do`: rebuilds the CT.gov reporting package in `output/tables/ctgov/` and also writes the uploaded-baseline validation outputs there using the validator stored in `../ClinicalTrials_data/`.

## Notes

- Prepared analysis datasets are read from `data/share/Output/`.
- The private product input under `data/Launch 2025/Product info/` is excluded from GitHub because it contains restricted/licensed product data.
- Figure source files are written to `output/figures/manuscript/`.
