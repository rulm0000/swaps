version 19
set more off
if "$project_root" == "" {
    do "00_global_paths.do"
}

global CTData "$Data_share/Output"

global ManuscriptTables "$OutTables/manuscript"
capture mkdir "$ManuscriptTables"

tempfile modq
tempname pmod
postfile `pmod' str35 outcome str30 moderator double p_joint using `modq', replace

use "$CTData/dataset A_nutri and carbon.dta", clear
gen age_young = agecat==1 if agecat<.

foreach out in npm_avg carbonfootprint_avg {
    mixed `out' i.treatment_svy##i.visit_store##i.age_young || pid:
    testparm i.treatment_svy#i.visit_store#i.age_young
    post `pmod' ("`out'") ("age_young_vs_older") (r(p))

    mixed `out' i.treatment_svy##i.visit_store##c.healthcon || pid:
    testparm i.treatment_svy#i.visit_store#c.healthcon
    post `pmod' ("`out'") ("healthcon_continuous") (r(p))

    mixed `out' i.treatment_svy##i.visit_store##c.green || pid:
    testparm i.treatment_svy#i.visit_store#c.green
    post `pmod' ("`out'") ("green_continuous") (r(p))
}

postclose `pmod'
use `modq', clear
export delimited using "$ManuscriptTables/primary_moderation_joint_tests.csv", replace