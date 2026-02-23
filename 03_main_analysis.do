version 19
set more off
if "$project_root" == "" {
    do "00_global_paths.do"
}

global CTData "$Data_share/Output"

global ManuscriptTables "$OutTables/manuscript"
global ManuscriptFigures "$OutFigures/manuscript"
capture mkdir "$ManuscriptTables"
capture mkdir "$ManuscriptFigures"

tempfile t2long
tempname pt2
postfile `pt2' str20 domain str80 outcome str12 arm int arm_code ///
    double b double ll double ul double d ///
    double baseline_mean_control double baseline_sd_control using `t2long', replace

* Selection outcomes.
use "$CTData/dataset A_nutri and carbon.dta", clear
local poutcomes "npm_avg carbonfootprint_avg kcal_avg sugar_avg sodium_avg satfat_avg fib_avg protein_avg spend_ttl"
local plabels   `" "Healthfulness, Ofcom score (1-100)" "Carbon footprint, kg CO2-eq per kg" "Energy density, kcal per 100g" "Sugar density, grams per 100g" "Sodium density, milligrams per 100g" "Saturated fat density, grams per 100g" "Fiber density, grams per 100g" "Protein density, grams per 100g" "Total spending, US dollars" "'

local i = 1
foreach out of local poutcomes {
    local lbl : word `i' of `plabels'
    quietly summarize `out' if treatment_svy==1 & visit_store==1
    local sd0 = r(sd)
    local m0  = r(mean)

    mixed `out' i.treatment_svy##i.visit_store || pid:
    quietly count if visit_store==2 & `out'<.
    local n2 = r(N)
    quietly count if visit_store==3 & `out'<.
    local n3 = r(N)
    local n23 = `n2'+`n3'

    lincom ((`n2'/`n23')*(3.treatment_svy#2.visit_store)) + ((`n3'/`n23')*(3.treatment_svy#3.visit_store))
    post `pt2' ("Selection outcomes") ("`lbl'") ("climate") (3) (r(estimate)) (r(lb)) (r(ub)) (r(estimate)/`sd0') (`m0') (`sd0')

    lincom ((`n2'/`n23')*(2.treatment_svy#2.visit_store)) + ((`n3'/`n23')*(2.treatment_svy#3.visit_store))
    post `pt2' ("Selection outcomes") ("`lbl'") ("health") (2) (r(estimate)) (r(lb)) (r(ub)) (r(estimate)/`sd0') (`m0') (`sd0')

    lincom ((`n2'/`n23')*(4.treatment_svy#2.visit_store)) + ((`n3'/`n23')*(4.treatment_svy#3.visit_store))
    post `pt2' ("Selection outcomes") ("`lbl'") ("combined") (4) (r(estimate)) (r(lb)) (r(ub)) (r(estimate)/`sd0') (`m0') (`sd0')

    local ++i
}

* Psychological outcomes.
use "$CTData/dataset B_psych data with demog_add-ons.dta", clear
local youtcomes "elab_health elab_envr elab_taste negaffect_avg posaffect_avg injunctive_heath descriptive_health injunctive_climate descriptive_climate"
local ylabels   `" "Health" "Climate impact" "Taste" "Negative emotions" "Positive emotions" "Injunctive norms to buy healthy foods" "Descriptive norms about buying healthy foods" "Injunctive norms to low-climate-impact foods" "Descriptive norms about buying low-climate-impact foods" "'

local i = 1
foreach out of local youtcomes {
    local lbl : word `i' of `ylabels'
    quietly summarize `out' if treatment_svy==1 & visit==1
    local sd0 = r(sd)
    local m0  = r(mean)

    mixed `out' i.treatment_svy##i.visit || pid:
    quietly count if visit==2 & `out'<.
    local n2 = r(N)
    quietly count if visit==3 & `out'<.
    local n3 = r(N)
    local n23 = `n2'+`n3'

    lincom ((`n2'/`n23')*(3.treatment_svy#2.visit)) + ((`n3'/`n23')*(3.treatment_svy#3.visit))
    post `pt2' ("Psychological outcomes") ("`lbl'") ("climate") (3) (r(estimate)) (r(lb)) (r(ub)) (r(estimate)/`sd0') (`m0') (`sd0')

    lincom ((`n2'/`n23')*(2.treatment_svy#2.visit)) + ((`n3'/`n23')*(2.treatment_svy#3.visit))
    post `pt2' ("Psychological outcomes") ("`lbl'") ("health") (2) (r(estimate)) (r(lb)) (r(ub)) (r(estimate)/`sd0') (`m0') (`sd0')

    lincom ((`n2'/`n23')*(4.treatment_svy#2.visit)) + ((`n3'/`n23')*(4.treatment_svy#3.visit))
    post `pt2' ("Psychological outcomes") ("`lbl'") ("combined") (4) (r(estimate)) (r(lb)) (r(ub)) (r(estimate)/`sd0') (`m0') (`sd0')

    local ++i
}
postclose `pt2'

use `t2long', clear
export delimited using "$ManuscriptTables/manuscript_table2_replication_long.csv", replace

preserve
keep domain outcome arm b ll ul d
reshape wide b ll ul d, i(domain outcome) j(arm) string
order domain outcome bclimate llclimate ulclimate dclimate bhealth llhealth ulhealth dhealth bcombined llcombined ulcombined dcombined
export delimited using "$ManuscriptTables/manuscript_table2_replication_wide.csv", replace
restore

* Figure 3 source.
use "$CTData/dataset A_nutri and carbon.dta", clear
collapse (mean) npm_mean=npm_avg carbon_mean=carbonfootprint_avg ///
         (semean) npm_se=npm_avg carbon_se=carbonfootprint_avg, by(treatment_svy visit_store)
export delimited using "$ManuscriptFigures/figure3_primary_means_se_by_visit.csv", replace