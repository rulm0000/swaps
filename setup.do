* swaps - setup globals from project_root
* Expected input global: project_root

capture confirm file "$project_root/README.md"
if _rc {
    di as err "project_root is not set to the swaps repo root."
    exit 198
}

global Repo "$project_root"
global DataRaw    "$Repo/data/raw"
global DataInt    "$Repo/data/intermediate"
global DataDeriv  "$Repo/data/derived"
global OutTables  "$Repo/output/tables"
global OutFigures "$Repo/output/figures"
global OutLogs    "$Repo/output/logs"

di as txt "Setup complete: globals loaded from setup.do"
