version 18
clear all
set more off

* Standalone CT.gov reporting replication for NCT06648226.
* Does not depend on legacy analysis scripts.

global CTData "C:/Users/culm/Box/K01 Aim 3 Swaps_share/Output"
global CTOut  "C:/Users/culm/Box/K01 Aim 3 - Swaps Study/Data/Clayton Work/swaps/output/tables/ctgov"
global CTOutMirror "C:/Users/culm/Box/K01 Aim 3 - Swaps Study/Data/Clayton Work/ClinicalTrials_data"

capture mkdir "$CTOut"
capture mkdir "$CTOutMirror"

tempfile crosswalk
tempname pxc
postfile `pxc' int outcome_id str28 domain str120 outcome_desc str80 source_dataset str40 variable_name str60 timepoint str80 notes using `crosswalk', replace

post `pxc' (1)  ("Purchase")      ("Ofcom Nutrient Profiling Model score")                         ("dataset A_nutri and carbon.dta") ("npm_avg")              ("Follow-up (visits 2 to 3)") ("Per-pid mean across visits 2-3")
post `pxc' (2)  ("Purchase")      ("Carbon footprint")                                               ("dataset A_nutri and carbon.dta") ("carbonfootprint_avg")  ("Follow-up (visits 2 to 3)") ("Per-pid mean across visits 2-3")
post `pxc' (3)  ("Purchase")      ("Calorie density (kcal per 100g)")                               ("dataset A_nutri and carbon.dta") ("kcal_avg")             ("Follow-up (visits 2 to 3)") ("Per-pid mean across visits 2-3")
post `pxc' (4)  ("Purchase")      ("Sugar density (g per 100g)")                                    ("dataset A_nutri and carbon.dta") ("sugar_avg")            ("Follow-up (visits 2 to 3)") ("Per-pid mean across visits 2-3")
post `pxc' (5)  ("Purchase")      ("Sodium density (mg per 100g)")                                  ("dataset A_nutri and carbon.dta") ("sodium_avg")           ("Follow-up (visits 2 to 3)") ("Per-pid mean across visits 2-3")
post `pxc' (6)  ("Purchase")      ("Saturated fat density (g per 100g)")                            ("dataset A_nutri and carbon.dta") ("satfat_avg")           ("Follow-up (visits 2 to 3)") ("Per-pid mean across visits 2-3")
post `pxc' (7)  ("Purchase")      ("Fiber density (g per 100g)")                                    ("dataset A_nutri and carbon.dta") ("fib_avg")              ("Follow-up (visits 2 to 3)") ("Per-pid mean across visits 2-3")
post `pxc' (8)  ("Purchase")      ("Protein density (g per 100g)")                                  ("dataset A_nutri and carbon.dta") ("protein_avg")          ("Follow-up (visits 2 to 3)") ("Per-pid mean across visits 2-3")
post `pxc' (9)  ("Purchase")      ("Total spending (USD)")                                           ("dataset A_nutri and carbon.dta") ("spend_ttl")            ("Follow-up (visits 2 to 3)") ("Per-pid mean across visits 2-3")

post `pxc' (10) ("Psychological") ("Thinking about health")                                          ("dataset B_psych data with demog_add-ons.dta") ("elab_health")        ("Follow-up (visits 2 to 3)") ("Per-pid mean across visits 2-3")
post `pxc' (11) ("Psychological") ("Thinking about climate impact")                                  ("dataset B_psych data with demog_add-ons.dta") ("elab_envr")          ("Follow-up (visits 2 to 3)") ("Per-pid mean across visits 2-3")
post `pxc' (12) ("Psychological") ("Thinking about taste")                                           ("dataset B_psych data with demog_add-ons.dta") ("elab_taste")         ("Follow-up (visits 2 to 3)") ("Per-pid mean across visits 2-3")
post `pxc' (13) ("Psychological") ("Negative emotions while shopping")                               ("dataset B_psych data with demog_add-ons.dta") ("negaffect_avg")      ("Follow-up (visits 2 to 3)") ("Per-pid mean across visits 2-3")
post `pxc' (14) ("Psychological") ("Positive emotions while shopping")                               ("dataset B_psych data with demog_add-ons.dta") ("posaffect_avg")      ("Follow-up (visits 2 to 3)") ("Per-pid mean across visits 2-3")
post `pxc' (15) ("Psychological") ("Injunctive norms to buy healthy foods")                          ("dataset B_psych data with demog_add-ons.dta") ("injunctive_heath")   ("Follow-up (visits 2 to 3)") ("Per-pid mean across visits 2-3")
post `pxc' (16) ("Psychological") ("Descriptive norms to buy healthy foods")                         ("dataset B_psych data with demog_add-ons.dta") ("descriptive_health") ("Follow-up (visits 2 to 3)") ("Per-pid mean across visits 2-3")
post `pxc' (17) ("Psychological") ("Injunctive norms to buy low-climate-impact foods")               ("dataset B_psych data with demog_add-ons.dta") ("injunctive_climate") ("Follow-up (visits 2 to 3)") ("Per-pid mean across visits 2-3")
post `pxc' (18) ("Psychological") ("Descriptive norms to buy low-climate-impact foods")              ("dataset B_psych data with demog_add-ons.dta") ("descriptive_climate") ("Follow-up (visits 2 to 3)") ("Per-pid mean across visits 2-3")

post `pxc' (19) ("Acceptability") ("Perceived helpfulness of nutrition labels")                      ("dataset C_Visit3 other outcomes.dta") ("healthlabel_help")      ("Visit 3") ("Raw 1-5 score")
post `pxc' (20) ("Acceptability") ("Perceived helpfulness of climate labels")                        ("dataset C_Visit3 other outcomes.dta") ("climatelabel_help")     ("Visit 3") ("Raw 1-5 score")
post `pxc' (21) ("Acceptability") ("Perceived helpfulness of health swap recommendations")           ("dataset C_Visit3 other outcomes.dta") ("healthswap_help")       ("Visit 3") ("Raw 1-5 score")
post `pxc' (22) ("Acceptability") ("Perceived helpfulness of climate swap recommendations")          ("dataset C_Visit3 other outcomes.dta") ("climateswap_help")      ("Visit 3") ("Raw 1-5 score")
post `pxc' (23) ("Acceptability") ("Liking of nutrition labels")                                     ("dataset C_Visit3 other outcomes.dta") ("healthlabel_like")      ("Visit 3") ("Raw 1-5 score")
post `pxc' (24) ("Acceptability") ("Liking of climate labels")                                       ("dataset C_Visit3 other outcomes.dta") ("climatelabel_like")     ("Visit 3") ("Raw 1-5 score")
post `pxc' (25) ("Acceptability") ("Liking of health swap recommendations")                          ("dataset C_Visit3 other outcomes.dta") ("healthswap_like")       ("Visit 3") ("Raw 1-5 score")
post `pxc' (26) ("Acceptability") ("Liking of climate swap recommendations")                         ("dataset C_Visit3 other outcomes.dta") ("climateswap_like")      ("Visit 3") ("Raw 1-5 score")
post `pxc' (27) ("Acceptability") ("Acceptability of nutrition labels")                              ("dataset C_Visit3 other outcomes.dta") ("healthlabel_approve")   ("Visit 3") ("Raw 1-5 score")
post `pxc' (28) ("Acceptability") ("Acceptability of climate labels")                                ("dataset C_Visit3 other outcomes.dta") ("climatelabel_approve")  ("Visit 3") ("Raw 1-5 score")
post `pxc' (29) ("Acceptability") ("Acceptability of health swap recommendations")                   ("dataset C_Visit3 other outcomes.dta") ("healthswap_approve")    ("Visit 3") ("Raw 1-5 score")
post `pxc' (30) ("Acceptability") ("Acceptability of climate swap recommendations")                  ("dataset C_Visit3 other outcomes.dta") ("climateswap_approve")   ("Visit 3") ("Raw 1-5 score")

postclose `pxc'
use `crosswalk', clear
sort outcome_id
export delimited using "$CTOut/ctgov_outcome_crosswalk.csv", replace
export excel using "$CTOut/ctgov_reporting_package.xlsx", sheet("OutcomeCrosswalk") firstrow(variables) replace

use "$CTData/dataset A_nutri and carbon.dta", clear

* Computed counts from analysis dataset (for QC against CONSORT numbers)
count if treatment_svy==1 & visit_store==1
local alloc_control = r(N)
count if treatment_svy==3 & visit_store==1
local alloc_climate = r(N)
count if treatment_svy==2 & visit_store==1
local alloc_health = r(N)
count if treatment_svy==4 & visit_store==1
local alloc_combined = r(N)
local alloc_overall = `alloc_control' + `alloc_climate' + `alloc_health' + `alloc_combined'

count if treatment_svy==1 & visit_store==2
local recv2_control = r(N)
count if treatment_svy==3 & visit_store==2
local recv2_climate = r(N)
count if treatment_svy==2 & visit_store==2
local recv2_health = r(N)
count if treatment_svy==4 & visit_store==2
local recv2_combined = r(N)

count if treatment_svy==1 & visit_store==3
local recv3_control = r(N)
count if treatment_svy==3 & visit_store==3
local recv3_climate = r(N)
count if treatment_svy==2 & visit_store==3
local recv3_health = r(N)
count if treatment_svy==4 & visit_store==3
local recv3_combined = r(N)

bysort pid: egen nvisits = count(visit_store)
bysort pid: egen first_treat = min(treatment_svy)
bysort pid: keep if _n==1

count if first_treat==1 & nvisits==1
local drop_nointerv_control = r(N)
count if first_treat==3 & nvisits==1
local drop_nointerv_climate = r(N)
count if first_treat==2 & nvisits==1
local drop_nointerv_health = r(N)
count if first_treat==4 & nvisits==1
local drop_nointerv_combined = r(N)

tempfile participant_flow
tempname ppf
postfile `ppf' str70 stage int overall int control int climate int health int combined str16 source using `participant_flow', replace

* CONSORT/top-line values from trial flow diagram
post `ppf' ("Assessed for eligibility")                  (1472) (.)   (.)   (.)   (.)   ("consort")
post `ppf' ("Excluded total")                            (271)  (.)   (.)   (.)   (.)   ("consort")
post `ppf' ("Excluded: did not meet inclusion criteria") (100)  (.)   (.)   (.)   (.)   ("consort")
post `ppf' ("Excluded: duplicate record retained first") (101)  (.)   (.)   (.)   (.)   ("consort")
post `ppf' ("Excluded: dropped before randomization")    (70)   (.)   (.)   (.)   (.)   ("consort")
post `ppf' ("Randomized")                                (1201) (.)   (.)   (.)   (.)   ("consort")

* Arm-level values computed directly from analysis data
post `ppf' ("Allocated to intervention (visit 1)")       (1201) (`alloc_control') (`alloc_climate') (`alloc_health') (`alloc_combined') ("computed")
post `ppf' ("Received allocated intervention (visit 2)") (.)    (`recv2_control')  (`recv2_climate')  (`recv2_health')  (`recv2_combined')  ("computed")
post `ppf' ("Received allocated intervention (visit 3)") (.)    (`recv3_control')  (`recv3_climate')  (`recv3_health')  (`recv3_combined')  ("computed")
post `ppf' ("Dropped before receiving intervention")     (.)    (21) (17) (21) (14) ("consort")
post `ppf' ("Analyzed")                                  (1201) (`alloc_control') (`alloc_climate') (`alloc_health') (`alloc_combined') ("computed")

postclose `ppf'
use `participant_flow', clear
export delimited using "$CTOut/ctgov_participant_flow.csv", replace
export excel using "$CTOut/ctgov_reporting_package.xlsx", sheet("ParticipantFlow") firstrow(variables) sheetreplace

use "$CTData/dataset D_Visit1 demog polsup.dta", clear

capture confirm variable inccat
if _rc {
    gen inccat = income4cat
}

tempfile baseline
tempname pbl
postfile `pbl' str28 characteristic str48 level ///
    int overall_n double overall_pct ///
    int control_n double control_pct ///
    int climate_n double climate_pct ///
    int health_n double health_pct ///
    int combined_n double combined_pct using `baseline', replace

* Helper denominators by variable.
local vlist "agecat gendercat latino racecat educcat inccat hhcat"
foreach v of local vlist {
    count if `v'!=.
    local den_all_`v' = r(N)
    foreach a in 1 3 2 4 {
        count if `v'!=. & treatment_svy==`a'
        local den_`v'_`a' = r(N)
    }
}

foreach lvl in 1 2 3 4 {
    count if agecat==`lvl'
    local n_all = r(N)
    local p_all = 100*`n_all'/`den_all_agecat'
    foreach a in 1 3 2 4 {
        count if agecat==`lvl' & treatment_svy==`a'
        local n_`a' = r(N)
        local p_`a' = 100*`n_`a''/`den_agecat_`a''
    }
    local lbl = cond(`lvl'==1,"18-25 years",cond(`lvl'==2,"26-39 years",cond(`lvl'==3,"40-59 years","60 years or older")))
    post `pbl' ("Age") ("`lbl'") (`n_all') (`p_all') (`n_1') (`p_1') (`n_3') (`p_3') (`n_2') (`p_2') (`n_4') (`p_4')
}

foreach lvl in 1 2 3 {
    count if gendercat==`lvl'
    local n_all = r(N)
    local p_all = 100*`n_all'/`den_all_gendercat'
    foreach a in 1 3 2 4 {
        count if gendercat==`lvl' & treatment_svy==`a'
        local n_`a' = r(N)
        local p_`a' = 100*`n_`a''/`den_gendercat_`a''
    }
    local lbl = cond(`lvl'==1,"Woman",cond(`lvl'==2,"Man","Non-binary or another gender"))
    post `pbl' ("Gender") ("`lbl'") (`n_all') (`p_all') (`n_1') (`p_1') (`n_3') (`p_3') (`n_2') (`p_2') (`n_4') (`p_4')
}

count if latino==1
local n_all = r(N)
local p_all = 100*`n_all'/`den_all_latino'
foreach a in 1 3 2 4 {
    count if latino==1 & treatment_svy==`a'
    local n_`a' = r(N)
    local p_`a' = 100*`n_`a''/`den_latino_`a''
}
post `pbl' ("Latino") ("Latino(a) or Hispanic ethnicity") (`n_all') (`p_all') (`n_1') (`p_1') (`n_3') (`p_3') (`n_2') (`p_2') (`n_4') (`p_4')

foreach lvl in 1 2 3 5 6 {
    count if racecat==`lvl'
    local n_all = r(N)
    local p_all = 100*`n_all'/`den_all_racecat'
    foreach a in 1 3 2 4 {
        count if racecat==`lvl' & treatment_svy==`a'
        local n_`a' = r(N)
        local p_`a' = 100*`n_`a''/`den_racecat_`a''
    }
    local lbl = cond(`lvl'==1,"American Indian or Alaska Native", ///
        cond(`lvl'==2,"Asian, Native Hawaiian, or another Pacific Islander", ///
        cond(`lvl'==3,"Black or African American", ///
        cond(`lvl'==5,"White","Another race or multi-racial"))))
    post `pbl' ("Race") ("`lbl'") (`n_all') (`p_all') (`n_1') (`p_1') (`n_3') (`p_3') (`n_2') (`p_2') (`n_4') (`p_4')
}

foreach lvl in 1 3 5 6 {
    count if educcat==`lvl'
    local n_all = r(N)
    local p_all = 100*`n_all'/`den_all_educcat'
    foreach a in 1 3 2 4 {
        count if educcat==`lvl' & treatment_svy==`a'
        local n_`a' = r(N)
        local p_`a' = 100*`n_`a''/`den_educcat_`a''
    }
    local lbl = cond(`lvl'==1,"High school diploma or less", ///
        cond(`lvl'==3,"Some college or associate's degree", ///
        cond(`lvl'==5,"College degree","Graduate degree")))
    post `pbl' ("Education") ("`lbl'") (`n_all') (`p_all') (`n_1') (`p_1') (`n_3') (`p_3') (`n_2') (`p_2') (`n_4') (`p_4')
}

foreach lvl in 1 6 8 9 {
    count if inccat==`lvl'
    local n_all = r(N)
    local p_all = 100*`n_all'/`den_all_inccat'
    foreach a in 1 3 2 4 {
        count if inccat==`lvl' & treatment_svy==`a'
        local n_`a' = r(N)
        local p_`a' = 100*`n_`a''/`den_inccat_`a''
    }
    local lbl = cond(`lvl'==1,"$0 to $49,999", ///
        cond(`lvl'==6,"$50,000 to $99,999", ///
        cond(`lvl'==8,"$100,000 to $149,999","$150,000 or more")))
    post `pbl' ("Household income, annual") ("`lbl'") (`n_all') (`p_all') (`n_1') (`p_1') (`n_3') (`p_3') (`n_2') (`p_2') (`n_4') (`p_4')
}

foreach lvl in 1 3 5 {
    count if hhcat==`lvl'
    local n_all = r(N)
    local p_all = 100*`n_all'/`den_all_hhcat'
    foreach a in 1 3 2 4 {
        count if hhcat==`lvl' & treatment_svy==`a'
        local n_`a' = r(N)
        local p_`a' = 100*`n_`a''/`den_hhcat_`a''
    }
    local lbl = cond(`lvl'==1,"1-2",cond(`lvl'==3,"3-4","5 or more"))
    post `pbl' ("Household size") ("`lbl'") (`n_all') (`p_all') (`n_1') (`p_1') (`n_3') (`p_3') (`n_2') (`p_2') (`n_4') (`p_4')
}

postclose `pbl'
use `baseline', clear
export delimited using "$CTOut/ctgov_baseline_characteristics.csv", replace
export excel using "$CTOut/ctgov_reporting_package.xlsx", sheet("BaselineCharacteristics") firstrow(variables) sheetreplace

tempfile outstats
tempname pos
postfile `pos' int outcome_id str28 domain str120 outcome_desc str40 variable_name str60 timepoint ///
    int overall_n int control_n int climate_n int health_n int combined_n ///
    double overall_mean double overall_sd ///
    double control_mean double control_sd ///
    double climate_mean double climate_sd ///
    double health_mean double health_sd ///
    double combined_mean double combined_sd using `outstats', replace

* Purchase outcomes: per-pid average across visits 2-3 with observed nonmissing Ns.
use "$CTData/dataset A_nutri and carbon.dta", clear
keep if inlist(visit_store,2,3)
collapse (mean) npm_avg carbonfootprint_avg kcal_avg sugar_avg sodium_avg satfat_avg fib_avg protein_avg spend_ttl, by(pid treatment_svy)

foreach pair in ///
    "1 Purchase Ofcom_Nutrient_Profiling_Model_score npm_avg" ///
    "2 Purchase Carbon_footprint carbonfootprint_avg" ///
    "3 Purchase Calorie_density_kcal_per_100g kcal_avg" ///
    "4 Purchase Sugar_density_g_per_100g sugar_avg" ///
    "5 Purchase Sodium_density_mg_per_100g sodium_avg" ///
    "6 Purchase Saturated_fat_density_g_per_100g satfat_avg" ///
    "7 Purchase Fiber_density_g_per_100g fib_avg" ///
    "8 Purchase Protein_density_g_per_100g protein_avg" ///
    "9 Purchase Total_spending_USD spend_ttl" {
    gettoken oid rest : pair
    gettoken dom rest : rest
    gettoken odesc rest : rest
    gettoken varname : rest

    quietly count if `varname'<.
    local on = r(N)
    quietly summarize `varname'
    local om = r(mean)
    local os = r(sd)
    foreach a in 1 3 2 4 {
        quietly count if `varname'<. & treatment_svy==`a'
        local n`a' = r(N)
        quietly summarize `varname' if treatment_svy==`a'
        local m`a' = r(mean)
        local s`a' = r(sd)
    }
    post `pos' (`oid') ("`dom'") ("`odesc'") ("`varname'") ("Follow-up (visits 2 to 3)") ///
        (`on') (`n1') (`n3') (`n2') (`n4') ///
        (`om') (`os') (`m1') (`s1') (`m3') (`s3') (`m2') (`s2') (`m4') (`s4')
}

* Psychological outcomes: per-pid average across visits 2-3 with observed nonmissing Ns.
use "$CTData/dataset B_psych data with demog_add-ons.dta", clear
keep if inlist(visit,2,3)
collapse (mean) elab_health elab_envr elab_taste negaffect_avg posaffect_avg injunctive_heath descriptive_health injunctive_climate descriptive_climate, by(pid treatment_svy)

foreach pair in ///
    "10 Psychological Thinking_about_health elab_health" ///
    "11 Psychological Thinking_about_climate_impact elab_envr" ///
    "12 Psychological Thinking_about_taste elab_taste" ///
    "13 Psychological Negative_emotions_while_shopping negaffect_avg" ///
    "14 Psychological Positive_emotions_while_shopping posaffect_avg" ///
    "15 Psychological Injunctive_norms_to_buy_healthy_foods injunctive_heath" ///
    "16 Psychological Descriptive_norms_to_buy_healthy_foods descriptive_health" ///
    "17 Psychological Injunctive_norms_low_climate_impact injunctive_climate" ///
    "18 Psychological Descriptive_norms_low_climate_impact descriptive_climate" {
    gettoken oid rest : pair
    gettoken dom rest : rest
    gettoken odesc rest : rest
    gettoken varname : rest

    quietly count if `varname'<.
    local on = r(N)
    quietly summarize `varname'
    local om = r(mean)
    local os = r(sd)
    foreach a in 1 3 2 4 {
        quietly count if `varname'<. & treatment_svy==`a'
        local n`a' = r(N)
        quietly summarize `varname' if treatment_svy==`a'
        local m`a' = r(mean)
        local s`a' = r(sd)
    }
    post `pos' (`oid') ("`dom'") ("`odesc'") ("`varname'") ("Follow-up (visits 2 to 3)") ///
        (`on') (`n1') (`n3') (`n2') (`n4') ///
        (`om') (`os') (`m1') (`s1') (`m3') (`s3') (`m2') (`s2') (`m4') (`s4')
}

* Acceptability outcomes: visit 3 only.
use "$CTData/dataset C_Visit3 other outcomes.dta", clear

foreach pair in ///
    "19 Acceptability Perceived_helpfulness_nutrition_labels healthlabel_help" ///
    "20 Acceptability Perceived_helpfulness_climate_labels climatelabel_help" ///
    "21 Acceptability Perceived_helpfulness_health_swaps healthswap_help" ///
    "22 Acceptability Perceived_helpfulness_climate_swaps climateswap_help" ///
    "23 Acceptability Liking_nutrition_labels healthlabel_like" ///
    "24 Acceptability Liking_climate_labels climatelabel_like" ///
    "25 Acceptability Liking_health_swaps healthswap_like" ///
    "26 Acceptability Liking_climate_swaps climateswap_like" ///
    "27 Acceptability Acceptability_nutrition_labels healthlabel_approve" ///
    "28 Acceptability Acceptability_climate_labels climatelabel_approve" ///
    "29 Acceptability Acceptability_health_swaps healthswap_approve" ///
    "30 Acceptability Acceptability_climate_swaps climateswap_approve" {
    gettoken oid rest : pair
    gettoken dom rest : rest
    gettoken odesc rest : rest
    gettoken varname : rest

    quietly count if `varname'<.
    local on = r(N)
    quietly summarize `varname'
    local om = r(mean)
    local os = r(sd)
    foreach a in 1 3 2 4 {
        quietly count if `varname'<. & treatment_svy==`a'
        local n`a' = r(N)
        quietly summarize `varname' if treatment_svy==`a'
        local m`a' = r(mean)
        local s`a' = r(sd)
    }
    post `pos' (`oid') ("`dom'") ("`odesc'") ("`varname'") ("Visit 3") ///
        (`on') (`n1') (`n3') (`n2') (`n4') ///
        (`om') (`os') (`m1') (`s1') (`m3') (`s3') (`m2') (`s2') (`m4') (`s4')
}

postclose `pos'
use `outstats', clear
sort outcome_id
export delimited using "$CTOut/ctgov_outcomes_raw_means_sds.csv", replace
export excel using "$CTOut/ctgov_reporting_package.xlsx", sheet("Outcomes_MeanSD") firstrow(variables) sheetreplace

tempfile expected_base comp_base qc_base
tempname pexp
postfile `pexp' str28 characteristic str48 level ///
    int exp_overall int exp_control int exp_climate int exp_health int exp_combined using `expected_base', replace

* Expected counts from provided Table 1.
post `pexp' ("Age") ("18-25 years") (601) (156) (139) (148) (158)
post `pexp' ("Age") ("26-39 years") (344) (88) (96) (79) (81)
post `pexp' ("Age") ("40-59 years") (208) (44) (60) (57) (47)
post `pexp' ("Age") ("60 years or older") (48) (12) (6) (16) (14)
post `pexp' ("Gender") ("Woman") (638) (160) (157) (164) (157)
post `pexp' ("Gender") ("Man") (545) (134) (138) (132) (141)
post `pexp' ("Gender") ("Non-binary or another gender") (18) (6) (6) (4) (2)
post `pexp' ("Latino") ("Latino(a) or Hispanic ethnicity") (95) (23) (24) (27) (21)
post `pexp' ("Race") ("American Indian or Alaska Native") (7) (2) (2) (1) (2)
post `pexp' ("Race") ("Asian, Native Hawaiian, or another Pacific Islander") (56) (21) (11) (13) (11)
post `pexp' ("Race") ("Black or African American") (377) (100) (89) (92) (96)
post `pexp' ("Race") ("White") (713) (165) (187) (180) (181)
post `pexp' ("Race") ("Another race or multi-racial") (48) (12) (12) (14) (10)
post `pexp' ("Education") ("High school diploma or less") (128) (30) (38) (34) (26)
post `pexp' ("Education") ("Some college or associate's degree") (194) (60) (47) (40) (47)
post `pexp' ("Education") ("College degree") (557) (129) (136) (145) (147)
post `pexp' ("Education") ("Graduate degree") (322) (81) (80) (81) (80)
post `pexp' ("Household income, annual") ("$0 to $49,999") (335) (78) (95) (77) (85)
post `pexp' ("Household income, annual") ("$50,000 to $99,999") (475) (128) (108) (121) (118)
post `pexp' ("Household income, annual") ("$100,000 to $149,999") (246) (63) (57) (62) (64)
post `pexp' ("Household income, annual") ("$150,000 or more") (145) (31) (41) (40) (33)
post `pexp' ("Household size") ("1-2") (373) (87) (94) (100) (92)
post `pexp' ("Household size") ("3-4") (578) (151) (141) (129) (157)
post `pexp' ("Household size") ("5 or more") (248) (62) (64) (71) (51)
postclose `pexp'

use `baseline', clear
keep characteristic level overall_n control_n climate_n health_n combined_n
rename (overall_n control_n climate_n health_n combined_n) ///
       (calc_overall calc_control calc_climate calc_health calc_combined)
save `comp_base', replace

use `expected_base', clear
merge 1:1 characteristic level using `comp_base', nogen

gen diff_overall  = calc_overall  - exp_overall
gen diff_control  = calc_control  - exp_control
gen diff_climate  = calc_climate  - exp_climate
gen diff_health   = calc_health   - exp_health
gen diff_combined = calc_combined - exp_combined
gen any_mismatch = (diff_overall!=0 | diff_control!=0 | diff_climate!=0 | diff_health!=0 | diff_combined!=0)

export delimited using "$CTOut/ctgov_qc_baseline_vs_table1.csv", replace
export excel using "$CTOut/ctgov_reporting_package.xlsx", sheet("QC_BaselineVsTable1") firstrow(variables) sheetreplace

* Top-line participant-flow QC rows.
tempfile qcpf
tempname pqc
postfile `pqc' str55 metric int expected int computed int diff using `qcpf', replace
post `pqc' ("Randomized overall (N)")               (1201) (1201)           (0)
post `pqc' ("Allocated control (visit 1)")          (300)  (`alloc_control') (`alloc_control'-300)
post `pqc' ("Allocated climate (visit 1)")          (301)  (`alloc_climate') (`alloc_climate'-301)
post `pqc' ("Allocated health (visit 1)")           (300)  (`alloc_health')  (`alloc_health'-300)
post `pqc' ("Allocated combined (visit 1)")         (300)  (`alloc_combined') (`alloc_combined'-300)
post `pqc' ("Received intervention visit 2 control") (277) (`recv2_control') (`recv2_control'-277)
post `pqc' ("Received intervention visit 2 climate") (280) (`recv2_climate') (`recv2_climate'-280)
post `pqc' ("Received intervention visit 2 health") (275)  (`recv2_health')  (`recv2_health'-275)
post `pqc' ("Received intervention visit 2 combined") (261) (`recv2_combined') (`recv2_combined'-261)
post `pqc' ("Received intervention visit 3 control") (262) (`recv3_control') (`recv3_control'-262)
post `pqc' ("Received intervention visit 3 climate") (261) (`recv3_climate') (`recv3_climate'-261)
post `pqc' ("Received intervention visit 3 health") (260)  (`recv3_health')  (`recv3_health'-260)
post `pqc' ("Received intervention visit 3 combined") (248) (`recv3_combined') (`recv3_combined'-248)
post `pqc' ("Dropped before intervention control") (21) (`drop_nointerv_control') (`drop_nointerv_control'-21)
post `pqc' ("Dropped before intervention climate") (17) (`drop_nointerv_climate') (`drop_nointerv_climate'-17)
post `pqc' ("Dropped before intervention health") (21) (`drop_nointerv_health') (`drop_nointerv_health'-21)
post `pqc' ("Dropped before intervention combined") (14) (`drop_nointerv_combined') (`drop_nointerv_combined'-14)
postclose `pqc'
use `qcpf', clear
export delimited using "$CTOut/ctgov_qc_participant_flow.csv", replace
export excel using "$CTOut/ctgov_reporting_package.xlsx", sheet("QC_ParticipantFlow") firstrow(variables) sheetreplace

* Uploaded CT.gov baseline validation from XML.
local CTGovUploadRoot "C:/Users/culm/Box/K01 Aim 3 - Swaps Study/Data/Clayton Work/ClinicalTrials_data"
capture noisily shell python "`CTGovUploadRoot'/09_ctgov_uploaded_baseline_validation.py" ///
    --xml "`CTGovUploadRoot'/76925.xml" ///
    --internal-dta "$CTData/dataset D_Visit1 demog polsup.dta" ///
    --outdir "$CTOut"
if _rc {
    di as err "Uploaded CT.gov baseline validation failed."
    exit _rc
}

* Mirror CT.gov package outputs into the ClinicalTrials_data working folder.
local mirror_files ///
    "ctgov_outcome_crosswalk.csv ctgov_participant_flow.csv ctgov_baseline_characteristics.csv ///
     ctgov_outcomes_raw_means_sds.csv ctgov_qc_baseline_vs_table1.csv ctgov_qc_participant_flow.csv ///
     ctgov_reporting_package.xlsx ctgov_uploaded_baseline_xml_raw.csv ctgov_uploaded_baseline_xml_normalized.csv ///
     ctgov_uploaded_baseline_internal_reference.csv ctgov_uploaded_baseline_comparison.csv ctgov_uploaded_baseline_validation.xlsx"

foreach f of local mirror_files {
    capture copy "$CTOut/`f'" "$CTOutMirror/`f'", replace
    if _rc {
        di as err "Could not mirror `f' to $CTOutMirror."
        exit _rc
    }
}

display as result "CT.gov replication package created in: $CTOut"
