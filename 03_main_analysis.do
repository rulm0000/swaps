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
postfile `pt2' str30 domain str80 outcome str12 arm int arm_code ///
    double b double ll double ul double d double p using `t2long', replace

* Selection outcomes.
use "$CTData/dataset A_nutri and carbon.dta", clear
local poutcomes "npm_avg carbonfootprint_avg kcal_avg sugar_avg sodium_avg satfat_avg fib_avg protein_avg spend_ttl"
local plabels   `" "Healthfulness, Ofcom score (1-100)" "Carbon footprint, kg CO2-eq per kg" "Energy density, kcal per 100g" "Sugar density, grams per 100g" "Sodium density, milligrams per 100g" "Saturated fat density, grams per 100g" "Fiber density, grams per 100g" "Protein density, grams per 100g" "Total spending, US dollars" "'

local i = 1
foreach out of local poutcomes {
    local lbl : word `i' of `plabels'
    mixed `out' i.treatment_svy##i.visit_store || pid:
    quietly count if visit_store==2 & `out'<.
    local n2 = r(N)
    quietly count if visit_store==3 & `out'<.
    local n3 = r(N)
    local n23 = `n2'+`n3'

    lincom ((`n2'/`n23')*(3.treatment_svy#2.visit_store)) + ((`n3'/`n23')*(3.treatment_svy#3.visit_store))
    post `pt2' ("Selection outcomes") ("`lbl'") ("climate") (3) (r(estimate)) (r(lb)) (r(ub)) (.) (r(p))

    lincom ((`n2'/`n23')*(2.treatment_svy#2.visit_store)) + ((`n3'/`n23')*(2.treatment_svy#3.visit_store))
    post `pt2' ("Selection outcomes") ("`lbl'") ("health") (2) (r(estimate)) (r(lb)) (r(ub)) (.) (r(p))

    lincom ((`n2'/`n23')*(4.treatment_svy#2.visit_store)) + ((`n3'/`n23')*(4.treatment_svy#3.visit_store))
    post `pt2' ("Selection outcomes") ("`lbl'") ("combined") (4) (r(estimate)) (r(lb)) (r(ub)) (.) (r(p))

    local ++i
}

* Psychological outcomes.
use "$CTData/dataset B_psych data with demog_add-ons.dta", clear
local youtcomes "elab_health elab_envr elab_taste negaffect_avg posaffect_avg injunctive_heath descriptive_health injunctive_climate descriptive_climate"
local ylabels   `" "Health" "Climate impact" "Taste" "Negative emotions" "Positive emotions" "Injunctive norms to buy healthy foods" "Descriptive norms about buying healthy foods" "Injunctive norms to low-climate-impact foods" "Descriptive norms about buying low-climate-impact foods" "'

local i = 1
foreach out of local youtcomes {
    local lbl : word `i' of `ylabels'
    mixed `out' i.treatment_svy##i.visit || pid:
    quietly count if visit==2 & `out'<.
    local n2 = r(N)
    quietly count if visit==3 & `out'<.
    local n3 = r(N)
    local n23 = `n2'+`n3'

    lincom ((`n2'/`n23')*(3.treatment_svy#2.visit)) + ((`n3'/`n23')*(3.treatment_svy#3.visit))
    post `pt2' ("Psychological outcomes") ("`lbl'") ("climate") (3) (r(estimate)) (r(lb)) (r(ub)) (.) (r(p))

    lincom ((`n2'/`n23')*(2.treatment_svy#2.visit)) + ((`n3'/`n23')*(2.treatment_svy#3.visit))
    post `pt2' ("Psychological outcomes") ("`lbl'") ("health") (2) (r(estimate)) (r(lb)) (r(ub)) (.) (r(p))

    lincom ((`n2'/`n23')*(4.treatment_svy#2.visit)) + ((`n3'/`n23')*(4.treatment_svy#3.visit))
    post `pt2' ("Psychological outcomes") ("`lbl'") ("combined") (4) (r(estimate)) (r(lb)) (r(ub)) (.) (r(p))

    local ++i
}
postclose `pt2'

use `t2long', clear

/*
We manually entered the Table 2 Cohen's d values. We used the Campbell Collaboration online calculator:
https://www.campbellcollaboration.org/calculator/

Calculator path used:
- Cohen's d
- Regression
- HLM/mixed effects

Inputs entered into the calculator:
- Unstandardized regression coefficient (the ADE/B shown in the table)
- Standard error of this coefficient
- Standard deviation of the dependent variable, pooled across both groups and all
  time points (that is, a plain summarize of the DV)
- Sample sizes for treatment and control groups
- ICC (available in Stata after mixed via estat icc)
- Total number of clusters (3 here, corresponding to the number of time points)

*/
tempfile t2calc_d
save `t2calc_d', replace

clear
input str30 domain str80 outcome str12 arm double d_manual
"Selection outcomes" "Healthfulness, Ofcom score (1-100)" "climate" 0.25
"Selection outcomes" "Healthfulness, Ofcom score (1-100)" "health" 0.50
"Selection outcomes" "Healthfulness, Ofcom score (1-100)" "combined" 0.43
"Selection outcomes" "Carbon footprint, kg CO2-eq per kg" "climate" -0.42
"Selection outcomes" "Carbon footprint, kg CO2-eq per kg" "health" -0.05
"Selection outcomes" "Carbon footprint, kg CO2-eq per kg" "combined" -0.35
"Selection outcomes" "Energy density, kcal per 100g" "climate" -0.16
"Selection outcomes" "Energy density, kcal per 100g" "health" -0.18
"Selection outcomes" "Energy density, kcal per 100g" "combined" -0.18
"Selection outcomes" "Sugar density, grams per 100g" "climate" -0.08
"Selection outcomes" "Sugar density, grams per 100g" "health" -0.26
"Selection outcomes" "Sugar density, grams per 100g" "combined" -0.28
"Selection outcomes" "Sodium density, milligrams per 100g" "climate" -0.03
"Selection outcomes" "Sodium density, milligrams per 100g" "health" -0.15
"Selection outcomes" "Sodium density, milligrams per 100g" "combined" -0.12
"Selection outcomes" "Saturated fat density, grams per 100g" "climate" -0.33
"Selection outcomes" "Saturated fat density, grams per 100g" "health" -0.34
"Selection outcomes" "Saturated fat density, grams per 100g" "combined" -0.42
"Selection outcomes" "Fiber density, grams per 100g" "climate" 0.01
"Selection outcomes" "Fiber density, grams per 100g" "health" 0.25
"Selection outcomes" "Fiber density, grams per 100g" "combined" 0.16
"Selection outcomes" "Protein density, grams per 100g" "climate" -0.10
"Selection outcomes" "Protein density, grams per 100g" "health" 0.08
"Selection outcomes" "Protein density, grams per 100g" "combined" 0.00
"Selection outcomes" "Total spending, US dollars" "climate" -0.23
"Selection outcomes" "Total spending, US dollars" "health" -0.17
"Selection outcomes" "Total spending, US dollars" "combined" -0.14
"Psychological outcomes" "Health" "climate" 0.10
"Psychological outcomes" "Health" "health" 0.12
"Psychological outcomes" "Health" "combined" 0.10
"Psychological outcomes" "Climate impact" "climate" 0.47
"Psychological outcomes" "Climate impact" "health" 0.01
"Psychological outcomes" "Climate impact" "combined" 0.40
"Psychological outcomes" "Taste" "climate" -0.02
"Psychological outcomes" "Taste" "health" -0.06
"Psychological outcomes" "Taste" "combined" -0.07
"Psychological outcomes" "Negative emotions" "climate" 0.23
"Psychological outcomes" "Negative emotions" "health" 0.18
"Psychological outcomes" "Negative emotions" "combined" 0.23
"Psychological outcomes" "Positive emotions" "climate" 0.01
"Psychological outcomes" "Positive emotions" "health" 0.05
"Psychological outcomes" "Positive emotions" "combined" 0.01
"Psychological outcomes" "Injunctive norms to buy healthy foods" "climate" 0.04
"Psychological outcomes" "Injunctive norms to buy healthy foods" "health" 0.04
"Psychological outcomes" "Injunctive norms to buy healthy foods" "combined" 0.01
"Psychological outcomes" "Descriptive norms about buying healthy foods" "climate" -0.05
"Psychological outcomes" "Descriptive norms about buying healthy foods" "health" -0.03
"Psychological outcomes" "Descriptive norms about buying healthy foods" "combined" -0.09
"Psychological outcomes" "Injunctive norms to low-climate-impact foods" "climate" 0.04
"Psychological outcomes" "Injunctive norms to low-climate-impact foods" "health" 0.01
"Psychological outcomes" "Injunctive norms to low-climate-impact foods" "combined" 0.03
"Psychological outcomes" "Descriptive norms about buying low-climate-impact foods" "climate" 0.03
"Psychological outcomes" "Descriptive norms about buying low-climate-impact foods" "health" -0.05
"Psychological outcomes" "Descriptive norms about buying low-climate-impact foods" "combined" 0.02
end
tempfile t2manual_d
save `t2manual_d', replace

use `t2calc_d', clear
merge 1:1 domain outcome arm using `t2manual_d', nogen assert(match)
replace d = d_manual
drop d_manual

* Supplemental table: Holm-corrected p-values within each outcome (3 arm tests).
preserve
keep domain outcome arm p
egen family_id = group(domain outcome)
gen double p_holm = .
levelsof family_id, local(fid_list)
foreach fid of local fid_list {
    qqvalue p if family_id==`fid', method(holm) qvalue(p_holm_tmp)
    replace p_holm = p_holm_tmp if family_id==`fid'
    drop p_holm_tmp
}
reshape wide p p_holm, i(domain outcome) j(arm) string
order domain outcome pclimate p_holmclimate phealth p_holmhealth pcombined p_holmcombined
export excel using "$ManuscriptTables/manuscript_table2_holm_corrected_pvalues.xlsx", firstrow(variables) replace
restore

* Table 2 Excel export.
tempfile t2wide_display t2layout
preserve
keep domain outcome arm b ll ul d p
gen double rep_b = cond(domain=="Selection outcomes", round(b,0.1), round(b,0.01))
gen double rep_ll = cond(domain=="Selection outcomes", round(ll,0.1), round(ll,0.01))
gen double rep_ul = cond(domain=="Selection outcomes", round(ul,0.1), round(ul,0.01))
gen double rep_d = round(d,0.01)

reshape wide b ll ul d p rep_b rep_ll rep_ul rep_d, i(domain outcome) j(arm) string
save `t2wide_display', replace
restore

clear
input int row_order str12 row_type byte indent str30 domain str80 outcome str80 row_label
1  "section"  0 "Selection outcomes"     ""                                                   "Selection outcomes"
2  "outcome"  1 "Selection outcomes"     "Healthfulness, Ofcom score (1-100)"                 "Healthfulness, Ofcom score (1-100)"
3  "outcome"  1 "Selection outcomes"     "Carbon footprint, kg CO2-eq per kg"                 "Carbon footprint, kg CO2-eq per kg"
4  "outcome"  1 "Selection outcomes"     "Energy density, kcal per 100g"                      "Energy density, kcal per 100g"
5  "outcome"  1 "Selection outcomes"     "Sugar density, grams per 100g"                      "Sugar density, grams per 100g"
6  "outcome"  1 "Selection outcomes"     "Sodium density, milligrams per 100g"                "Sodium density, milligrams per 100g"
7  "outcome"  1 "Selection outcomes"     "Saturated fat density, grams per 100g"              "Saturated fat density, grams per 100g"
8  "outcome"  1 "Selection outcomes"     "Fiber density, grams per 100g"                      "Fiber density, grams per 100g"
9  "outcome"  1 "Selection outcomes"     "Protein density, grams per 100g"                    "Protein density, grams per 100g"
10 "outcome"  1 "Selection outcomes"     "Total spending, US dollars"                         "Total spending, US dollars"
11 "section"  0 "Psychological outcomes" ""                                                   "Psychological outcomes"
12 "subgroup" 1 "Psychological outcomes" ""                                                   "Cognitive elaboration"
13 "outcome"  2 "Psychological outcomes" "Health"                                              "Health"
14 "outcome"  2 "Psychological outcomes" "Climate impact"                                      "Climate impact"
15 "outcome"  2 "Psychological outcomes" "Taste"                                               "Taste"
16 "subgroup" 1 "Psychological outcomes" ""                                                   "Emotional reactions"
17 "outcome"  2 "Psychological outcomes" "Negative emotions"                                   "Negative emotions"
18 "outcome"  2 "Psychological outcomes" "Positive emotions"                                   "Positive emotions"
19 "subgroup" 1 "Psychological outcomes" ""                                                   "Norms"
20 "outcome"  2 "Psychological outcomes" "Injunctive norms to buy healthy foods"              "Injunctive norms to buy healthy foods"
21 "outcome"  2 "Psychological outcomes" "Descriptive norms about buying healthy foods"       "Descriptive norms about buying healthy foods"
22 "outcome"  2 "Psychological outcomes" "Injunctive norms to low-climate-impact foods"       "Injunctive norms to low-climate-impact foods"
23 "outcome"  2 "Psychological outcomes" "Descriptive norms about buying low-climate-impact foods" "Descriptive norms about buying low-climate-impact foods"
end
save `t2layout', replace

use `t2layout', clear
merge m:1 domain outcome using `t2wide_display', nogen keep(master match)
sort row_order

gen str120 row_label_display = row_label
replace row_label_display = "    " + row_label if indent==1
replace row_label_display = "        " + row_label if indent==2

gen str16 b_climate_txt = ""
gen str24 ci_climate_txt = ""
gen str10 p_climate_txt = ""
gen str12 d_climate_txt = ""
gen str16 b_health_txt = ""
gen str24 ci_health_txt = ""
gen str10 p_health_txt = ""
gen str12 d_health_txt = ""
gen str16 b_combined_txt = ""
gen str24 ci_combined_txt = ""
gen str10 p_combined_txt = ""
gen str12 d_combined_txt = ""

replace b_climate_txt = strtrim(string(rep_bclimate,"%9.1f")) if row_type=="outcome" & domain=="Selection outcomes"
replace b_health_txt = strtrim(string(rep_bhealth,"%9.1f")) if row_type=="outcome" & domain=="Selection outcomes"
replace b_combined_txt = strtrim(string(rep_bcombined,"%9.1f")) if row_type=="outcome" & domain=="Selection outcomes"
replace ci_climate_txt = "(" + strtrim(string(rep_llclimate,"%9.1f")) + ", " + strtrim(string(rep_ulclimate,"%9.1f")) + ")" if row_type=="outcome" & domain=="Selection outcomes"
replace ci_health_txt = "(" + strtrim(string(rep_llhealth,"%9.1f")) + ", " + strtrim(string(rep_ulhealth,"%9.1f")) + ")" if row_type=="outcome" & domain=="Selection outcomes"
replace ci_combined_txt = "(" + strtrim(string(rep_llcombined,"%9.1f")) + ", " + strtrim(string(rep_ulcombined,"%9.1f")) + ")" if row_type=="outcome" & domain=="Selection outcomes"

replace b_climate_txt = strtrim(string(rep_bclimate,"%9.2f")) if row_type=="outcome" & domain=="Psychological outcomes"
replace b_health_txt = strtrim(string(rep_bhealth,"%9.2f")) if row_type=="outcome" & domain=="Psychological outcomes"
replace b_combined_txt = strtrim(string(rep_bcombined,"%9.2f")) if row_type=="outcome" & domain=="Psychological outcomes"
replace ci_climate_txt = "(" + strtrim(string(rep_llclimate,"%9.2f")) + ", " + strtrim(string(rep_ulclimate,"%9.2f")) + ")" if row_type=="outcome" & domain=="Psychological outcomes"
replace ci_health_txt = "(" + strtrim(string(rep_llhealth,"%9.2f")) + ", " + strtrim(string(rep_ulhealth,"%9.2f")) + ")" if row_type=="outcome" & domain=="Psychological outcomes"
replace ci_combined_txt = "(" + strtrim(string(rep_llcombined,"%9.2f")) + ", " + strtrim(string(rep_ulcombined,"%9.2f")) + ")" if row_type=="outcome" & domain=="Psychological outcomes"

replace p_climate_txt = "<0.001" if row_type=="outcome" & pclimate<0.001
replace p_health_txt = "<0.001" if row_type=="outcome" & phealth<0.001
replace p_combined_txt = "<0.001" if row_type=="outcome" & pcombined<0.001
replace p_climate_txt = strtrim(string(round(pclimate,0.001),"%9.3f")) if row_type=="outcome" & pclimate>=0.001
replace p_health_txt = strtrim(string(round(phealth,0.001),"%9.3f")) if row_type=="outcome" & phealth>=0.001
replace p_combined_txt = strtrim(string(round(pcombined,0.001),"%9.3f")) if row_type=="outcome" & pcombined>=0.001
replace p_climate_txt = regexr(p_climate_txt,"0+$","") if row_type=="outcome" & pclimate>=0.001
replace p_health_txt = regexr(p_health_txt,"0+$","") if row_type=="outcome" & phealth>=0.001
replace p_combined_txt = regexr(p_combined_txt,"0+$","") if row_type=="outcome" & pcombined>=0.001
replace p_climate_txt = regexr(p_climate_txt,"\\.$","") if row_type=="outcome" & pclimate>=0.001
replace p_health_txt = regexr(p_health_txt,"\\.$","") if row_type=="outcome" & phealth>=0.001
replace p_combined_txt = regexr(p_combined_txt,"\\.$","") if row_type=="outcome" & pcombined>=0.001

replace d_climate_txt = strtrim(string(rep_dclimate,"%9.2f")) if row_type=="outcome"
replace d_health_txt = strtrim(string(rep_dhealth,"%9.2f")) if row_type=="outcome"
replace d_combined_txt = strtrim(string(rep_dcombined,"%9.2f")) if row_type=="outcome"

gen byte sig_climate = (llclimate>0 | ulclimate<0) if row_type=="outcome"
gen byte sig_health = (llhealth>0 | ulhealth<0) if row_type=="outcome"
gen byte sig_combined = (llcombined>0 | ulcombined<0) if row_type=="outcome"
gen byte is_section = (row_type=="section")
gen byte is_subgroup = (row_type=="subgroup")

label variable row_label_display ""
label variable b_climate_txt ""
label variable ci_climate_txt ""
label variable p_climate_txt ""
label variable d_climate_txt ""
label variable b_health_txt ""
label variable ci_health_txt ""
label variable p_health_txt ""
label variable d_health_txt ""
label variable b_combined_txt ""
label variable ci_combined_txt ""
label variable p_combined_txt ""
label variable d_combined_txt ""

putexcel set "$ManuscriptTables/manuscript_table2_formatted.xlsx", replace
export excel row_label_display b_climate_txt ci_climate_txt p_climate_txt d_climate_txt ///
    b_health_txt ci_health_txt p_health_txt d_health_txt ///
    b_combined_txt ci_combined_txt p_combined_txt d_combined_txt ///
    using "$ManuscriptTables/manuscript_table2_formatted.xlsx", ///
    sheet("Table2") sheetreplace cell(A5)

putexcel set "$ManuscriptTables/manuscript_table2_formatted.xlsx", sheet("Table2") modify
putexcel A1 = ("Table 2. Effects of the climate, health, and climate + health swaps on food and beverage purchases and psychological outcomes, n=1,201 US adults")
putexcel A3 = ("Outcomes") B3 = ("Climate swaps") F3 = ("Health swaps") J3 = ("Climate + health swaps")
putexcel B3:E3, merge hcenter
putexcel F3:I3, merge hcenter
putexcel J3:M3, merge hcenter
putexcel B4 = ("B") C4 = ("(95%CI)") D4 = ("p-value") E4 = ("Cohen's d")
putexcel F4 = ("B") G4 = ("(95%CI)") H4 = ("p-value") I4 = ("Cohen's d")
putexcel J4 = ("B") K4 = ("(95%CI)") L4 = ("p-value") M4 = ("Cohen's d")
putexcel A3:M4, bold

forvalues i = 1/`=_N' {
    local excel_row = `i' + 4
    local sec = is_section[`i']
    local sub = is_subgroup[`i']
    if `sec'==1 | `sub'==1 {
        putexcel A`excel_row', bold
    }

    local sgc = sig_climate[`i']
    if `sgc'==1 {
        putexcel B`excel_row' C`excel_row' D`excel_row' E`excel_row', bold
    }
    local sgh = sig_health[`i']
    if `sgh'==1 {
        putexcel F`excel_row' G`excel_row' H`excel_row' I`excel_row', bold
    }
    local sgb = sig_combined[`i']
    if `sgb'==1 {
        putexcel J`excel_row' K`excel_row' L`excel_row' M`excel_row', bold
    }
}

putexcel A3:M3, border(bottom)
putexcel A4:M4, border(bottom)
putexcel A3:A27, border(right)
putexcel E3:E27, border(right)
putexcel I3:I27, border(right)
putexcel M3:M27, border(right)
putexcel A3:M27, txtwrap

* Figure 3 source.
use "$CTData/dataset A_nutri and carbon.dta", clear
collapse (mean) npm_mean=npm_avg carbon_mean=carbonfootprint_avg ///
         (semean) npm_se=npm_avg carbon_se=carbonfootprint_avg, by(treatment_svy visit_store)
export delimited using "$ManuscriptFigures/figure3_primary_means_se_by_visit.csv", replace