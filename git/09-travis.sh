# Function to determine Travis status for a given repo
# Should return one of:
# failed
# passing
# unknown
# Takes inputs of the repo name,
# or the mod id of an OpenRA mod, 
# or openra for the OpenRA engine repo; and
# the name of the branch used (which is optional)
# travis_check repo [branch]
function travis_check {
    if [[ "$1" == "rv" ]]; then
        repo="MustaphaTR/Romanovs-Vegeance"
    elif [[ "$1" == "ca" ]]; then
        repo="Inq8/CAmod"
    elif [[ "$1" == "openra" ]]; then
        repo="OpenRA/OpenRA"
        branch="bleed"
    elif [[ "$1" == "mw" ]]; then
        repo="CombinE88/Medieval-Warfare"
    elif [[ "$1" == "dr" ]]; then
        repo="drogoganor/DarkReign"
    elif [[ "$1" == "raclassic" ]]; then
        repo="OpenRA/raclassic"
    elif [[ "$1" == "ra2" ]]; then
        repo="OpenRA/ra2"
    elif [[ "$1" == "d2" ]]; then
        repo="OpenRA/d2"
    elif [[ "$1" == "gen" ]]; then
        repo="MustaphaTR/Generals-Alpha"
    elif [[ "$1" == "kknd" ]]; then
        repo="IceReaper/KKnD"
    elif [[ "$1" == "sp" ]]; then
        repo="ABrandau/OpenRAModSDK"
    elif [[ "$1" == "ss" ]]; then
        repo="MustaphaTR/sole-survivor"
    elif [[ "$1" == "ura" ]]; then
        repo="RAUnplugged/uRA"
    elif [[ "$1" == "yr" ]]; then
        repo="cookgreen/yr"
    else
        repo="$1"
    fi

    if ! [[ -n "$branch" ]] || ! [[ -n "$2" ]]; then
        branch="master"
    else
        branch="$2"
    fi

    wget -cqO- "https://travis-ci.org/${repo}.svg?branch=${branch}" | cut -d '>' -f 16 | cut -d '<' -f 1
}