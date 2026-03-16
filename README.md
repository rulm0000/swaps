# swaps

SWAPS replication pipeline for manuscript tables and figure source exports.

## Run

1. Open Stata in `swaps/`.
2. Run `do "00_global_paths.do"`.

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
|-- 06_output_exports.do
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

- `00_global_paths.do`: entrypoint, sets paths, runs `01_dataprep_master.do` then `06_output_exports.do`.
- `06_output_exports.do`: orchestrates manuscript exports:
  - `02_descriptive_tables.do` (Table 1 and S1 figure source)
  - `03_main_analysis.do` (Table 2 and Figure 3 source)
  - `05_sensitivity_exposure.do` (S6 table)
  - `08_s5_bonferroni_holm_supplement.do` (S5 Bonferroni-Holm corrected p-values table)

## Notes

- Prepared analysis datasets are read from `data/share/Output/`.
- Figure source files are written to `output/figures/manuscript/`.
