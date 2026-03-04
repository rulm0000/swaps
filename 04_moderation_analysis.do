version 19
set more off
if "$project_root" == "" {
    do "00_global_paths.do"
}

global CTData "$Data_share/Output"

global ManuscriptTables "$OutTables/manuscript"
capture mkdir "$ManuscriptTables"

tempfile modq modraw moddisp
tempname pmod praw pdisp
postfile `pmod' str35 outcome str30 moderator double p_joint using `modq', replace
postfile `praw' int outcome_order str50 outcome_label int moderator_order str40 moderator_label ///
    str12 arm int arm_code double b double ll double ul double p using `modraw', replace
postfile `pdisp' int outcome_order str50 outcome_label int moderator_order str40 moderator_label ///
    str20 climate_b str25 climate_ci byte climate_sig ///
    str20 health_b  str25 health_ci  byte health_sig ///
    str20 combined_b str25 combined_ci byte combined_sig using `moddisp', replace

use "$CTData/dataset A_nutri and carbon.dta", clear
gen age_young = agecat==1 if agecat<.

foreach outspec in ///
    "1 npm_avg Healthfulness,_Ofcom_score_(1-100)" ///
    "2 carbonfootprint_avg Carbon_footprint,_kg_CO2-eq_per_kg" {

    gettoken oord rest : outspec
    gettoken out  olabel : rest
    local olabel = trim(subinstr("`olabel'","_"," ",.))

    foreach modspec in ///
        "1 age_young i Younger_vs_older_(agecat_1_vs_2-4)" ///
        "2 healthcon c Health-consciousness_(continuous)" ///
        "3 green c Climate-concern_(continuous)" {

        gettoken mord rest2 : modspec
        gettoken modvar rest2 : rest2
        gettoken mtype mlabel : rest2
        local mlabel = trim(subinstr("`mlabel'","_"," ",.))

        mixed `out' i.treatment_svy##i.visit_store##`mtype'.`modvar' || pid:
        testparm i.treatment_svy#i.visit_store#`mtype'.`modvar'
        post `pmod' ("`out'") ("`modvar'") (r(p))

        quietly count if e(sample) & visit_store==2
        local n2 = r(N)
        quietly count if e(sample) & visit_store==3
        local n3 = r(N)
        local n23 = `n2' + `n3'
        local modterm = cond("`mtype'"=="i","1.`modvar'","c.`modvar'")

        foreach pair in "climate 3" "health 2" "combined 4" {
            gettoken aname acode : pair
            lincom ((`n2'/`n23')*(`acode'.treatment_svy#2.visit_store#`modterm')) + ///
                   ((`n3'/`n23')*(`acode'.treatment_svy#3.visit_store#`modterm'))
            post `praw' (`oord') ("`olabel'") (`mord') ("`mlabel'") ///
                ("`aname'") (`acode') (r(estimate)) (r(lb)) (r(ub)) (r(p))

            local b_`aname'  = trim(string(r(estimate),"%9.1f"))
            local ll_`aname' = trim(string(r(lb),"%9.1f"))
            local ul_`aname' = trim(string(r(ub),"%9.1f"))
            local ci_`aname' = "(`ll_`aname'', `ul_`aname'')"
            local sig_`aname' = cond(r(p)<0.05,1,0)
        }

        post `pdisp' (`oord') ("`olabel'") (`mord') ("`mlabel'") ///
            ("`b_climate'") ("`ci_climate'") (`sig_climate') ///
            ("`b_health'") ("`ci_health'") (`sig_health') ///
            ("`b_combined'") ("`ci_combined'") (`sig_combined')
    }
}

postclose `pmod'
postclose `praw'
postclose `pdisp'

use `modq', clear
export delimited using "$ManuscriptTables/primary_moderation_joint_tests.csv", replace

use `modraw', clear
sort outcome_order moderator_order arm_code
export delimited using "$ManuscriptTables/primary_moderation_effects_long.csv", replace

use `moddisp', clear
sort outcome_order moderator_order
gen str70 outcome = ""
by outcome_order: replace outcome = outcome_label if _n==1
gen str80 category = "    " + moderator_label
order outcome category climate_b climate_ci health_b health_ci combined_b combined_ci ///
    climate_sig health_sig combined_sig
preserve
keep outcome category climate_b climate_ci health_b health_ci combined_b combined_ci
export delimited using "$ManuscriptTables/primary_moderation_table_formatted.csv", replace
restore

putexcel set "$ManuscriptTables/primary_moderation_table_formatted.xlsx", replace
putexcel A1 = ("Table. Moderation effects on primary outcomes by intervention arm")
putexcel A2 = ("Outcome")
putexcel B2 = ("")
putexcel C2 = ("Climate swaps")
putexcel D2 = ("")
putexcel E2 = ("Health swaps")
putexcel F2 = ("")
putexcel G2 = ("Climate + health swaps")
putexcel H2 = ("")
putexcel C3 = ("B")
putexcel D3 = ("(95% CI)")
putexcel E3 = ("B")
putexcel F3 = ("(95% CI)")
putexcel G3 = ("B")
putexcel H3 = ("(95% CI)")

forvalues i=1/`=_N' {
    local r = `i' + 3
    local outcome_val = outcome[`i']
    local category_val = category[`i']
    local cb = climate_b[`i']
    local cc = climate_ci[`i']
    local hb = health_b[`i']
    local hc = health_ci[`i']
    local xb = combined_b[`i']
    local xc = combined_ci[`i']
    local cs = climate_sig[`i']
    local hs = health_sig[`i']
    local xs = combined_sig[`i']

    putexcel A`r' = ("`outcome_val'")
    putexcel B`r' = ("`category_val'")
    putexcel C`r' = ("`cb'")
    putexcel D`r' = ("`cc'")
    putexcel E`r' = ("`hb'")
    putexcel F`r' = ("`hc'")
    putexcel G`r' = ("`xb'")
    putexcel H`r' = ("`xc'")

    if `cs'==1 {
        putexcel C`r', bold
        putexcel D`r', bold
    }
    if `hs'==1 {
        putexcel E`r', bold
        putexcel F`r', bold
    }
    if `xs'==1 {
        putexcel G`r', bold
        putexcel H`r', bold
    }
}

local noterow = _N + 5
putexcel A`noterow' = ("Abbreviations. CI, confidence interval.")
putexcel A`=`noterow'+1' = ("Note. Estimates are pooled visit-2/visit-3 moderation effects with mixed models and 3-way interactions; bold indicates p<0.05.")