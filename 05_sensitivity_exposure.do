version 19
set more off
if "$project_root" == "" {
    do "00_global_paths.do"
}

global CTData "$Data_share/Output"

global ManuscriptTables "$OutTables/manuscript"
capture mkdir "$ManuscriptTables"

* Exploratory food-group effects.
tempfile fgraw fgwide fglines
tempname pfg plines
postfile `pfg' str80 outcome str35 food_group str12 arm int arm_code ///
    double b double ll double ul double p using `fgraw', replace

use "$CTData/dataset A_nutri and carbon.dta", clear
keep if inlist(visit_store,1,2,3)
gen visit = visit_store

* If finalized dataset A does not include precomputed food-group outcomes,
* build them from the all-rows file and merge by pid/visit.
capture confirm variable k01aim3_beverages_npm
if _rc {
    tempfile fgvars
    preserve
    use "$CTData/Int dataset A_nutri and carbon_all rows.dta", clear
    keep if inlist(visit_store,1,2,3)
    gen visit = visit_store
    levelsof k01aim3_label_group, local(food_groups)
    foreach fg of local food_groups {
        local varname = subinstr("`fg'", " ", "_", .)
        bysort pid visit: egen `varname'_npm_temp = mean(npm_100) if k01aim3_label_group == "`fg'"
        bysort pid visit: egen `varname'_npm = max(`varname'_npm_temp)
        drop `varname'_npm_temp
        bysort pid visit: egen `varname'_cf_temp = mean(carbonfootprint_g) if k01aim3_label_group == "`fg'"
        bysort pid visit: egen `varname'_carbon = max(`varname'_cf_temp)
        drop `varname'_cf_temp
    }
    keep pid visit_store ///
        k01aim3_beverages_npm k01aim3_meals_npm k01aim3_proteins_npm k01aim3_milk_dairy_npm k01aim3_soups_npm k01aim3_sweets_snacks_npm ///
        k01aim3_beverages_carbon k01aim3_meals_carbon k01aim3_proteins_carbon k01aim3_milk_dairy_carbon k01aim3_soups_carbon k01aim3_sweets_snacks_carbon
    duplicates drop pid visit_store, force
    save `fgvars', replace
    restore
    merge 1:1 pid visit_store using `fgvars', nogen keep(master match)
}

keep pid treatment_svy visit_store ///
    k01aim3_beverages_npm k01aim3_meals_npm k01aim3_proteins_npm k01aim3_milk_dairy_npm k01aim3_soups_npm k01aim3_sweets_snacks_npm ///
    k01aim3_beverages_carbon k01aim3_meals_carbon k01aim3_proteins_carbon k01aim3_milk_dairy_carbon k01aim3_soups_carbon k01aim3_sweets_snacks_carbon
gen visit = visit_store

local foodgroupdvs_npm "k01aim3_beverages_npm k01aim3_meals_npm k01aim3_proteins_npm k01aim3_milk_dairy_npm k01aim3_soups_npm k01aim3_sweets_snacks_npm"
local foodgroupdvs_carbon "k01aim3_beverages_carbon k01aim3_meals_carbon k01aim3_proteins_carbon k01aim3_milk_dairy_carbon k01aim3_soups_carbon k01aim3_sweets_snacks_carbon"

foreach out of local foodgroupdvs_npm {
    local outcome_label "Healthfulness (Ofcom score, 1-100)"
    local glabel ""
    if "`out'"=="k01aim3_beverages_npm" local glabel "Beverages"
    if "`out'"=="k01aim3_meals_npm" local glabel "Boxed and frozen meals"
    if "`out'"=="k01aim3_proteins_npm" local glabel "Meat and meat alternatives"
    if "`out'"=="k01aim3_milk_dairy_npm" local glabel "Milk and dairy products"
    if "`out'"=="k01aim3_soups_npm" local glabel "Soups"
    if "`out'"=="k01aim3_sweets_snacks_npm" local glabel "Sweets and snacks"

    mixed `out' i.treatment_svy##i.visit || pid:
    quietly count if visit==2 & `out'<.
    local n2 = r(N)
    quietly count if visit==3 & `out'<.
    local n3 = r(N)
    local n23 = `n2' + `n3'

    if `n23'>0 {
        lincom ((`n2'/`n23')*(3.treatment_svy#2.visit)) + ((`n3'/`n23')*(3.treatment_svy#3.visit))
        post `pfg' ("`outcome_label'") ("`glabel'") ("climate") (3) (r(estimate)) (r(lb)) (r(ub)) (r(p))
        lincom ((`n2'/`n23')*(2.treatment_svy#2.visit)) + ((`n3'/`n23')*(2.treatment_svy#3.visit))
        post `pfg' ("`outcome_label'") ("`glabel'") ("health") (2) (r(estimate)) (r(lb)) (r(ub)) (r(p))
        lincom ((`n2'/`n23')*(4.treatment_svy#2.visit)) + ((`n3'/`n23')*(4.treatment_svy#3.visit))
        post `pfg' ("`outcome_label'") ("`glabel'") ("combined") (4) (r(estimate)) (r(lb)) (r(ub)) (r(p))
    }
}

foreach out of local foodgroupdvs_carbon {
    local outcome_label "Carbon footprint, kg CO2-eq per kg"
    local glabel ""
    if "`out'"=="k01aim3_beverages_carbon" local glabel "Beverages"
    if "`out'"=="k01aim3_meals_carbon" local glabel "Boxed and frozen meals"
    if "`out'"=="k01aim3_proteins_carbon" local glabel "Meat and meat alternatives"
    if "`out'"=="k01aim3_milk_dairy_carbon" local glabel "Milk and dairy products"
    if "`out'"=="k01aim3_soups_carbon" local glabel "Soups"
    if "`out'"=="k01aim3_sweets_snacks_carbon" local glabel "Sweets and snacks"

    mixed `out' i.treatment_svy##i.visit || pid:
    quietly count if visit==2 & `out'<.
    local n2 = r(N)
    quietly count if visit==3 & `out'<.
    local n3 = r(N)
    local n23 = `n2' + `n3'

    if `n23'>0 {
        lincom ((`n2'/`n23')*(3.treatment_svy#2.visit)) + ((`n3'/`n23')*(3.treatment_svy#3.visit))
        post `pfg' ("`outcome_label'") ("`glabel'") ("climate") (3) (r(estimate)) (r(lb)) (r(ub)) (r(p))
        lincom ((`n2'/`n23')*(2.treatment_svy#2.visit)) + ((`n3'/`n23')*(2.treatment_svy#3.visit))
        post `pfg' ("`outcome_label'") ("`glabel'") ("health") (2) (r(estimate)) (r(lb)) (r(ub)) (r(p))
        lincom ((`n2'/`n23')*(4.treatment_svy#2.visit)) + ((`n3'/`n23')*(4.treatment_svy#3.visit))
        post `pfg' ("`outcome_label'") ("`glabel'") ("combined") (4) (r(estimate)) (r(lb)) (r(ub)) (r(p))
    }
}
postclose `pfg'

use `fgraw', clear
sort outcome food_group arm_code

keep outcome food_group arm b ll ul p
reshape wide b ll ul p, i(outcome food_group) j(arm) string
gen str20 climate_b = trim(string(bclimate,"%9.1f"))
gen str20 health_b = trim(string(bhealth,"%9.1f"))
gen str20 combined_b = trim(string(bcombined,"%9.1f"))
gen str25 climate_ci = "(" + trim(string(llclimate,"%9.1f")) + ", " + trim(string(ulclimate,"%9.1f")) + ")"
gen str25 health_ci = "(" + trim(string(llhealth,"%9.1f")) + ", " + trim(string(ulhealth,"%9.1f")) + ")"
gen str25 combined_ci = "(" + trim(string(llcombined,"%9.1f")) + ", " + trim(string(ulcombined,"%9.1f")) + ")"
gen byte climate_sig = (pclimate<0.05)
gen byte health_sig = (phealth<0.05)
gen byte combined_sig = (pcombined<0.05)
gen metric_order = cond(outcome=="Healthfulness (Ofcom score, 1-100)",1,2)
gen group_order = .
replace group_order = 1 if food_group=="Beverages"
replace group_order = 2 if food_group=="Boxed and frozen meals"
replace group_order = 3 if food_group=="Meat and meat alternatives"
replace group_order = 4 if food_group=="Milk and dairy products"
replace group_order = 5 if food_group=="Soups"
replace group_order = 6 if food_group=="Sweets and snacks"
sort metric_order group_order
save `fgwide', replace

postfile `plines' int sort_order str80 row_label ///
    str20 climate_b str25 climate_ci ///
    str20 health_b str25 health_ci ///
    str20 combined_b str25 combined_ci ///
    byte climate_sig byte health_sig byte combined_sig ///
    byte is_section using `fglines', replace

local s = 0
post `plines' (`s') ("Healthfulness (Ofcom score, 1-100)") ("") ("") ("") ("") ("") ("") (.) (.) (.) (1)
use `fgwide', clear
keep if metric_order==1
sort group_order
forvalues i=1/`=_N' {
    local ++s
    local lbl = "    " + food_group[`i']
    post `plines' (`s') ("`lbl'") ///
        (climate_b[`i']) (climate_ci[`i']) ///
        (health_b[`i']) (health_ci[`i']) ///
        (combined_b[`i']) (combined_ci[`i']) ///
        (climate_sig[`i']) (health_sig[`i']) (combined_sig[`i']) (0)
}

local ++s
post `plines' (`s') ("Carbon footprint, kg CO2-eq per kg") ("") ("") ("") ("") ("") ("") (.) (.) (.) (1)
use `fgwide', clear
keep if metric_order==2
sort group_order
forvalues i=1/`=_N' {
    local ++s
    local lbl = "    " + food_group[`i']
    post `plines' (`s') ("`lbl'") ///
        (climate_b[`i']) (climate_ci[`i']) ///
        (health_b[`i']) (health_ci[`i']) ///
        (combined_b[`i']) (combined_ci[`i']) ///
        (climate_sig[`i']) (health_sig[`i']) (combined_sig[`i']) (0)
}
postclose `plines'

use `fglines', clear
sort sort_order
drop sort_order
rename row_label outcome
order outcome climate_b climate_ci health_b health_ci combined_b combined_ci

putexcel set "$ManuscriptTables/s6_table_effects_by_food_group.xlsx", replace
putexcel A1 = ("S6 Table. Effects of the climate, health, and climate + health swaps on the healthfulness and carbon footprint of food and beverage purchases, by food group, n=1,201 US adults")
putexcel A3 = ("Outcome")
putexcel B3 = ("Climate swaps")
putexcel D3 = ("Health swaps")
putexcel F3 = ("Climate + health swaps")
putexcel B3:C3, merge hcenter
putexcel D3:E3, merge hcenter
putexcel F3:G3, merge hcenter
putexcel B4 = ("B")
putexcel C4 = ("(95%CI)")
putexcel D4 = ("B")
putexcel E4 = ("(95%CI)")
putexcel F4 = ("B")
putexcel G4 = ("(95%CI)")
putexcel A3:G4, bold

forvalues i=1/`=_N' {
    local r = `i' + 4
    local ov = outcome[`i']
    local cb = climate_b[`i']
    local cc = climate_ci[`i']
    local hb = health_b[`i']
    local hc = health_ci[`i']
    local xb = combined_b[`i']
    local xc = combined_ci[`i']
    local cs = climate_sig[`i']
    local hs = health_sig[`i']
    local xs = combined_sig[`i']

    putexcel A`r' = ("`ov'")
    putexcel B`r' = ("`cb'")
    putexcel C`r' = ("`cc'")
    putexcel D`r' = ("`hb'")
    putexcel E`r' = ("`hc'")
    putexcel F`r' = ("`xb'")
    putexcel G`r' = ("`xc'")

    local sec = is_section[`i']
    if `sec'==1 {
        putexcel A`r', bold
    }

    if `cs'==1 {
        putexcel B`r' C`r', bold
    }
    if `hs'==1 {
        putexcel D`r' E`r', bold
    }
    if `xs'==1 {
        putexcel F`r' G`r', bold
    }
}

local endrow = _N + 4
putexcel A3:G3, border(bottom)
putexcel A4:G4, border(bottom)
putexcel A3:A`endrow', border(right)
putexcel C3:C`endrow', border(right)
putexcel E3:E`endrow', border(right)
putexcel G3:G`endrow', border(right)

local noterow = _N + 6
putexcel A`noterow' = ("Abbreviations. CI, confidence interval; CO2-eq, carbon dioxide equivalents.")
putexcel A`=`noterow'+1' = ("Note. Table shows the impact of each swaps intervention compared to control (no intervention), given as the difference-in-differences from baseline to follow-up between the swaps arm and the control arm (B). Table shows effects pooled across the first and second exposure to the swaps. Bolded effects are statistically significant, p<.05.")