function lsymup {
    cdgo libmsym
    comlc=$(git rev-list --branches master --count)
    coml=$(git log | head -n 1 | cut -d ' ' -f 2)
    cdobsh libmsym
    compc=$(cat libmsym.spec | grep "Version:" | sed 's/Version:\s*//g')
    comp=$(cat libmsym.spec | grep "%define commit" | cut -d ' ' -f 3)
    sed -i -e "s|$compc|$comlc|g" \
           -e "s|$comp|$coml|g" libmsym.spec
    osc ci -m "Bumping to $comlc"
}

alias libmsymup=lsymup
