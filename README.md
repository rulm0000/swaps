# swaps

SWAPS replication pipeline for manuscript table exports.

## Run

1. Open Stata in `swaps/`.
2. Run `do "00_global_paths.do"`.

## Manuscript Table Outputs

- `output/tables/manuscript/table1_formatted.xlsx`
- `output/tables/manuscript/manuscript_table2_formatted.xlsx`
- `output/tables/manuscript/food_group_effects_formatted.xlsx`

## Pipeline Steps

- `00_global_paths.do`: entrypoint, sets paths, runs `01_dataprep_master.do` then `06_output_exports.do`.
- `06_output_exports.do`: orchestrates manuscript table scripts:
  - `02_descriptive_tables.do` (Table 1)
  - `03_main_analysis.do` (Table 2)
  - `05_sensitivity_exposure.do` (S5 food-group table)

## Notes

- Prepared analysis datasets are read from `data/share/Output/`.
- Figure source files are written to `output/figures/`.
