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

* Run workstreams in order.
do "$project_root/02_descriptive_tables.do"
do "$project_root/03_main_analysis.do"
do "$project_root/04_moderation_analysis.do"
do "$project_root/05_sensitivity_exposure.do"

* Supplement status note.
clear
input str40 table_name str140 status_note
"S4_sample_vs_us" "Not generated in this pipeline: external US benchmark inputs not found in working data directories."
"S5_food_group_effects" "Generated from dataset A in food_group_exploratory_effects.csv."
end
export delimited using "$ManuscriptTables/supplement_status.csv", replace

* Reconciliation: Table 1 expected vs replicated.
tempfile exp_t1 comp_t1
tempname pexp
postfile `pexp' str28 characteristic str52 level int exp_overall int exp_control int exp_climate int exp_health int exp_combined using `exp_t1', replace
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

import delimited "$ManuscriptTables/manuscript_table1_baseline.csv", varnames(1) clear
keep characteristic level overall_n control_n climate_n health_n combined_n
rename (overall_n control_n climate_n health_n combined_n) (calc_overall calc_control calc_climate calc_health calc_combined)
save `comp_t1', replace

use `exp_t1', clear
merge 1:1 characteristic level using `comp_t1', nogen
gen diff_overall  = calc_overall-exp_overall
gen diff_control  = calc_control-exp_control
gen diff_climate  = calc_climate-exp_climate
gen diff_health   = calc_health-exp_health
gen diff_combined = calc_combined-exp_combined
gen any_mismatch = (diff_overall!=0 | diff_control!=0 | diff_climate!=0 | diff_health!=0 | diff_combined!=0)
export delimited using "$ManuscriptTables/reconciliation_table1.csv", replace

* Reconciliation: Table 2 (B and d).
tempfile exp_t2
tempname pt2e
postfile `pt2e' str80 outcome str12 arm double exp_b double exp_d using `exp_t2', replace
post `pt2e' ("Healthfulness, Ofcom score (1-100)") ("climate") (2.4) (0.25)
post `pt2e' ("Healthfulness, Ofcom score (1-100)") ("health") (4.7) (0.50)
post `pt2e' ("Healthfulness, Ofcom score (1-100)") ("combined") (4.0) (0.43)
post `pt2e' ("Carbon footprint, kg CO2-eq per kg") ("climate") (-3.3) (-0.42)
post `pt2e' ("Carbon footprint, kg CO2-eq per kg") ("health") (-0.4) (-0.05)
post `pt2e' ("Carbon footprint, kg CO2-eq per kg") ("combined") (-2.8) (-0.35)
post `pt2e' ("Energy density, kcal per 100g") ("climate") (-15.1) (-0.16)
post `pt2e' ("Energy density, kcal per 100g") ("health") (-16.9) (-0.18)
post `pt2e' ("Energy density, kcal per 100g") ("combined") (-17.4) (-0.18)
post `pt2e' ("Sugar density, grams per 100g") ("climate") (-0.6) (-0.08)
post `pt2e' ("Sugar density, grams per 100g") ("health") (-1.9) (-0.26)
post `pt2e' ("Sugar density, grams per 100g") ("combined") (-2.0) (-0.28)
post `pt2e' ("Sodium density, milligrams per 100g") ("climate") (-7.1) (-0.03)
post `pt2e' ("Sodium density, milligrams per 100g") ("health") (-34.6) (-0.15)
post `pt2e' ("Sodium density, milligrams per 100g") ("combined") (-27.5) (-0.12)
post `pt2e' ("Saturated fat density, grams per 100g") ("climate") (-0.8) (-0.33)
post `pt2e' ("Saturated fat density, grams per 100g") ("health") (-0.8) (-0.34)
post `pt2e' ("Saturated fat density, grams per 100g") ("combined") (-1.0) (-0.42)
post `pt2e' ("Fiber density, grams per 100g") ("climate") (0.0) (0.01)
post `pt2e' ("Fiber density, grams per 100g") ("health") (0.3) (0.25)
post `pt2e' ("Fiber density, grams per 100g") ("combined") (0.2) (0.16)
post `pt2e' ("Protein density, grams per 100g") ("climate") (-0.4) (-0.10)
post `pt2e' ("Protein density, grams per 100g") ("health") (0.3) (0.08)
post `pt2e' ("Protein density, grams per 100g") ("combined") (0.0) (0.00)
post `pt2e' ("Total spending, US dollars") ("climate") (-2.3) (-0.23)
post `pt2e' ("Total spending, US dollars") ("health") (-1.7) (-0.17)
post `pt2e' ("Total spending, US dollars") ("combined") (-1.4) (-0.14)
post `pt2e' ("Health") ("climate") (0.15) (0.10)
post `pt2e' ("Health") ("health") (0.17) (0.12)
post `pt2e' ("Health") ("combined") (0.15) (0.10)
post `pt2e' ("Climate impact") ("climate") (0.85) (0.47)
post `pt2e' ("Climate impact") ("health") (0.02) (0.01)
post `pt2e' ("Climate impact") ("combined") (0.73) (0.40)
post `pt2e' ("Taste") ("climate") (-0.02) (-0.02)
post `pt2e' ("Taste") ("health") (-0.05) (-0.06)
post `pt2e' ("Taste") ("combined") (-0.06) (-0.07)
post `pt2e' ("Negative emotions") ("climate") (0.17) (0.23)
post `pt2e' ("Negative emotions") ("health") (0.13) (0.18)
post `pt2e' ("Negative emotions") ("combined") (0.17) (0.23)
post `pt2e' ("Positive emotions") ("climate") (0.02) (0.01)
post `pt2e' ("Positive emotions") ("health") (0.09) (0.05)
post `pt2e' ("Positive emotions") ("combined") (0.02) (0.01)
post `pt2e' ("Injunctive norms to buy healthy foods") ("climate") (0.04) (0.04)
post `pt2e' ("Injunctive norms to buy healthy foods") ("health") (0.04) (0.04)
post `pt2e' ("Injunctive norms to buy healthy foods") ("combined") (0.01) (0.01)
post `pt2e' ("Descriptive norms about buying healthy foods") ("climate") (-0.07) (-0.05)
post `pt2e' ("Descriptive norms about buying healthy foods") ("health") (-0.04) (-0.03)
post `pt2e' ("Descriptive norms about buying healthy foods") ("combined") (-0.14) (-0.09)
post `pt2e' ("Injunctive norms to low-climate-impact foods") ("climate") (0.07) (0.04)
post `pt2e' ("Injunctive norms to low-climate-impact foods") ("health") (0.02) (0.01)
post `pt2e' ("Injunctive norms to low-climate-impact foods") ("combined") (0.05) (0.03)
post `pt2e' ("Descriptive norms about buying low-climate-impact foods") ("climate") (0.05) (0.03)
post `pt2e' ("Descriptive norms about buying low-climate-impact foods") ("health") (-0.07) (-0.05)
post `pt2e' ("Descriptive norms about buying low-climate-impact foods") ("combined") (0.03) (0.02)
postclose `pt2e'

import delimited "$ManuscriptTables/manuscript_table2_replication_long.csv", varnames(1) clear
keep outcome arm b d
gen rep_b = round(b,0.1)
gen rep_d = round(d,0.01)
keep outcome arm rep_b rep_d
merge 1:1 outcome arm using `exp_t2', nogen
gen diff_b = rep_b - exp_b
gen diff_d = rep_d - exp_d
gen match_b = (diff_b==0)
gen match_d = (diff_d==0)
export delimited using "$ManuscriptTables/reconciliation_table2_b_d.csv", replace

file open memo using "$ManuscriptTables/reconciliation_memo.txt", write replace
file write memo "Swaps manuscript replication reconciliation summary" _n
file write memo "Pipeline entrypoint: 06_output_exports.do (calls 02-05)" _n _n
file write memo "Known discrepancy tracked by definition rule:" _n
file write memo "- Combined arm 'Dropped before receiving intervention': CONSORT reported 14; count_visit diagnostic computes 34." _n
file close memo

display as result "Manuscript replication pipeline completed via 06_output_exports.do."