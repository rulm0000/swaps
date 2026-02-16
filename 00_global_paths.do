* swaps - global path launcher
* Purpose: select project_root by user, then run setup.do

set more off
version 19

* Global file path rule
if "`c(username)'" == "ag" {
    global project_root "/Users/ag/.../social_media_wl/<analysis folder>"
}
else if "`c(username)'" == "culm" {
    global project_root "."
}
else {
    global project_root "."
}

capture noisily cd "$project_root"
if _rc {
    di as err "Could not enter project_root."
    exit 198
}

do "setup.do"
