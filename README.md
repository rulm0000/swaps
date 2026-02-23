# swaps

Self-contained SWAPS analysis pipeline (data prep -> analysis -> exports).

## Repository Map

```text
swaps/
|-- README.md
|-- .gitignore
|-- 00_global_paths.do                 # main entrypoint; runs 01-06
|-- setup.do                           # shared globals
|-- 01_dataprep_master.do              # builds prepared datasets
|-- 02_descriptive_tables.do           # participant flow + baseline outputs
|-- 03_main_analysis.do                # primary/secondary models + figure sources
|-- 04_moderation_analysis.do          # moderation models
|-- 05_sensitivity_exposure.do         # exposure/sensitivity analyses
|-- 06_output_exports.do               # exports + reconciliation outputs
|-- 07_ctgov_reporting_replication.do  # legacy standalone script
|-- data/
|   |-- Input/
|   |   |-- Full Launch/
|   |   `-- MiniLaunch/
|   |-- Launch 2025/
|   `-- share/
|       `-- Output/                    # generated .dta files used by 02-06
`-- output/
    |-- tables/
    |-- figures/
    `-- logs/
```

## Run

1. Open Stata in `swaps/`.
2. Run `do "00_global_paths.do"`.
3. Check outputs in `output/tables/`, `output/figures/`, and `data/share/Output/`.

## Globals (Path Rules)

- `00_global_paths.do` sets `project_root`, calls `setup.do`, then runs `01` -> `06`.
- `setup.do` defines output globals (`OutTables`, `OutFigures`, `OutLogs`) from `Repo`.
- `00_global_paths.do` defines local data globals:
  - `Data = $Repo/data`
  - `Data_share = $Repo/data/share`
- Scripts `02`-`06` read prepared data from `CTData = $Data_share/Output`.
