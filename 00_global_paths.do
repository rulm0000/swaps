* swaps - global path launcher

version 19
set more off

* Global file path rule
if "`c(username)'" == "ag" {
    global project_root "/Users/ag/Documents/GitHub/swaps"
}
else if "`c(username)'" == "culm" {
    global project_root "."
}
else {
    global project_root "."
}

capture noisily cd "$project_root"
if _rc {
    di as err "Could not enter project_root."
    exit 198
}

global project_root "`c(pwd)'"

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

foreach f in ///
    "dataset A_nutri and carbon.dta" ///
    "dataset B_psych data with demog_add-ons.dta" ///
    "dataset C_Visit3 other outcomes.dta" ///
    "dataset D_Visit1 demog polsup.dta" ///
    "Int dataset A_nutri and carbon_all rows.dta" {
    capture confirm file "$Data_share/Output/`f'"
    if _rc {
        di as err "Missing prepared analysis dataset: $Data_share/Output/`f'"
        exit 601
    }
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

foreach step in "06_output_exports.do" {
    capture noisily do "$project_root/`step'"
    if _rc {
        di as err "`step' failed."
        exit _rc
    }
}

di as txt "Pipeline complete: 06 script executed using prepared data/share/Output inputs."
