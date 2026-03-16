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
do "$project_root/05_sensitivity_exposure.do"
do "$project_root/08_table2_holm_supplement.do"

display as result "Manuscript replication pipeline completed via 06_output_exports.do."