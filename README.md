# swaps

SWAPS replication pipeline for manuscript tables and figure source exports.

## Run

1. Open Stata in `swaps/` (working directory must be the repo root when `project_root` is `"."`).
2. Run `do "00_global_paths.do"`.
3. The public GitHub entrypoint reruns exports from prepared files in `data/share/Output/`.
4. `01_dataprep_master.do` is left in the repo for private use but is skipped by default because it imports restricted/licensed product data that is not uploaded.

## Public Data

The public repo includes cleaned/merged participant-level analysis datasets in `data/share/Output/`. These files include survey responses, participant store selections, and Green Choice-derived variables only for products selected by participants.

The full Green Choice product catalog is not included. Raw survey exports, raw store purchase exports, and the restricted product input used to build `product data-kcal100.dta` are also excluded from the public repo. The public analysis begins from the prepared `.dta` files listed below.

## Generated Deliverables

- `output/tables/manuscript/table1_participant_characteristics.xlsx`
- `output/tables/manuscript/table2_effects_of_swaps.xlsx`
- `output/tables/manuscript/primary_moderation_joint_tests.csv`
- `output/tables/manuscript/primary_moderation_effects_long.csv`
- `output/tables/manuscript/primary_moderation_table_formatted.csv`
- `output/tables/manuscript/primary_moderation_table_formatted.xlsx`
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
|   |      |-- primary_moderation_joint_tests.csv
|   |      |-- primary_moderation_effects_long.csv
|   |      |-- primary_moderation_table_formatted.csv
|   |      |-- primary_moderation_table_formatted.xlsx
|   |      |-- s5_table_bh_corrected_pvalues.xlsx
|   |      `-- s6_table_effects_by_food_group.xlsx
|   `-- figures/
|      `-- manuscript/
|         |-- figure3_source_primary_means_se_by_visit.csv
|         `-- s1_figure_acceptability_of_online_store.csv
```

## Pipeline Steps

- `00_global_paths.do`: public entrypoint, sets paths, skips the private raw-data rebuild, and runs `06_output_exports.do` from `data/share/Output/`.
- `01_dataprep_master.do`: private provenance/raw-data rebuild retained for project maintainers; it depends on restricted raw survey, store, and Green Choice product inputs that are not included on GitHub.
- `06_output_exports.do`: orchestrates manuscript exports:
  - `02_descriptive_tables.do` (Table 1 and S1 figure source)
  - `03_main_analysis.do` (Table 2 and Figure 3 source)
  - `04_moderation_analysis.do` (primary-outcome moderation tables and CSV/XLSX exports)
  - `05_sensitivity_exposure.do` (S6 table)
  - `08_s5_bonferroni_holm_supplement.do` (S5 Bonferroni-Holm corrected p-values table)
- `07_ctgov_reporting_replication.do`: standalone; rebuilds the CT.gov reporting package under `output/tables/ctgov/` and runs the uploaded-baseline validator from `../ClinicalTrials_data/`. CT.gov outputs are not tracked on GitHub by default (see `.gitignore`).

## Notes

- Prepared analysis datasets are read from `data/share/Output/`.
- Raw inputs under `data/Input/` and `data/Launch 2025/` are excluded from GitHub.
- The private product input under `data/Launch 2025/Product info/` is excluded because it contains the full restricted/licensed Green Choice product data.
- Figure source files are written to `output/figures/manuscript/`.
- Files produced in `output/tables/ctgov/` by `07_ctgov_reporting_replication.do` are gitignored unless you add explicit exceptions.
