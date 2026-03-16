version 19
set more off
if "$project_root" == "" {
    do "00_global_paths.do"
}

* S5 supplement: Bonferroni-Holm corrected p-values for the Table 2 outcomes.
global CTData "$Data_share/Output"

global ManuscriptTables "$OutTables/manuscript"
capture mkdir "$ManuscriptTables"

tempfile t2long t2holm t2wide_display t2layout
tempname pt2
postfile `pt2' str30 domain str80 outcome str12 arm int arm_code ///
    double b double ll double ul double p using `t2long', replace

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
    post `pt2' ("Selection outcomes") ("`lbl'") ("climate") (3) (r(estimate)) (r(lb)) (r(ub)) (r(p))

    lincom ((`n2'/`n23')*(2.treatment_svy#2.visit_store)) + ((`n3'/`n23')*(2.treatment_svy#3.visit_store))
    post `pt2' ("Selection outcomes") ("`lbl'") ("health") (2) (r(estimate)) (r(lb)) (r(ub)) (r(p))

    lincom ((`n2'/`n23')*(4.treatment_svy#2.visit_store)) + ((`n3'/`n23')*(4.treatment_svy#3.visit_store))
    post `pt2' ("Selection outcomes") ("`lbl'") ("combined") (4) (r(estimate)) (r(lb)) (r(ub)) (r(p))

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
    post `pt2' ("Psychological outcomes") ("`lbl'") ("climate") (3) (r(estimate)) (r(lb)) (r(ub)) (r(p))

    lincom ((`n2'/`n23')*(2.treatment_svy#2.visit)) + ((`n3'/`n23')*(2.treatment_svy#3.visit))
    post `pt2' ("Psychological outcomes") ("`lbl'") ("health") (2) (r(estimate)) (r(lb)) (r(ub)) (r(p))

    lincom ((`n2'/`n23')*(4.treatment_svy#2.visit)) + ((`n3'/`n23')*(4.treatment_svy#3.visit))
    post `pt2' ("Psychological outcomes") ("`lbl'") ("combined") (4) (r(estimate)) (r(lb)) (r(ub)) (r(p))

    local ++i
}
postclose `pt2'

use `t2long', clear

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
keep domain outcome arm p_holm
save `t2holm', replace
restore

merge 1:1 domain outcome arm using `t2holm', nogen assert(match)

preserve
keep domain outcome arm b ll ul p_holm
gen double rep_b = cond(domain=="Selection outcomes", round(b,0.1), round(b,0.01))
gen double rep_ll = cond(domain=="Selection outcomes", round(ll,0.1), round(ll,0.01))
gen double rep_ul = cond(domain=="Selection outcomes", round(ul,0.1), round(ul,0.01))
reshape wide b ll ul p_holm rep_b rep_ll rep_ul, i(domain outcome) j(arm) string
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
gen str16 b_health_txt = ""
gen str24 ci_health_txt = ""
gen str10 p_health_txt = ""
gen str16 b_combined_txt = ""
gen str24 ci_combined_txt = ""
gen str10 p_combined_txt = ""

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

replace p_climate_txt = "<0.001" if row_type=="outcome" & p_holmclimate<0.001
replace p_health_txt = "<0.001" if row_type=="outcome" & p_holmhealth<0.001
replace p_combined_txt = "<0.001" if row_type=="outcome" & p_holmcombined<0.001
replace p_climate_txt = strtrim(string(round(p_holmclimate,0.001),"%9.3f")) if row_type=="outcome" & inrange(p_holmclimate,0.001,0.049999999)
replace p_health_txt = strtrim(string(round(p_holmhealth,0.001),"%9.3f")) if row_type=="outcome" & inrange(p_holmhealth,0.001,0.049999999)
replace p_combined_txt = strtrim(string(round(p_holmcombined,0.001),"%9.3f")) if row_type=="outcome" & inrange(p_holmcombined,0.001,0.049999999)
replace p_climate_txt = ">0.99" if row_type=="outcome" & p_holmclimate>=0.995
replace p_health_txt = ">0.99" if row_type=="outcome" & p_holmhealth>=0.995
replace p_combined_txt = ">0.99" if row_type=="outcome" & p_holmcombined>=0.995
replace p_climate_txt = strtrim(string(round(p_holmclimate,0.01),"%9.2f")) if row_type=="outcome" & inrange(p_holmclimate,0.05,0.994999999)
replace p_health_txt = strtrim(string(round(p_holmhealth,0.01),"%9.2f")) if row_type=="outcome" & inrange(p_holmhealth,0.05,0.994999999)
replace p_combined_txt = strtrim(string(round(p_holmcombined,0.01),"%9.2f")) if row_type=="outcome" & inrange(p_holmcombined,0.05,0.994999999)

gen byte sig_climate = (llclimate>0 | ulclimate<0) if row_type=="outcome"
gen byte sig_health = (llhealth>0 | ulhealth<0) if row_type=="outcome"
gen byte sig_combined = (llcombined>0 | ulcombined<0) if row_type=="outcome"
gen byte is_section = (row_type=="section")
gen byte is_subgroup = (row_type=="subgroup")

label variable row_label_display ""
label variable b_climate_txt ""
label variable ci_climate_txt ""
label variable p_climate_txt ""
label variable b_health_txt ""
label variable ci_health_txt ""
label variable p_health_txt ""
label variable b_combined_txt ""
label variable ci_combined_txt ""
label variable p_combined_txt ""

putexcel set "$ManuscriptTables/s5_table_bh_corrected_pvalues.xlsx", replace
export excel row_label_display b_climate_txt ci_climate_txt p_climate_txt ///
    b_health_txt ci_health_txt p_health_txt ///
    b_combined_txt ci_combined_txt p_combined_txt ///
    using "$ManuscriptTables/s5_table_bh_corrected_pvalues.xlsx", ///
    sheet("Table2") sheetreplace cell(A5)

putexcel set "$ManuscriptTables/s5_table_bh_corrected_pvalues.xlsx", sheet("Table2") modify
putexcel A1 = ("S5 Table. Effects of the climate, health, and climate + health swaps on food and beverage purchases and psychological outcomes considering Bonferroni-Holm corrected p-values, n=1,201 US adults")
putexcel A3 = ("Outcomes") B3 = ("Climate swaps") E3 = ("Health swaps") H3 = ("Climate + health swaps")
putexcel B3:D3, merge hcenter
putexcel E3:G3, merge hcenter
putexcel H3:J3, merge hcenter
putexcel B4 = ("B") C4 = ("(95%CI)") D4 = ("Corrected p-value")
putexcel E4 = ("B") F4 = ("(95%CI)") G4 = ("Corrected p-value")
putexcel H4 = ("B") I4 = ("(95%CI)") J4 = ("Corrected p-value")
putexcel A3:J4, bold

forvalues i = 1/`=_N' {
    local excel_row = `i' + 4
    local sec = is_section[`i']
    local sub = is_subgroup[`i']
    if `sec'==1 | `sub'==1 {
        putexcel A`excel_row', bold
    }

    local sgc = sig_climate[`i']
    if `sgc'==1 {
        putexcel B`excel_row' C`excel_row' D`excel_row', bold
    }
    local sgh = sig_health[`i']
    if `sgh'==1 {
        putexcel E`excel_row' F`excel_row' G`excel_row', bold
    }
    local sgb = sig_combined[`i']
    if `sgb'==1 {
        putexcel H`excel_row' I`excel_row' J`excel_row', bold
    }
}

putexcel A3:J3, border(bottom)
putexcel A4:J4, border(bottom)
putexcel A3:A27, border(right)
putexcel D3:D27, border(right)
putexcel G3:G27, border(right)
putexcel J3:J27, border(right)
putexcel A3:J27, txtwrap

local noterow = _N + 6
putexcel A`noterow' = ("Abbreviations. CI, confidence interval; CO2-eq, carbon dioxide equivalents.")
putexcel A`=`noterow'+1' = ("Note. Table shows the impact of each swaps intervention compared to control (no intervention), given as the difference-in-differences from baseline to follow-up between the swaps arm and the control arm (B). Table shows effects pooled across the first and second exposure to the swaps. The p-values are corrected for multiple comparisons using the Bonferroni-Holm method, considering 3 tests per outcome (each intervention arm vs. control). Bolded effects are statistically significant, corrected p<0.05.")
