* swaps - global path launcher
* Purpose: select project_root by user, load setup, then run full pipeline

set more off
version 19

* Global file path rule
if "`c(username)'" == "ag" {
    global project_root "."
}
else if "`c(username)'" == "culm" {
    global project_root "C:/Users/culm/Box/K01 Aim 3 - Swaps Study/Data/Clayton Work/swaps"
}
else {
    global project_root "."
}

capture noisily cd "$project_root"
if _rc {
    di as err "Could not enter project_root."
    exit 198
}

do "setup.do"

* Local project data roots (self-contained under swaps/).
if "$Data" == "" {
    global Data "$Repo/data"
}

if "$Data_share" == "" {
    global Data_share "$Repo/data/share"
}

if "$Results" == "" {
    global Results "$OutTables"
}

capture noisily cd "$Data_share/Output"
if _rc {
    di as err "Could not enter $Data_share/Output. Check local swaps/data/share path."
    exit 198
}
capture noisily cd "$project_root"

* Ensure required user-written commands are available.
foreach pkg in distinct mdesc qqvalue {
    capture which `pkg'
    if _rc {
        capture noisily ssc install `pkg', replace
        capture which `pkg'
        if _rc {
            di as err "Required command '`pkg'' is not installed."
            exit 198
        }
    }
}

* Run streamlined pipeline for manuscript-table outputs.
foreach step in ///
    "01_dataprep_master.do" ///
    "06_output_exports.do" {
    capture noisily do "$project_root/`step'"
    if _rc {
        di as err "`step' failed."
        exit _rc
    }
}

di as txt "Pipeline complete: 01 and 06 scripts executed."
