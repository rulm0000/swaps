version 19
set more off
if "$project_root" == "" {
    do "00_global_paths.do"
}

global CTData "$Data_share/Output"

global ManuscriptTables "$OutTables/manuscript"
capture mkdir "$ManuscriptTables"

* Exposure-specific effects for primary outcomes.
tempfile expspec
tempname pexp
postfile `pexp' str35 outcome str12 arm double b_visit2 double ll_visit2 double ul_visit2 ///
    double b_visit3 double ll_visit3 double ul_visit3 double b_diff_v3_vs_v2 double ll_diff double ul_diff using `expspec', replace

use "$CTData/dataset A_nutri and carbon.dta", clear
foreach out in npm_avg carbonfootprint_avg {
    mixed `out' i.treatment_svy##i.visit_store || pid:
    foreach pair in "climate 3" "health 2" "combined 4" {
        gettoken aname acode : pair
        lincom `acode'.treatment_svy#2.visit_store
        local b2 = r(estimate)
        local ll2 = r(lb)
        local ul2 = r(ub)
        lincom `acode'.treatment_svy#3.visit_store
        local b3 = r(estimate)
        local ll3 = r(lb)
        local ul3 = r(ub)
        lincom `acode'.treatment_svy#3.visit_store - `acode'.treatment_svy#2.visit_store
        post `pexp' ("`out'") ("`aname'") (`b2') (`ll2') (`ul2') (`b3') (`ll3') (`ul3') (r(estimate)) (r(lb)) (r(ub))
    }
}
postclose `pexp'
use `expspec', clear
export delimited using "$ManuscriptTables/primary_exposure_specific_effects.csv", replace

* Exploratory food-group effects.
tempfile fgout
tempname pfg
postfile `pfg' str40 outcome_var str18 metric str12 arm double b double ll double ul using `fgout', replace

use "$CTData/dataset A_nutri and carbon.dta", clear
capture unab fgvars : k01aim3*
if !_rc {
    foreach out of local fgvars {
        local metric = cond(strpos("`out'","_npm"),"healthfulness","carbon")
        mixed `out' i.treatment_svy##i.visit_store || pid:
        quietly count if visit_store==2 & `out'<.
        local n2 = r(N)
        quietly count if visit_store==3 & `out'<.
        local n3 = r(N)
        local n23 = `n2'+`n3'
        foreach pair in "climate 3" "health 2" "combined 4" {
            gettoken aname acode : pair
            lincom ((`n2'/`n23')*(`acode'.treatment_svy#2.visit_store)) + ((`n3'/`n23')*(`acode'.treatment_svy#3.visit_store))
            post `pfg' ("`out'") ("`metric'") ("`aname'") (r(estimate)) (r(lb)) (r(ub))
        }
    }
}
postclose `pfg'
use `fgout', clear
export delimited using "$ManuscriptTables/food_group_exploratory_effects.csv", replace