# Create package
function create_obs_pkg {
    if [[ $PWD == $OBSH ]]; then
         printf "Making package and changing directories into it"
         osc mkpac "$1"
         cd "$1"
    else
         printf "Changing directory to $OBS, making package and changing directories into it"
         cdobsh
         osc mkpac "$1"
         cd "$1"
    fi
}

alias mobc=create_obs_pkg