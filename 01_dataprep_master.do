* swaps - dataprep master scaffold
* Planning scaffold only. No analysis migration implemented yet.

clear all
set more off
version 19

* Load repo globals.
do "00_global_paths.do"

* ---- Planned dataprep stages ----
* 1) Validate expected files in $DataRaw
* 2) Import pre-store and post-store survey exports
* 3) Import store purchase exports by visit
* 4) Import product metadata (nutrition + carbon)
* 5) Build derived analysis datasets (A/B/C/D)
* 6) Save outputs to $DataDeriv

di as txt "Dataprep scaffold loaded. Implementation pending."
