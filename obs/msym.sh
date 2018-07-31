function msymup {
    cdgo libmsym
    git pull origin master -q
    mastn=$(comno)
    comm=$(git log | head -n 1 | cut -d ' ' -f 2)
    cdobsh libmsym
    specn=$(cat libmsym.spec | grep "Version:" | sed 's/Version:\s*//g')
    specm=$(cat libmsym.spec | grep "define commit" | cut -d ' ' -f 3)

    if [[ $specn == $mastn ]]; then
         printf "libmsym is up to date!\n"
    else
         sed -i -e "s/$specn/$mastn/g" \
                -e "s/$specm/$comm/g" libmsym.spec
         osc ci -m "Bumping $specn->$mastn"
    fi
}

alias libmsymup=msymup
alias lsymup=msymup
