function openrabup {
    cdgo OpenRA
    git pull origin bleed -q
    mastn=$(git rev-list --branches bleed --count)
    specn=$(cat $OBSH/openra-bleed/openra-bleed.spec | grep "Version:" | sed 's/Version:\s*//g')
    comm=$(git log | head -n 1 | cut -d ' ' -f 2)
    specm=$(cat $OBSH/openra-bleed/openra-bleed.spec | grep "define commit" | cut -d ' ' -f 3)

    if [[ $specn == $mastn ]]; then
         printf "OpenRA Bleed is up to date!\n"
    else
         printf "Updating my fork of the OpenRA repository.\n"
         cdpk OpenRA ; git checkout bleed -q ; git pull upstream bleed -q ; push "New upstream commit, bumping VERSION"
         printf "Updating OBS repo openra-bleed.\n"
         sed -i -e "s/$specn/$mastn/g" $OBSH/openra-bleed/openra-bleed.spec
         sed -i -e "s/$specm/$comm/g" $OBSH/openra-bleed/openra-bleed.spec
         cdobsh openra-bleed
         osc ci -m "Bumping $specn->$mastn"
         /usr/local/bin/openra-build
    fi
}

function ra2up {
    cdgo ra2
    git pull origin master -q
    mastn=$(git rev-list --branches master --count)
    specn=$(cat $OBSH/openra-ra2/openra-ra2.spec | grep "Version:" | sed 's/Version:\s*//g')
    comm=$(git log | head -n 1 | cut -d ' ' -f 2)
    specm=$(cat $OBSH/openra-ra2/openra-ra2.spec | grep "define commit" | cut -d ' ' -f 3)

    if [[ $specn == $mastn ]]; then
         printf "OpenRA RA2 is up to date!\n"
    else
         sed -i -e "s/$specn/$mastn/g" $OBSH/openra-ra2/openra-ra2.spec
         sed -i -e "s/$specm/$comm/g" $OBSH/openra-ra2/openra-ra2.spec
         cdobsh openra-ra2
         osc ci -m "Bumping $specn->$mastn"
    fi
}

# Dark Reign update
function drup {
    cdgo DarkReign
    git pull origin master -q
    mastn=$(git rev-list --branches master --count)
    specn=$(cat $OBSH/openra-dr/openra-dr.spec | grep "Version:" | sed 's/Version:\s*//g')
    comm=$(git log | head -n 1 | cut -d ' ' -f 2)
    specm=$(cat $OBSH/openra-dr/openra-dr.spec | grep "define commit" | cut -d ' ' -f 3)

    if [[ $specn == $mastn ]]; then
         printf "OpenRA Dark Reign is up to date!\n"
    else
         sed -i -e "s/$specn/$mastn/g" $OBSH/openra-dr/openra-dr.spec
         sed -i -e "s/$specm/$comm/g" $OBSH/openra-dr/openra-dr.spec
         cdobsh openra-dr
         osc ci -m "Bumping $specn->$mastn"
    fi    
}

# Dark Reign update
function racup {
    cdgo raclassic
    git pull origin master -q
    mastn=$(git rev-list --branches master --count)
    specn=$(cat $OBSH/openra-raclassic/openra-raclassic.spec | grep "Version:" | sed 's/Version:\s*//g')
    comm=$(git log | head -n 1 | cut -d ' ' -f 2)
    specm=$(cat $OBSH/openra-raclassic/openra-raclassic.spec | grep "define commit" | cut -d ' ' -f 3)

    if [[ $specn == $mastn ]]; then
         printf "OpenRA RA Classic is up to date!\n"
    else
         sed -i -e "s/$specn/$mastn/g" $OBSH/openra-raclassic/openra-raclassic.spec
         sed -i -e "s/$specm/$comm/g" $OBSH/openra-raclassic/openra-raclassic.spec
         cdobsh openra-raclassic
         osc ci -m "Bumping $specn->$mastn"
    fi    
}

