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

function babelup {
    cdgo openbabel
    git pull origin master -q
    mastn=$(git rev-list --branches master --count)
    specn=$(cat $OBS/home:fusion809:openbabel3/openbabel3/openbabel3.spec | grep "Version:" | sed 's/Version:\s*//g')
    comm=$(git log | head -n 1 | cut -d ' ' -f 2)
    specm=$(cat $OBS/home:fusion809:openbabel3/openbabel3/openbabel3.spec | grep "define commit" | cut -d ' ' -f 3)

    if [[ $specn == $mastn ]]; then
         printf "Open Babel is up to date!\n"
    else
         sed -i -e "s/$specn/$mastn/g" $OBS/home:fusion809:openbabel3/openbabel3/openbabel3.spec
         sed -i -e "s/$specm/$comm/g" $OBS/home:fusion809:openbabel3/openbabel3/openbabel3.spec
         cdobs home:fusion809:openbabel3/openbabel3
         osc ci -m "Bumping $specn->$mastn"
    fi
}

alias openbabelup=babelup

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

function zshup {
    pkgver=$(wget -cqO- http://www.zsh.org/pub/ | grep ".*[0-9].*tar.gz" | tail -n 1 | sed 's/.*"zsh-//g' | sed 's/.tar.gz.*//g')
    pkgpver=$(cat $OBSH/zsh/zsh.spec | grep "Version:" | cut -d ':' -f 2 | sed 's/\s*//g')

    if [[ $pkgver == $pkgpver ]]; then
         printf "Seems to be up-to-date mate.\n"
    else
         sed -i -e "s/$pkgpver/$pkgver/g" $OBSH/zsh/zsh.spec
         cdobsh zsh
         osc ci -m "Bumping $pkgpver->$pkgver"
    fi
} 

function flatup {
    pkgver=$(wget -cqO- https://github.com/flatpak/flatpak/releases | grep "tar\.gz" | cut -d '/' -f 5 | cut -d '"' -f 1 | sed 's/\.tar\.gz//g' | head -n 1)
    pkgpver=$(cat $OBSH/flatpak/flatpak.spec | grep "Version:" | cut -d ':' -f 2 | sed 's/\s*//g')

    if [[ $pkgver == $pkgpver ]]; then
         printf "Seems to be up-to-date mate.\n"
    else
         sed -i -e "s/$pkgpver/$pkgver/g" $OBSH/flatpak/flatpak.spec
         cdobsh flatpak
         osc ci -m "Bumping $pkgpver->$pkgver"
    fi
} 

function jmolup {
    pkgver=$(curl -sL https://sourceforge.net/projects/jmol/files | grep "binary.zip" | cut -d '-' -f 3 | tail -n 1)
    pkgpver=$(cat $OBSH/jmol/jmol.spec | grep "Version:" | cut -d ':' -f 2 | sed 's/\s*//g')

    if [[ $pkgver == $pkgpver ]]; then
         printf "Seems to be up-to-date mate.\n"
    else
         sed -i -e "s/$pkgpver/$pkgver/g" $OBSH/jmol/jmol.spec
         cdobsh jmol
         osc ci -m "Bumping $pkgpver->$pkgver"
    fi
}

function obsdup {
    if ! `ls /tmp | grep src > /dev/null 2>&1`; then
         curl -sL http://download.opensuse.org/source/tumbleweed/repo/oss/src &> /tmp/src-$(date | sed 's/ /_/g' | sed 's/:[0-9]*_/_/g').html
    fi

    pkgver=$(curl -sL https://github.com/openSUSE/obs-service-download_files/releases | grep "\.tar\.gz" | head -n 1 | cut -d '"' -f 2 | cut -d '/' -f 5 | sed 's/\.tar\.gz//g')
    pkgpver=$(sed -n 's/pkgver=//p' $OBSH/obs-service-download_files/PKGBUILD)

    if [[ $pkgpver == $pkgver ]]; then
         printf "Seems to be up-to-date mate.\n"
    else
         sed -i -e "s/$pkgpver/$pkgver/g" $OBSH/obs-service-download_files/PKGBUILD
         cdobsh obs-service-download_files
         osc ci -m "Bumping $pkgpver->$pkgver"
    fi
}

function snapdup {
    pkgver=$(wget -cqO- https://github.com/snapcore/snapd/releases | grep "[0-9].vendor\.tar\.xz" | head -n 1 | cut -d '/' -f 6)
    pkgpver=$(cat $HOME/OBS/home:fusion809/snapd/snapd.spec | grep "Version:" | cut -d ':' -f 2 | sed 's/\s*//g')

    if [[ $pkgver == $pkgpver ]]; then
         printf "Seems to be up-to-date mate.\n"
    else
         sed -i -e "s/$pkgpver/$pkgver/g" $OBSH/snapd/snapd.spec
         cdobsh snapd
         osc ci -m "Bumping $pkgpver->$pkgver"
    fi
}

function snapdgup {
    pkgver=$(wget -cqO- https://github.com/snapcore/snapd-glib/releases | grep "[0-9]\.tar\.xz" | head -n 1 | cut -d '/' -f 6)
    pkgpver=$(cat $HOME/OBS/home:fusion809/snapd-glib/snapd-glib.spec | grep "Version:" | cut -d ':' -f 2 | sed 's/\s*//g')

    if [[ $pkgver == $pkgpver ]]; then
         printf "Seems to be up-to-date mate.\n"
    else
         sed -i -e "s/$pkgpver/$pkgver/g" $OBSH/snapd-glib/snapd-glib.spec
         cdobsh snapd-glib
         osc ci -m "Bumping $pkgpver->$pkgver"
    fi
}

function oscup {
    pkgver=$(curl -sL https://github.com/openSUSE/osc/releases | grep "\.tar\.gz" | head -n 1 | cut -d '"' -f 2 | cut -d '/' -f 5 | sed 's/\.tar\.gz//g')
    pkgpver=$(sed -n 's/pkgver=//p' $OBSH/osc/PKGBUILD)

    if [[ $pkgpver == $pkgver ]]; then
         printf "Seems to be up-to-date mate.\n"
    else
         sed -i -e "s/$pkgpver/$pkgver/g" $OBSH/osc/PKGBUILD
         cdobsh osc
         osc ci -m "Bumping $pkgpver->$pkgver"
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
