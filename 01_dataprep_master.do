

*Dataset B: Psychological outcomes
*Dataset D: Table 1, moderators, policy support
*Dataset A: Nutrition and carbon footprint outcomes
*Dataset C: Other outcomes (descriptive)

*Outputs are saved in:
cd "$Data_share/Output"


*************
**#PRE_STORE
**#*FULL Launch
**#*Pre-store V1 Qualtrics - YOUNG Adults
import excel "$Data/Input/Full Launch/Swaps+-+Pre-store+-+FULL+LAUNCH+-+Young+Adults+-+Visit+1_July+7,+2025_11.19.xlsx", case(lower) firstrow clear

destring *, replace

order prolific_pid, before (startdate)
duplicates list prolific_pid
distinct prolific_pid

count
scalar fl_prestart_ya1=r(N) //for Consort

tab consent, mi
drop if consent==0
scalar fl_preconsent_ya1 = r(N_drop) //for Consort

tab country, mi
drop if country!=1
scalar fl_precountry_ya1 = r(N_drop) //for Consort

tab visit, mi
drop if visit==.
scalar fl_prenovisit_ya1 = r(N_drop) //for Consort

tab age, mi
count if age<18 | age>25 & visit==1
drop if age<18 | age>25 & visit==1
scalar fl_preageout_ya1 = r(N_drop) //for Consort
drop if age==.
scalar fl_preagemiss_ya1 = r(N_drop) //for Consort

tab shoppingtaskinstruct, mi
drop if shoppingtaskinstruct!=2
scalar fl_preshop_ya1 = r(N_drop)

tab progress, mi
tab finished, mi
drop if progress!=100
scalar fl_preprogress_ya1 = r(N_drop) //for Consort

distinct prolific_pid
duplicates list prolific_pid

duplicates tag prolific_pid, gen(prolif_dupl)
duplicates tag age prolific_pid, gen(age_prolif_dupl)
order prolif_dupl age_prolif_dupl, after (prolific_pid)
tab prolif_dupl age_prolif_dupl
gsort -prolif_dupl prolific_pid recordeddate
distinct prolific_pid if prolif_dupl>0

duplicates drop prolific_pid, force
scalar fl_predup_ya1 = r(N_drop)

drop prolif_dupl age_prolif_dupl

count if strpos(prolific_pid, "test")
assert `r(N)'==0

gen prolif_strlen = strlen(prolific_pid)
tab prolif_strlen, mi
tab prolific_pid if prolif_strlen!=24

drop if prolif_strlen!=24
scalar fl_preoddids_ya1 = r(N_drop) //for Consort

rename * *_pre
rename prolific_pid_pre prolific_pid
rename visit_pre visit

keep prolific_pid visit age_pre consent_pre recordeddate_pre progress_pre finished_pre

gen youngadult = 1

count
scalar fl_preend_ya1=r(N) //for Consort

save "pre-store_young adults V1.dta", replace


*************
**#*Pre-store V1 Qualtrics - OLD Adults
import excel "$Data/Input/Full Launch/Swaps+-+Pre-store+-+FULL+LAUNCH+-+Old+Adults+-+Visit+1_July+7,+2025_11.22.xlsx", case(lower) firstrow clear

destring *, replace

order prolific_pid, before (startdate)
duplicates list prolific_pid
distinct prolific_pid

count
scalar fl_prestart_oa1=r(N) //for Consort

tab consent, mi
drop if consent==0 
scalar fl_preconsent_oa1 = r(N_drop) //for Consort

tab country, mi
drop if country!=1
scalar fl_precountry_oa1 = r(N_drop) //for Consort

tab visit, mi
drop if visit==.
scalar fl_prenovisit_oa1 = r(N_drop) //for Consort

tab age, mi
count if age<26 & visit==1
drop if age<26 & visit==1
scalar fl_preageout_oa1 = r(N_drop) //for Consort
drop if age==. & visit==1
scalar fl_preagemiss_oa1 = r(N_drop) //for Consort

tab shoppingtaskinstruct, mi
drop if shoppingtaskinstruct!=2
scalar fl_preshop_oa1 = r(N_drop) //for Consort

tab progress, mi
tab finished, mi
drop if progress!=100
scalar fl_preprogress_oa1 = r(N_drop) //for Consort

distinct prolific_pid
duplicates list prolific_pid

duplicates tag prolific_pid, gen(prolif_dupl)
duplicates tag age prolific_pid, gen(age_prolif_dupl)
order prolif_dupl age_prolif_dupl, after (prolific_pid)
tab prolif_dupl age_prolif_dupl
gsort -prolif_dupl prolific_pid recordeddate
distinct prolific_pid if prolif_dupl>0


duplicates drop prolific_pid, force
scalar fl_predup_oa1 = r(N_drop) //for Consort

drop prolif_dupl age_prolif_dupl

count if strpos(prolific_pid, "test")
assert `r(N)'==0

gen prolif_strlen = strlen(prolific_pid)
tab prolif_strlen, mi
tab prolific_pid if prolif_strlen!=24

drop if prolif_strlen!=24
scalar fl_preoddids_oa1 = r(N_drop) //for Consort

rename * *_pre
rename prolific_pid_pre prolific_pid
rename visit_pre visit

keep prolific_pid visit age_pre consent_pre recordeddate_pre progress_pre finished_pre

gen youngadult = 0

count
scalar fl_preend_oa1=r(N) //for Consort

save "pre-store_old adults V1.dta", replace


*************
**#*APPEND Pre-store V1 data for Young and Old adults

use "pre-store_young adults V1.dta", clear
append using "pre-store_old adults V1.dta"

distinct prolific_pid

tab youngadult, mi

save "pre-store_V1.dta", replace


*************
**#*Pre-store V2 Qualtrics
import excel "$Data/Input/Full Launch/Swaps+-+Pre-store+-+FULL+LAUNCH+-+Visit+2_July+7,+2025_11.20.xlsx", case(lower) firstrow clear

destring *, replace

order prolific_pid, before (startdate)
duplicates list prolific_pid
distinct prolific_pid

count
scalar fl_prestart_all2=r(N) //for Consort

tab visit, mi
drop if visit==.
scalar fl_prenovisit_all2=r(N_drop) //for Consort

tab shoppingtaskinstruct, mi
drop if shoppingtaskinstruct!=2
scalar fl_preshop_all2 = r(N_drop) //for Consort

tab progress, mi
tab finished, mi
drop if progress!=100
scalar fl_preprogress_all2 = r(N_drop) //for Consort

distinct prolific_pid
duplicates list prolific_pid
duplicates report prolific_pid
duplicates tag prolific_pid, gen(prolif_dupl)

order prolif_dupl, after (prolific_pid)
tab prolif_dupl, mi
gsort -prolif_dupl prolific_pid recordeddate
distinct prolific_pid if prolif_dupl>0

duplicates drop prolific_pid, force
scalar fl_predup_all2 = r(N_drop) //for Consort

drop prolif_dupl

count if strpos(prolific_pid, "test")
assert `r(N)'==0

gen prolif_strlen = strlen(prolific_pid)
tab prolif_strlen, mi
tab prolific_pid if prolif_strlen!=24
drop if prolif_strlen!=24
scalar fl_preoddids_all2 = r(N_drop) //for Consort

rename * *_pre
rename prolific_pid_pre prolific_pid
rename visit_pre visit


keep prolific_pid visit treatment_pre recordeddate_pre progress_pre finished_pre

count
scalar fl_preend_all2=r(N) //for Consort

save "pre-store_V2.dta", replace

*************
**#*Pre-store V3 Qualtrics
import excel "$Data/Input/Full Launch/Swaps+-+Pre-store+-+FULL+LAUNCH+-+Visit+3_July+7,+2025_11.20.xlsx", case(lower) firstrow clear

destring *, replace

order prolific_pid, before (startdate)
duplicates list prolific_pid
distinct prolific_pid

count
scalar fl_prestart_all3=r(N) //for Consort

tab visit, mi
drop if visit==.
scalar fl_prenovisit_all3 = r(N_drop) //for Consort

tab shoppingtaskinstruct, mi
drop if shoppingtaskinstruct!=2
scalar fl_preshop_all3 = r(N_drop) //for Consort

tab progress, mi
tab finished, mi
drop if progress!=100
scalar fl_preprogress_all3 = r(N_drop) //for Consort

distinct prolific_pid
duplicates list prolific_pid
duplicates report prolific_pid
duplicates tag prolific_pid, gen(prolif_dupl)

order prolif_dupl, after (prolific_pid)
distinct prolific_pid if prolif_dupl>0
gsort -prolif_dupl prolific_pid recordeddate

duplicates drop prolific_pid, force
scalar fl_predup_all3 = r(N_drop) //for Consort

drop prolif_dupl

count if strpos(prolific_pid, "test")
assert `r(N)'==0

gen prolif_strlen = strlen(prolific_pid)
tab prolif_strlen, mi
tab prolific_pid if prolif_strlen!=24
drop if prolif_strlen!=24
scalar fl_preoddids_all3 = r(N_drop) //for Consort

rename * *_pre
rename prolific_pid_pre prolific_pid
rename visit_pre visit


keep prolific_pid visit treatment_pre recordeddate_pre progress_pre finished_pre

count
scalar fl_preend_all3=r(N) //for Consort

save "pre-store_V3.dta", replace


*************
**#*MINI Launch (ML)

**#ML) Pre-store Qualtrics - YOUNG Adults for V1, ALL adults for V2, V3
import excel "$Data/Input/MiniLaunch/Swaps+-+Pre-store+-+SOFT+LAUNCH+-+Young+Adults_June+18,+2025_09.14.xlsx", case(lower) firstrow clear

destring *, replace

order prolific_pid visit, before (startdate)
sort prolific_pid visit

count if visit==1 | visit==.
scalar ml_prestart_ya1=r(N) //for Consort
count if visit==2
scalar ml_prestart_all2=r(N) //for Consort
count if visit==3
scalar ml_prestart_all3=r(N) //for Consort

// do not drop all missing because visits 2 and 3 are marked as missing.
tab consent, mi
table consent visit, mi
count if consent!=1 & visit==1 //consent is only asked during Visit 1
drop if consent!=1 & visit==1
scalar ml_preconsent_ya1 = r(N_drop) //for Consort

// do not drop all missing because visits 2 and 3 are marked as missing.
tab country, mi
table country visit, mi
drop if country!=1 & visit==1
scalar ml_precountry_ya1 = r(N_drop) //for Consort

tab visit, mi
drop if visit==.
scalar ml_prenovisit_ya = r(N_drop) //for Consort

tab age, mi
table age visit, mi
count if age<18 | age>25 & visit==1
drop if age<18 | age>25 & visit==1
scalar ml_preageout_ya1 = r(N_drop) //for Consort
drop if age==. & visit==1
scalar ml_preagemiss_ya1 = r(N_drop) //for Consort

tab shoppingtaskinstruct visit, mi
drop if shoppingtaskinstruct!=2 & visit==1
scalar ml_preshop_ya1 = r(N_drop) 
drop if shoppingtaskinstruct!=2
scalar ml_preshop_ya3 = r(N_drop) //only v3 - for Consort

tab progress visit, mi
tab finished visit, mi
drop if progress!=100 &visit==1
scalar ml_preprogress_ya1 = r(N_drop)
drop if progress!=100
scalar ml_preprogress_ya3 = r(N_drop) //only v3 - for Consort

distinct prolific_pid
table prolific_pid visit, mi
duplicates list prolific_pid visit

duplicates tag prolific_pid visit, gen(dup_pre)
order dup_pre, after (prolific_pid)
gsort -dup_pre prolific_pid recordeddate
distinct prolific_pid if dup_pre>0
tab dup_pre visit

duplicates drop prolific_pid if visit==1, force
scalar ml_predup_ya1 = r(N_drop) //for Consort

duplicates drop prolific_pid if visit==2, force
scalar ml_predup_ya2 = r(N_drop) //for Consort

duplicates drop prolific_pid if visit==3, force
scalar ml_predup_ya3 = r(N_drop) //for Consort

duplicates drop prolific_pid visit, force
scalar ml_predup_ya = r(N_drop) //for Consort

drop dup_pre

count if strpos(prolific_pid, "test")
assert `r(N)'==0

gen prolif_strlen = strlen(prolific_pid)
tab prolif_strlen, mi
tab prolific_pid if prolif_strlen!=24
drop if prolif_strlen!=24 & visit==1
scalar ml_preoddids_ya1 = r(N_drop) //for Consort
drop if prolif_strlen!=24
scalar ml_preoddids_ya = r(N_drop) //for Consort

rename * *_pre
rename prolific_pid_pre prolific_pid
rename visit_pre visit

tab treatment_pre visit

keep prolific_pid visit treatment_pre age_pre consent_pre recordeddate_pre progress_pre finished_pre

gen youngadult = 1 if age_pre>=18 & age_pre<=25 & visit==1

sort prolific_pid visit

count if visit==1
scalar ml_preend_ya1=r(N) //for Consort
count if visit==2
scalar ml_preend_all2=r(N) //for Consort
count if visit==3
scalar ml_preend_all3=r(N) //for Consort

save "$Data_share/Output/ML_pre-store data_young adults.dta", replace


*************
**#ML) Pre-store Qualtrics - OLD Adults V1 only
import excel "$Data/Input/MiniLaunch/Swaps+-+Pre-store+-+SOFT+LAUNCH+-+Old+Adults_June+18,+2025_09.15.xlsx", case(lower) firstrow clear

destring *, replace

order prolific_pid visit, before (startdate)
sort prolific_pid visit

count
scalar ml_prestart_oa1=r(N) //for Consort

// do not drop missing because visits 2 and 3 are marked as missing.
tab consent, mi
table consent visit, mi
count if consent!=1 & visit==1 //consent is only asked during Visit 1
drop if consent!=1 & visit==1
scalar ml_preconsent_oa1 = r(N_drop) //for Consort

// do not drop missing because visits 2 and 3 are marked as missing.
tab country, mi
table country visit, mi
drop if country!=1
scalar ml_precountry_oa1 = r(N_drop) //for Consort


tab visit, mi
drop if visit==.
scalar ml_prenovisit_oa1 = r(N_drop)

tab age, mi
table age visit, mi
drop if age<26 & visit==1
scalar ml_preageout_oa1 = r(N_drop) //for Consort
drop if age==. & visit==1
scalar ml_preagemiss_oa1 = r(N_drop) //for Consort

tab shoppingtaskinstruct, mi
drop if shoppingtaskinstruct!=2
scalar ml_preshop_oa1 = r(N_drop)

tab progress, mi
tab finished, mi
drop if progress!=100
scalar ml_preprogress_oa1 = r(N_drop)

distinct prolific_pid
table prolific_pid visit, mi //only V1
duplicates list prolific_pid visit

duplicates tag prolific_pid visit, gen(dup_pre)
order dup_pre, after (prolific_pid)
gsort -dup_pre prolific_pid recordeddate
distinct prolific_pid if dup_pre>0

duplicates drop prolific_pid visit, force
scalar ml_predup_oa1 = r(N_drop) //for Consort

drop dup_pre

count if strpos(prolific_pid, "test")
assert `r(N)'==0

gen prolif_strlen = strlen(prolific_pid)
tab prolif_strlen, mi
tab prolific_pid if prolif_strlen!=24
drop if prolif_strlen!=24
scalar ml_preoddids_oa1 = r(N_drop) //for Consort

rename * *_pre
rename prolific_pid_pre prolific_pid
rename visit_pre visit

tab treatment_pre visit

keep prolific_pid visit treatment_pre age_pre consent_pre recordeddate_pre progress_pre finished_pre

gen youngadult = 0

count if visit==1
scalar ml_preend_oa1=r(N) //for Consort

save "ML_pre-store data_old adults.dta", replace


*************
**#ML) Append Pre-store data for Young and Old adults - append w full launch

use "ML_pre-store data_young adults.dta", clear
append using "ML_pre-store data_old adults.dta"

count if visit==1
count if visit==2
count if visit==3
tab visit, mi

distinct prolific_pid
table visit youngadult, mi
table treatment visit, mi

gen source = "ml"

save "ML_pre-store data_all.dta", replace


*************
**#*APPEND all Pre-store

use "pre-store_V1.dta", clear

append using "pre-store_V2.dta"

append using "pre-store_V3.dta"

append using "ML_pre-store data_all.dta"

sort prolific_pid visit

distinct prolific_pid if visit==1
distinct prolific_pid if visit==2
distinct prolific_pid if visit==3

/*duplicates tag prolific_pid visit, gen(visit_prolif_dupl)
tab visit_prolif_dupl, mi
drop visit_prolif_dupl
*/

save "pre-store_all.dta", replace

*************


use "pre-store_all.dta", clear

reshape wide progress_pre finished_pre recordeddate_pre consent_pre age_pre youngadult treatment_pre, i(prolific_pid) j(visit)

egen check_progress = rownonmiss(progress_pre1 progress_pre2 progress_pre3)

tab check_progress
sort check_progress

tab finished_pre1 if check_progress==1
tab finished_pre2 if check_progress==1
tab finished_pre3 if check_progress==1

tab finished_pre1 finished_pre2 if check_progress==2
tab finished_pre1 finished_pre3 if check_progress==2
tab finished_pre2 finished_pre3 if check_progress==2



*************
**#*PID, YA, age Masterlist

use "pre-store_all.dta", clear

keep prolific_pid youngadult age_pre

rename youngadult youngadult_all
rename age_pre age_all

gsort prolific_pid age_all youngadult_all

duplicates drop prolific_pid, force

tab age_all youngadult_all, mi
tab youngadult_all, mi
mdesc age_all youngadult_all


gen pid=_n

save "pid_masterlist.dta", replace


*************
**#*MERGE Pre-store + PID

use "pre-store_all.dta", clear

merge m:1 prolific_pid using "pid_masterlist.dta", gen(merge_pid)

drop merge_pid

drop youngadult
drop age_pre

save "pre-store_all_long.dta", replace

**************************
**************************
**#*POST-STORE
**#*Post-store Qualtrics V1
import excel "$Data/Input/Full Launch/Swaps+-+Post-store+-+FULL+LAUNCH+-+Visit+1_July+7,+2025_11.24.xlsx", firstrow case(lower) clear

destring *, replace

distinct prolific_pid

count
scalar fl_posstart_all1=r(N) //for Consort

tab progress, mi
tab progress treatment, mi
drop if progress!=100
scalar fl_posprogress_all1 = r(N_drop) //for Consort

duplicates list prolific_pid
/*duplicates tag prolific_pid, gen(dup)
order dup prolific_pid visit treatment, before (status)
gsort -dup prolific_pid recordeddate

duplicates drop prolific_pid, force
*/

count if strpos(prolific_pid, "test")
tab prolific_pid if strpos(prolific_pid, "test")
drop if strpos(prolific_pid, "test")

gen prolif_strlen = strlen(prolific_pid)
tab prolif_strlen, mi
tab prolific_pid if prolif_strlen!=24
drop if prolif_strlen!=24

drop status durationinseconds finished responseid distributionchannel-q_relevantidlaststartdate

rename treatment treatment_post1

save "post-store_V1.dta", replace


*************
**#*Post-store Qualtrics V2
import excel "$Data/Input/Full Launch/Swaps+-+Post-store+-+FULL+LAUNCH+-+Visit+2_July+7,+2025_11.24.xlsx", firstrow case(lower) clear

destring *, replace

distinct prolific_pid

count
scalar fl_posstart_all2=r(N) //for Consort

tab progress, mi

duplicates list prolific_pid
duplicates tag prolific_pid, gen(dup)
order dup prolific_pid visit, before (status)
gsort -dup prolific_pid recordeddate

duplicates drop prolific_pid, force
scalar fl_posdup_all2 = r(N_drop) //for Consort

count if strpos(prolific_pid, "test")
tab prolific_pid if strpos(prolific_pid, "test")
drop if strpos(prolific_pid, "test")
scalar fl_posoddids_all2 = r(N_drop) //for Consort

gen prolif_strlen = strlen(prolific_pid)
tab prolif_strlen, mi
tab prolific_pid if prolif_strlen!=24
drop if prolif_strlen!=24

drop status durationinseconds finished responseid distributionchannel-q_relevantidlaststartdate

save "post-store_V2.dta", replace


*************
**#*Post-store Qualtrics V3

import excel "$Data/Input/Full Launch/Swaps+-+Post-store+-+FULL+LAUNCH+-+Visit+3_July+7,+2025_11.23.xlsx", firstrow case(lower) clear

destring *, replace

distinct prolific_pid

count
scalar fl_posstart_all3=r(N) //for Consort

tab progress, mi

duplicates list prolific_pid
duplicates tag prolific_pid, gen(dup)
order dup prolific_pid visit, before (status)
gsort -dup prolific_pid recordeddate

duplicates drop prolific_pid, force
scalar fl_posdup_all3 = r(N_drop) //for Consort

count if strpos(prolific_pid, "test")
tab prolific_pid if strpos(prolific_pid, "test")
drop if strpos(prolific_pid, "test")

gen prolif_strlen = strlen(prolific_pid)
tab prolif_strlen, mi
tab prolific_pid if prolif_strlen!=24
drop if prolif_strlen!=24

drop status durationinseconds finished responseid distributionchannel-q_relevantidlaststartdate

save "post-store_V3.dta", replace


*************
**#ML) Post-store Qualtrics ML

import excel "$Data/Input/MiniLaunch/Swaps+-+Post-store+-+SOFT+LAUNCH_June+18,+2025_09.16.xlsx", firstrow case(lower) clear

destring *, replace

order prolific_pid visit, before (startdate)
sort prolific_pid visit

distinct prolific_pid
count if visit==1
scalar ml_posstart_all1=r(N) //for Consort
count if visit==2
scalar ml_posstart_all2=r(N) //for Consort
count if visit==3
scalar ml_posstart_all3=r(N) //for Consort

table progress treatment if visit==1, mi
drop if progress!=100 & visit==1
scalar ml_posprogress_all1 = r(N_drop)

duplicates list prolific_pid visit
duplicates tag prolific_pid visit, gen(dup)
order dup, after (prolific_pid)
gsort -dup prolific_pid recordeddate

scalar ml_posdupl_oa = 2 //for Consort - dropped manually below


gen date_rec = string(recordeddate, "%tc")
order date_rec, before(recordeddate)

drop if prolific_pid=="66d7cf0ada443c5b0f3fe9d9" & date_rec=="26may2025 08:22:56"
drop if prolific_pid=="677ae65331aabbf95a6cf744" & date_rec=="21may2025 09:58:33"

replace visit=3 if prolific_pid=="67c893a3e6c0b7f7a5f45428" & date_rec=="21may2025 08:24:36"
drop if prolific_pid=="67c893a3e6c0b7f7a5f45428" & date_rec=="28may2025 13:40:43"

duplicates list prolific_pid visit

count if strpos(prolific_pid, "test")
tab prolific_pid if strpos(prolific_pid, "test")
drop if strpos(prolific_pid, "test")

gen prolif_strlen = strlen(prolific_pid)
tab prolif_strlen, mi
tab prolific_pid if prolif_strlen!=24
drop if prolif_strlen!=24

drop date_rec
drop status durationinseconds finished responseid distributionchannel-q_relevantidlaststartdate

rename treatment treatment_post1

gen source = "ml"

tab treatment_post1 visit

save "ML_post-store data.dta", replace

*************
**#*APPEND all Post-store visits

use "post-store_V1.dta", clear
recast str668 why_accept_health //match characters as V2
recast str542 why_accept_climate //match characters as V2

append using "post-store_V2.dta"

append using "post-store_V3.dta"

append using "ML_post-store data.dta"


distinct prolific_pid if visit==1
distinct prolific_pid if visit==2
distinct prolific_pid if visit==3
tab visit, mi

duplicates list prolific_pid visit
/*duplicates tag prolific_pid visit, gen(visit_prolif_dupl)
tab visit_prolif_dupl, mi
drop visit_prolif_dupl
duplicates drop prolific_pid visit, force
*/

drop dup prolif_strlen

save "post-store_all_long.dta", replace


*************
**#*PRODUCT Dataset

* Private-only raw rebuild note: this import uses restricted/licensed product data, so the public GitHub entrypoint skips `01_dataprep_master.do` and relies on prepared files in data/share/Output instead.
import delimited "$Data/Launch 2025/Product info/product_dataset-no kcal100.csv", varnames(1) bindquote(strict) clear 

destring *, replace

gen kcal_100g = (calories/serving_g_ofcom_calculation)*100

gen kcal_100g_check = (energy_100g*0.239006)
gen diff_kcal100 = kcal_100g-kcal_100g_check
count if diff_kcal100>=0.0001 //none
count if diff_kcal100<=-0.001 

keep product_id name brand_name overline_description full_price sale_price servings_per_container serving_numb serving_unit serving_size_org ///
calories total_fat saturated_fat sodium total_carbohydrate dietary_fiber sugars added_sugars protein ///
serving_cleaned_grams total_grams npm_100 food_group upc ///
serving_grams_reconst total_grams_reconst ///
saturated_fat_g sugars_g added_sugars_g dietary_fiber_g protein_g sodium_mg serving_g_ofcom_calculation ///
kcal_100g energy_100g sat_fat_100g sugar_100g fib_100g protein_100g sodium_100g ///
k01aim3_beverages k01aim3_meals k01aim3_liquid_dairy k01aim3_solid_dairy k01aim3_proteins k01aim3_soups k01aim3_sweets_snacks k01aim3_label_group /// 
carbonfootprint_g health_label climate_label

save "product data-kcal100.dta", replace
*/

*************
**#*STORE
**#*Store V1
import delimited "$Data/Launch 2025/Visit 1 - FULL LAUNCH/purchases_dataset_visit1.csv", varnames(1) bindquote(strict) clear

destring *, replace

tab treatment_store_exported, mi
drop treatment_store_exported

tostring swapoffered swappedfor addedfrom, replace
recast str5 swapoffered
recast str7 swappedfor
recast str19 addedfrom

distinct prolific_pid

count if strpos(prolific_pid, "test")
tab prolific_pid if strpos(prolific_pid, "test")
assert `r(N)'==0

gen prolif_strlen = strlen(prolific_pid)
tab prolif_strlen, mi
tab prolific_pid if prolif_strlen!=24
assert `r(N)'==0

gen visit=1

save "visit 1.dta", replace

*************
**#*Store V2
import delimited "$Data/Launch 2025/Visit 2 - FULL LAUNCH/purchases_dataset_visit2.csv", varnames(1) bindquote(strict) clear

destring *, replace

distinct prolific_pid

rename treatment treatment_store

count if strpos(prolific_pid, "test")
tab prolific_pid if strpos(prolific_pid, "test")
assert `r(N)'==0

gen prolif_strlen = strlen(prolific_pid)
tab prolif_strlen, mi
tab prolific_pid if prolif_strlen!=24
assert `r(N)'==0

gen visit=2

save "visit 2.dta", replace

*************
**#*Store V3
import delimited "$Data/Launch 2025/Visit 3 - FULL LAUNCH/purchases_dataset_visit3.csv", varnames(1) bindquote(strict) clear

destring *, replace

distinct prolific_pid

rename treatment treatment_store

count if strpos(prolific_pid, "test")
tab prolific_pid if strpos(prolific_pid, "test")
assert `r(N)'==0

gen prolif_strlen = strlen(prolific_pid)
tab prolif_strlen, mi
tab prolific_pid if prolif_strlen!=24
assert `r(N)'==0

gen visit=3

save "visit 3.dta", replace


*************

*************
**#1) APPEND visits 1,2,3 into one store dataset
use "visit 1.dta", clear

append using "visit 2.dta"

append using "visit 3.dta"


drop prolif_strlen

//suffix _v for visits (to distinguish from product info dataset)
rename * *_v
rename prolific_pid_v prolific_pid
rename product_id_v product_id
rename visit_v visit //same name for merging

gen time = .
	replace time = 0 if visit==1
	replace time = 1 if visit==2
	replace time = 1 if visit==3

replace swapoffered_v= "" if swapoffered_v== "."
replace swappedfor_v= "" if swappedfor_v== "."


distinct prolific_pid
distinct prolific_pid if visit==1
scalar storect_v1 = r(ndistinct)
distinct prolific_pid if visit==2
scalar storect_v2 = r(ndistinct)
distinct prolific_pid if visit==3
scalar storect_v3 = r(ndistinct)

save "Int A1_all store visits.dta", replace

*************
**#2) MERGE store data with product info

use "Int A1_all store visits.dta", clear
merge m:1 product_id using "product data-kcal100.dta", gen(merge_product)


drop if merge_product!=3

rename visit visit_store

save "Int A2_store and product.dta", replace


//////
**#Directory
cd "$Data_share/Output"

**#MERGING of datasets:

***********
**#*MERGE pre-store + store data - drop records without shopping data

use "pre-store_all_long.dta", clear
merge 1:m prolific_pid visit using "Int A1_all store visits.dta", gen(merge_store)

sort merge_store prolific_pid

tab prolific_pid if merge_store==1
distinct prolific_pid if merge_store==1
tab visit if merge_store==1

tab prolific_pid if merge_store==2
distinct prolific_pid if merge_store==2

distinct prolific_pid if merge_store==3

gsort merge_store prolific_pid visit
table visit treatment_pre if merge_store==1, mi

tab treatment_pre, mi

drop if merge_store==1 & visit==1
scalar nostore_v1 = r(N_drop)
drop if merge_store==1
scalar nostore_rest = r(N_drop)

order treatment_store_v, after(treatment_pre)
drop product_id-time

distinct prolific_pid
duplicates drop prolific_pid visit, force

distinct prolific_pid if visit==1
distinct prolific_pid if visit==2
distinct prolific_pid if visit==3


save "pre-store_for merge.dta", replace

////

**#*Dataset B: Psychological outcomes
	
use "pre-store_for merge.dta", clear

merge 1:1 prolific_pid visit using "post-store_all_long.dta", gen(merge_post)

order merge_post merge_store, after(prolific_pid)
sort merge_post merge_store prolific_pid

distinct prolific_pid if merge_post==1
list prolific_pid if merge_post==1
tab visit if merge_post==1
drop if merge_post==1
scalar nopost_v1 = r(N_drop) //for Consort

distinct prolific_pid if merge_post==2
list prolific_pid if merge_post==2
tab visit if merge_post==2
drop if merge_post==2

distinct prolific_pid if merge_post==3

distinct prolific_pid if visit==1
scalar randomized1 = r(ndistinct) //for Consort
distinct prolific_pid if visit==2
distinct prolific_pid if visit==3
tab visit, mi

mvdecode *, mv(-99)

order pid prolific_pid visit treatment_store_v treatment_pre treatment_post1 progress_pre progress consent_pre age_all youngadult_all recordeddate_pre recordeddate merge_store merge_post finished_pre, before(startdate)

drop merge_store

save "dataset B_psych data.dta", replace

//////

**#Check Randomization
use "dataset B_psych data.dta", clear

gsort -merge_post prolific_pid visit


gen treatment_svy = .
replace treatment_svy = treatment_pre if visit==2 | visit==3
replace treatment_svy = treatment_post1 if visit==1
order treatment_svy, before(treatment_store_v)

table treatment_svy treatment_store_v if visit==2, mi
table treatment_svy treatment_store_v if visit==3, mi

table treatment_svy treatment_post1 if visit==1, mi

bysort prolific_pid: gen trt_same = 1 if treatment_svy[1] == treatment_svy[_N] & treatment_svy!=.
order trt_same, before(treatment_svy)
gsort -trt_same prolific_pid visit

bysort prolific_pid: egen n_rows = count(visit)
order n_rows, before(trt_same)
gsort n_rows prolific_pid visit
tab n_rows visit, mi

distinct prolific_pid if n_rows==1
distinct prolific_pid if n_rows==2
distinct prolific_pid if n_rows==3

sort prolific_pid visit

tab treatment_svy visit, mi

drop treatment_store_v treatment_pre treatment_post1

count if treatment_svy==1 & visit==1
scalar arm1ct = r(N)
count if treatment_svy==2 & visit==1
scalar arm2ct = r(N)
count if treatment_svy==3 & visit==1
scalar arm3ct = r(N)
count if treatment_svy==4 & visit==1
scalar arm4ct = r(N)

save "dataset B_psych data.dta", replace

*************
**#*Demographic variables

use "dataset B_psych data.dta", clear

/*
Age
18-25 years
26-39 years
40-59 years
60 years or older
*/

tab age_all, mi

recode age_all (18/25=1 "18-25") (26/39=2 "26-39") (40/59=3 "40-59") (60/100=4 "60+"), gen(agecat)

/*
Gender
1=Woman
2=Man
3=Non-binary
4=Prefer to self-describe:_____
*/

tab gender visit, mi
tab gender_4_text, mi //none

recode gender (1=1 "Woman") (2=2 "Man") (3/4=3 "Non-binary or another gender"), gen(gendercat)

/*
Race and ethnicity
Codebook:
1=American Indian or Alaska Native
2=Asian
3=Black or African American
4=Native Hawaiian or Other Pacific Islander
5=White
6=Another race:________

Table 1:
American Indian or Alaska Native
Asian or Pacific Islander
Black or African American
White
Another race or multi-racial
*/

tab race_6_text, mi

replace race_1=1 if prolific_pid=="67ef1ad6f213fd190617ec00"
replace race_6=. if prolific_pid=="67ef1ad6f213fd190617ec00"

egen totalraces = rowtotal(race_1 race_2 race_3 race_4 race_5 race_6)
order totalraces, before(educ)

	gen racecat=.
		replace racecat = 1 if race_1==1 & totalraces==1 //AmInd only
		replace racecat = 2 if race_2==1 & totalraces==1 //Asian only
		replace racecat = 3 if race_3==1 & totalraces==1 //Black only
		replace racecat = 2 if race_4==1 & totalraces==1 //Nat. Hawaiian or Pac. Islander only - combined w Asian
		replace racecat = 5 if race_5==1 & totalraces==1 //White only
		replace racecat = 6 if race_6==1 //Other & multi-racial
		replace racecat = 6 if totalraces>=2 & totalraces!=. //Multi-racial

tab racecat visit, mi

label define racelab 1 "Amer Ind AK Native" 2 "Asian & NHPI" 3 "Black" 5 "White" 6 "Another or more than 1"
label values racecat racelab
tab racecat, mi	
		
		
tab latino, mi

/*
Education
Codebook:
1=Less than high school 
2=High school graduate (or GED)
3=Some college or technical school
4=Associate's degree
5=Bachelor's degree
6=Graduate or professional degree

Table 1
High school diploma or less
Some college
College degree
Graduate degree
*/

tab educ, mi

recode educ (1/2=1 "HS or less") (3/4=3 "Some college or Associate's") (5=5 "Bachelor's") (6=6 "Graduate"), gen(educcat)

tab educcat visit, mi

/*
Household income, annual

Codebook:
1=Less than $10,000
2=$10,000 to $14,999
3=$15,000 to $24,999
4=$25,000 to $34,999
5=$35,000 to $49,999
6=$50,000 to $74,999
7=$75,000 to $99,999
8=$100,000 to $149,999
9=$150,000 to $199,999
10=$200,000 or more

Table 1
1 to 5
6 and 7
8
9 and 10
*/

tab income_10cat visit, mi

recode income_10cat (1/5=1 "<$10K-49,999") (6/7=6 "$50K-99,999") (8=8 "$100K-149,999") (9/10=9 "$150K+"), gen(income4cat)

tab income4cat visit, mi

/*
Household size
Table 1
1-2
3-4 
5 or more
*/

tab hhsize_num visit, mi

recode hhsize_num (1/2=1 "1-2") (3/4=3 "3-4") (5/14=5 "5+"), gen(hhcat)

tab hhcat visit, mi



label def treatment_lab 1 "control" 2 "health" 3 "environment" 4 "combined"
label values treatment_svy treatment_lab

foreach outcome in healthlabel climatelabel healthswap climateswap {
	gen rnotice_`outcome' = 1 if notice_`outcome'==1
	replace rnotice_`outcome' = 0 if notice_`outcome' == 2 | notice_`outcome'==0
}


egen negaffect_avg = rowmean(affect_guilty affect_ashamed affect_worry)
egen posaffect_avg = rowmean(affect_inspired affect_proud affect_reassured)

rename elab_tatse elab_taste 

save "dataset B_psych data with demog_add-ons.dta", replace


/////

**#*Dataset D: Table 1 and moderators

use "dataset B_psych data with demog_add-ons.dta", clear
	
keep if visit==1

drop mentalload_1-descriptive_climate ttmhealth ttmclimate
drop healthlabel_help-climateswap_approve //only asked in V3

save "dataset D_Visit1 demog polsup.dta", replace

*************
**#*Dataset C: Other outcomes (descriptive) *_help, *_like, *_approve
	
use "dataset B_psych data with demog_add-ons.dta", clear

keep if visit==3

distinct pid

ds *_help*
ds *_like*
ds *_approve*

keep pid-recordeddate *_help* *_like* *_approve*

save "$Data_share/Output/dataset C_Visit3 other outcomes.dta", replace

*************

**#*Dataset A - pt2: Nutrition and carbon footprint outcomes



use "dataset D_Visit1 demog polsup.dta", clear

merge 1:m prolific_pid using "Int A2_store and product.dta", gen(merge_store2)

order merge_store2, after (merge_post)

distinct prolific_pid if merge_store2==2
duplicates list prolific_pid if merge_store2==2
tab visit_store if merge_store2==2, mi

drop if merge_store2==2

drop visit //use visit_store (visit was filtered to 1 for dataset D)
drop polsup* attitude_incarc*

distinct pid
distinct prolific_pid if pid==.
distinct prolific_pid if pid!=.
distinct prolific_pid if pid!=. & visit==1

/////

/*
1.	Ofcom Nutrient Profiling Model score 
2.	Carbon footprint 
3.	Calorie density, kcal per 100g
4.	Sugar density, g per 100g
5.	Sodium density, mg per 100g
6.	Saturated fat density, g per 100g
7.	Fiber density, g per 100g
8.	Protein density, g per 100g
*/

rename sat_fat_100g satfat_100g

foreach var in npm_100 carbonfootprint_g kcal_100g sugar_100g sodium_100g satfat_100g fib_100g protein_100g{
	local preffix = regexr("`var'","_(.*)","")
	bysort pid visit_store: egen `preffix'_avg = mean(`var')
}


tab quantity_v, mi //there are responses as 0.5

gen price_adj = price_v*quantity_v

bysort pid visit_store: egen spend_ttl = total(price_adj)

bysort pid visit_store: egen items_ttl = count(upc)


egen healthcon = rowmean(healthcon_longterm healthcon_conseq healthcon_reflect healthcon_efforts)
alpha healthcon_longterm healthcon_conseq healthcon_reflect healthcon_efforts

egen green = rowmean(green_products green_consider green_habits green_wasting green_responsible)
alpha green_products green_consider green_habits green_wasting green_responsible

/////
/*
Total swaps offered = total times swapsOfferedPopUp appears
Total swaps accepted = swappedFor=< a Product ID> AND addedfrom ="swapsOfferedPopUp"
% of swaps accepted = 100*(Total swaps accepted) / (Total swaps offered)
*/

tab swapoffered_v, mi
tab addedfrom_v, mi

gen swapsoffer_num = 1 if addedfrom_v =="swapsOfferedPopUp"
tab swapsoffer_num, mi

bysort pid visit_store: egen ttl_swapoffer = total(swapsoffer_num)

tab swappedfor_v if swapsoffer_num==1, mi

gen swapsaccept_num = .
replace swapsaccept_num = 1 if swappedfor_v!="na" & swappedfor_v!="" & addedfrom_v =="swapsOfferedPopUp"
tab swapsaccept_num, mi

bysort pid visit_store: egen ttl_swapaccept = total(swapsaccept_num)


bysort pid visit_store: gen prop_swapaccept = ttl_swapaccept / ttl_swapoffer

save "Int dataset A_nutri and carbon_all rows.dta", replace


use "Int dataset A_nutri and carbon_all rows.dta", clear

distinct pid if visit_store==1
distinct pid if visit_store==2
distinct pid if visit_store==3

duplicates drop pid visit_store, force

distinct pid


order visit_store time, after(treatment_svy)

drop healthcon_longterm-green_responsible
drop product_id-merge_product
drop n_rows trt_same


distinct pid if treatment_svy==1 & visit_store==1
scalar control1 = r(ndistinct)
distinct pid if treatment_svy==1 & visit_store==2
scalar control2 = r(ndistinct)
distinct pid if treatment_svy==1 & visit_store==3
scalar control3 = r(ndistinct)

distinct pid if treatment_svy==2 & visit_store==1
scalar nutri1 = r(ndistinct)
distinct pid if treatment_svy==2 & visit_store==2
scalar nutri2 = r(ndistinct)
distinct pid if treatment_svy==2 & visit_store==3
scalar nutri3 = r(ndistinct)

distinct pid if treatment_svy==3 & visit_store==1
scalar env1 = r(ndistinct)
distinct pid if treatment_svy==3 & visit_store==2
scalar env2 = r(ndistinct)
distinct pid if treatment_svy==3 & visit_store==3
scalar env3 = r(ndistinct)

distinct pid if treatment_svy==4 & visit==1
scalar nutrenv1 = r(ndistinct)
distinct pid if treatment_svy==4 & visit==2
scalar nutrenv2 = r(ndistinct)
distinct pid if treatment_svy==4 & visit==3
scalar nutrenv3 = r(ndistinct)

bysort pid: egen count_visit = count(visit)
order count_visit, after(time)

tab count_visit, mi
tab visit_store if count_visit==1, mi

distinct pid if visit_store==1 & count_visit==1 & treatment_svy==1
scalar nointerv_control = r(ndistinct)
distinct pid if visit_store==1 & count_visit==1 & treatment_svy==2
scalar nointerv_nutri = r(ndistinct)
distinct pid if visit_store==1 & count_visit==1 & treatment_svy==3
scalar nointerv_env = r(ndistinct)
distinct pid if visit_store==1 & count_visit==1 & treatment_svy==4
scalar nointerv_nutrenv = r(ndistinct)

save "dataset A_nutri and carbon.dta", replace

//////////

**#Consort

putexcel set "$Results/Consort.xlsx", replace


local row=3

foreach gp in ya{
foreach var in fl_prestart_`gp'1 fl_preconsent_`gp'1 fl_precountry_`gp'1 fl_prenovisit_`gp'1 fl_preageout_`gp'1 fl_preagemiss_`gp'1 fl_preshop_`gp'1 fl_preprogress_`gp'1 fl_preoddids_`gp'1 fl_predup_`gp'1 fl_preend_`gp'1{

putexcel A2 = "Full Launch Young Adult"
putexcel A`row' = "`var' "
putexcel B`row' = `var'

local ++row
}
}

local row=3

foreach gp in oa{
foreach var in fl_prestart_`gp'1 fl_preconsent_`gp'1 fl_precountry_`gp'1 fl_prenovisit_`gp'1 fl_preageout_`gp'1 fl_preagemiss_`gp'1 fl_preshop_`gp'1 fl_preprogress_`gp'1 fl_preoddids_`gp'1 fl_predup_`gp'1 fl_preend_`gp'1{

putexcel C2 = "Full Launch Old Adult"
putexcel C`row' = "`var' "
putexcel D`row' = `var'

local ++row
}
}

local row=3

foreach gp in ya{
foreach var in ml_prestart_`gp'1 ml_preconsent_`gp'1 ml_precountry_`gp'1 ml_prenovisit_`gp' ml_preageout_`gp'1 ml_preagemiss_`gp'1 ml_preshop_`gp'1 ml_preprogress_`gp'1 ml_preoddids_`gp'1 ml_predup_`gp'1 ml_preend_`gp'1{

putexcel E2 = "Mini Launch Young Adult"
putexcel E`row' = "`var' "
putexcel F`row' = `var'

local ++row
}
}

local row=3

foreach gp in oa{
foreach var in ml_prestart_`gp'1 ml_preconsent_`gp'1 ml_precountry_`gp'1 ml_prenovisit_`gp'1 ml_preageout_`gp'1 ml_preagemiss_`gp'1 ml_preshop_`gp'1 ml_preprogress_`gp'1 ml_preoddids_`gp'1 ml_predup_`gp'1 ml_preend_`gp'1{

putexcel G2 = "Mini Launch Old Adult"
putexcel G`row' = "`var' "
putexcel H`row' = `var'

local ++row
}
}

putexcel J`row' = "YES Pre, NO store V1 only"
putexcel K`row' = nostore_v1, font("","",red)
local ++row

putexcel J3 = "Total Start"
scalar tt_start = fl_prestart_ya1 + fl_prestart_oa1 + ml_prestart_ya1 + ml_prestart_oa1
di tt_start
putexcel K3 = tt_start, bold

putexcel J11 = "Not meeting Inclusion Criteria"
putexcel K11 = formula(SUM(B4:H11)), font("","",red)

putexcel J12 = "Duplicates"
putexcel K12 = formula(SUM(B12:H12)), font("","",red)


putexcel J`row' = "YES Pre+Store, NO Post - not randomized"
putexcel K`row' = nopost_v1, font("","",red)
local ++row

putexcel J`row' = "Randomized"
putexcel K`row' = randomized1, bold
local ++row


putexcel A17:K17 = ("Counts by treatment arm per visit"), merge bold

local row=18
forval f=1/3{
	foreach var in control`f'{
	putexcel A`row' = "`var'"
	putexcel B`row' = `var'

local ++row
	}
}

local row=18
forval f=1/3{
	foreach var in nutri`f'{
	putexcel D`row' = "`var'"
	putexcel E`row' = `var'

local ++row
	}
}

local row=18
forval f=1/3{
	foreach var in env`f'{
	putexcel G`row' = "`var'"
	putexcel H`row' = `var'

local ++row
	}
}

local row=18
forval f=1/3{
	foreach var in nutrenv`f'{
	putexcel J`row' = "`var'"
	putexcel K`row' = `var'

local ++row
	}
}

putexcel A21 = "drop no intervention_control"
putexcel B21 = nointerv_control, font("","",red)

putexcel D21 = "drop no intervention_nutri"
putexcel E21 = nointerv_nutri, font("","",red)

putexcel G21 = "drop no intervention_env"
putexcel H21 = nointerv_env, font("","",red)

putexcel J21 = "drop no intervention_nutrenv"
putexcel K21 = nointerv_nutrenv, font("","",red)




