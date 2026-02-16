# swaps

Lightweight repository for SWAPS analysis code and outputs.

## Repository Map

```text
swaps/
|-- README.md
|-- .gitignore
|-- 00_global_paths.do           # project root rule + setup launcher
|-- setup.do                     # shared global definitions
|-- 01_dataprep_master.do        # dataprep entrypoint (scaffold)
|-- 02_descriptive_tables.do     # planned: descriptives/Table 1 outputs
|-- 03_main_analysis.do          # planned: co-primary/secondary models
|-- 04_moderation_analysis.do    # planned: moderator models
|-- 05_sensitivity_exposure.do   # planned: exposure/sensitivity analyses
|-- 06_output_exports.do         # planned: table/figure export
|-- data/
|   |-- raw/
|   |-- intermediate/
|   `-- derived/
`-- output/
    |-- tables/
    |-- figures/
    `-- logs/
```

## Workflow

1. Configure paths in `00_global_paths.do` and `setup.do`.
2. Put raw files in `data/raw/`.
3. Run `01_dataprep_master.do`.
4. Run analysis scripts (`02` to `06`) as needed.
5. Check outputs in `output/tables/` and `output/figures/`.
