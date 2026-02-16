# swaps

Planning-first scaffold for the SWAPS analyses. This repository is intentionally initialized without migrated analysis code. It defines structure, data contracts, and execution order before implementation.

## Scope

- Start fresh in this repo and do not port legacy analysis scripts except logic that may later be borrowed from:
  - `K01-Aim3-Swaps/0_GlobalPaths.do`
  - `K01-Aim3-Swaps/Analysis/Data prep.do`
- Analysis specification source:
  - `Writing/PLOSMedicine/Revision1/Combined Protocol - IRB and Statistical Analysis Plan.pdf`
  - Methods/Statistical Analysis text from `K01Swaps_R1_main_v3.docx`

## Repository Map (Text)

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
|-- 06_output_exports.do         # planned: table/figure export step
|-- data/
|   |-- raw/                     # never commit real participant data
|   |-- intermediate/            # transient build products
|   `-- derived/                 # analysis-ready datasets
`-- output/
    |-- tables/
    |-- figures/
    `-- logs/
```

## Analysis Spec Checklist

- Trial design: randomized parallel-group, 3 visits, 4 arms (control, health swaps, climate swaps, combined).
- Main estimands: intervention effects on co-primary outcomes vs control, with between-arm contrasts.
- Co-primary outcomes:
  - Healthfulness of selections (Ofcom-based score)
  - Carbon footprint of selections (CO2-eq/kg)
- Secondary outcomes:
  - Selection outcomes: kcal, sugar, sodium, saturated fat, fiber, protein density, total spending
  - Psychological outcomes: health/climate/taste elaboration, affect, injunctive/descriptive norms
- Other outcomes: acceptability/helpfulness/liking outcomes (descriptive).
- Statistical approach:
  - Intent-to-treat
  - Linear mixed models with participant random intercept
  - Difference-in-differences framing using baseline vs intervention visits
  - Pooled intervention-period effects (weighted across visits 2 and 3) and visit-specific/exposure contrasts
- Planned moderator analyses: age group, health consciousness, environmental consciousness.

## Data Contract (Initial)

Expected raw sources (naming based on legacy `Data prep.do` conventions):

- Pre-store Qualtrics exports (Full Launch + Mini Launch)
- Post-store Qualtrics exports (Full Launch + Mini Launch)
- Product dataset CSV
- Store purchase datasets by visit

Planned storage conventions in this repo:

- `data/raw/` for immutable source drops
- `data/intermediate/` for temporary transformed files
- `data/derived/` for analysis-ready datasets (`A/B/C/D` style outputs)
- `output/tables/` and `output/figures/` for manuscript-facing outputs
- `output/logs/` for script logs and run metadata

## Codebook And Variable Definitions

Primary variable-definition source for implementation: embedded recodes and comments in legacy `Analysis/Data prep.do`.

Variable-definition provenance tags to use while implementing:

- `defined_in_data_prep`: clear mapping defined in legacy data prep logic
- `from_raw_export`: taken directly from survey/store exports
- `needs_external_codebook`: unresolved definitions requiring external codebook or instrument docs

Known unresolved/codebook follow-up items:

- Locate/confirm `Analysis/Data cleaning steps.docx` referenced in legacy code
- Confirm exact instrument-level definitions for some psychological and policy-support variables
- Confirm source documentation for product-level climate and nutrition derivations

## Planned Pipeline (Not Yet Executed)

1. `00_global_paths.do` + `setup.do`: user-local path configuration and runtime checks.
2. `01_dataprep_master.do`: import/clean raw files; build canonical derived datasets.
3. `02_descriptive_tables.do`: baseline characteristics and descriptive outputs.
4. `03_main_analysis.do`: co-primary and secondary model estimation.
5. `04_moderation_analysis.do`: pre-specified moderation models.
6. `05_sensitivity_exposure.do`: first-vs-second exposure contrasts.
7. `06_output_exports.do`: publish-ready tables/figures.

## Branch Workflow

- `main`: stable branch for reviewed changes.
- Feature branches from `main` (example: `feat/repo-scaffold`, `feat/dataprep-v1`).
- Open PRs into `main` with explicit test/run notes.
- Keep commits scoped to one pipeline stage where possible.

## Data Safety Rules

- Do not commit participant-level raw data.
- Keep secrets/credentials out of repo.
- Keep code reproducible by separating environment-specific paths into `00_global_paths.do` and `setup.do`.
