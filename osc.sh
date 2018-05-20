function oscbot {
    osc build openSUSE_Tumbleweed --noverify "$@"
}

if `cat /etc/os-release | grep "Tumbleweed" > /dev/null 2>&1`; then
    alias oscb=oscbot
fi

function oscbotns {
    oscb --no-service "$@"
}

alias oscbs=oscbns

function obco {
    for i in "$@"
    do
         pushd $HOME/OBS
         osc co home:fusion809 "$i"
         popd
    done
}

function obc {
    pushd $HOME/OBS
    osc co home:fusion809 "$1"
    popd
    cdobsh "$1"
}

function mobc {
    osc mkpac "$1"
    obc "$1"
}

function copypac {
    osc copypac $1 $2 home:fusion809 $2
    obc $2
}

function 0adup {
    cdgo 0ad
    git pull origin master -q
    mastn=$(git rev-list --branches master --count)
    specn=$(cat $OBSH/0ad/0ad.spec | grep "Version:" | sed 's/Version:\s*//g')
    comm=$(git log | head -n 1 | cut -d ' ' -f 2)
    specm=$(cat $OBSH/0ad/0ad.spec | grep "define commit" | cut -d ' ' -f 3)

    if [[ $specn == $mastn ]]; then
         printf "0 A.D. is up to date!\n"
    else
         sed -i -e "s/$specn/$mastn/g" $OBSH/0ad/0ad.spec
         sed -i -e "s/$specn/$mastn/g" $OBSH/0ad-data/0ad-data.spec
         sed -i -e "s/$specm/$comm/g" $OBSH/0ad/0ad.spec
         sed -i -e "s/$specm/$comm/g" $OBSH/0ad-data/0ad-data.spec
         cdobsh 0ad; osc ci -m "Bumping $specn->$mastn"
         cdobsh 0ad-data; osc ci -m "Bumping $specn->$mastn"
    fi
}

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
         sed -i -e "s/$specn/$mastn/g" $OBSH/openra-bleed/openra-bleed.spec
         sed -i -e "s/$specm/$comm/g" $OBSH/openra-bleed/openra-bleed.spec
         cdobsh openra-bleed
         osc ci -m "Bumping $specn->$mastn"
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

function gsup {
    pkgver=$(wget -cqO- https://github.com/GNOME/gnome-software/releases | grep "tar\.gz" | grep "3\.[02468]*\.[0-9]*" | cut -d '/' -f 5 | cut -d '"' -f 1 | sed 's/\.tar\.gz//g' | head -n 1)
    pkgpver=$(cat $OBSH/gnome-software/gnome-software.spec | grep "Version:" | cut -d ':' -f 2 | sed 's/\s*//g')

    if [[ $pkgver == $pkgpver ]]; then
         printf "Seems to be up-to-date mate.\n"
    else
         sed -i -e "s/$pkgpver/$pkgver/g" $OBSH/gnome-software/gnome-software.spec
         cdobsh gnome-software
         osc ci -m "Bumping $pkgpver->$pkgver"
    fi
} 

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
