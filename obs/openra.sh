function openrabup {
    cdgo OpenRA
    git checkout bleed -q
    git pull origin bleed -q
    mastn=$(comno)
    specn=$(vere openra-bleed)
    comm=$(loge)
    specm=$(come openra-bleed)

    if [[ $specn == $mastn ]]; then
         printf "OpenRA Bleed is up to date!\n"
    else
         printf "Updating OBS repo openra-bleed.\n"
         sed -i -e "s/$specn/$mastn/g" $OBSH/openra-bleed/{openra-bleed.spec,PKGBUILD}
         sed -i -e "s/$specm/$comm/g" $OBSH/openra-bleed/{openra-bleed.spec,PKGBUILD}
         cdobsh openra-bleed
         osc ci -m "Bumping $specn->$mastn"
         /usr/local/bin/openra-build
    fi
}

function ra2up {
    cdgo ra2
    git pull origin master -q
    mastn=$(comno)
    specn=$(vere openra-ra2)
    comm=$(loge)
    specm=$(come openra-ra2)

    if [[ $specn == $mastn ]]; then
         printf "OpenRA RA2 is up to date!\n"
    else
         sed -i -e "s/$specn/$mastn/g" $OBSH/openra-ra2/{openra-ra2.spec,PKGBUILD}
         sed -i -e "s/$specm/$comm/g" $OBSH/openra-ra2/{openra-ra2.spec,PKGBUILD}
         if ! [[ $enpv == $enlv ]]; then
              sed -i -e "s/$enpv/$enlv/g" $HOME/OBS/home:fusion809/openra-ra2/{openra-ra2.spec,PKGBUILD}
              make clean
              make
              tar czvf $HOME/OBS/home:fusion809/openra-ra2/engine-${enlv}.tar.gz engine
              cdobsh openra-ra2
              osc rm engine-${enpv}.tar.gz
              osc add engine-${enlv}.tar.gz
              cd -
         fi
         cdobsh openra-ra2
         osc ci -m "Bumping $specn->$mastn"
    fi
}

# Dark Reign update
function drup {
    cdgo DarkReign
    git pull origin master -q
    # OpenRA latest engine version
    enlv=$(cat mod.config | grep '^ENGINE\_VERSION' | cut -d '"' -f 2)
    # OpenRA engine version in spec file
    enpv=$(cat $HOME/OBS/home:fusion809/openra-dr/openra-dr.spec | grep "define engine\_version" | cut -d ' ' -f 3)
    mastn=$(comno)
    specn=$(vere openra-dr)
    comm=$(loge)
    specm=$(come openra-dr)

    if [[ $specn == $mastn ]]; then
         printf "OpenRA Dark Reign is up to date!\n"
    else
         sed -i -e "s/$specn/$mastn/g" $OBSH/openra-dr/{openra-dr.spec,PKGBUILD}
         sed -i -e "s/$specm/$comm/g" $OBSH/openra-dr/{openra-dr.spec,PKGBUILD}
         if ! [[ $enpv == $enlv ]]; then
              sed -i -e "s/$enpv/$enlv/g" $HOME/OBS/home:fusion809/openra-dr/{openra-dr.spec,PKGBUILD}
              make clean
              make
              tar czvf $HOME/OBS/home:fusion809/openra-dr/engine-${enlv}.tar.gz engine
              cdobsh openra-dr
              osc rm engine-${enpv}.tar.gz
              osc add engine-${enlv}.tar.gz
              cd -
         fi
         cdobsh openra-dr
         osc ci -m "Bumping $specn->$mastn"
    fi
}

# Dark Reign update
function racup {
    cdgo raclassic
    git pull origin master -q
    # OpenRA latest engine version
    enlv=$(cat mod.config | grep '^ENGINE\_VERSION' | cut -d '"' -f 2)
    # OpenRA engine version in spec file
    enpv=$(cat $HOME/OBS/home:fusion809/openra-raclassic/openra-raclassic.spec | grep "define engine\_version" | cut -d ' ' -f 3)
    mastn=$(comno)
    specn=$(vere openra-raclassic)
    comm=$(loge)
    specm=$(come openra-raclassic)

    if [[ $specn == $mastn ]]; then
         printf "OpenRA RA Classic is up to date!\n"
    else
         sed -i -e "s/$specn/$mastn/g" $OBSH/openra-raclassic/{openra-raclassic.spec,PKGBUILD}
         sed -i -e "s/$specm/$comm/g" $OBSH/openra-raclassic/{openra-raclassic.spec,PKGBUILD}
         if ! [[ $enpv == $enlv ]]; then
              sed -i -e "s/$enpv/$enlv/g" $HOME/OBS/home:fusion809/openra-raclassic/{openra-raclassic.spec,PKGBUILD}
              make clean
              make
              if `cat /etc/os-release | grep openSUSE > /dev/null 2>&1`; then
                   tar czvf $HOME/OBS/home:fusion809/openra-ura/engine-${enlv}.tar.gz engine
                   cdobsh openra-raclassic
                   osc rm engine-${enpv}.tar.gz
                   osc add engine-${enlv}.tar.gz
                   cd -
                   printf "Please remember to rebuild engine-arch.tar.gz on Arch Linux, then delete old tarball with osc rm, then add the new one with osc add and then commit the changes at $HOME/OBS/home:fusion809/openra-raclassic\n" && exit
              elif `cat /etc/os-release | grep Arch > /dev/null 2>&1`; then
                   tar czvf $HOME/OBS/home:fusion809/openra-raclassic/engine-arch-${enlv}.tar.gz engine
                   cdobsh openra-raclassic
                   osc rm engine-arch-${enpv}.tar.gz
                   osc add engine-arch-${enlv}.tar.gz
                   cd -
                   printf "Please remember to rebuild engine.tar.gz on Tumbleweed, then delete old tarball with osc rm, then add the new one with osc add and then commit the changes at $HOME/OBS/home:fusion809/openra-raclassic\n" && exit
              fi
         fi
         cdobsh openra-raclassic
         osc ci -m "Bumping $specn->$mastn"
    fi
}

function uRAup {
    cd $HOME/GitHub/others/uRA
    git pull origin master -q
    # OpenRA latest engine version
    enlv=$(cat mod.config | grep '^ENGINE\_VERSION' | cut -d '"' -f 2)
    # OpenRA engine version in spec file
    enpv=$(cat $HOME/OBS/home:fusion809/openra-ura/openra-ura.spec | grep "define engine\_version" | cut -d ' ' -f 3)
    mastn=$(git rev-list --branches master --count)
    specn=$(cat $HOME/OBS/home:fusion809/openra-ura/openra-ura.spec | grep "Version\:" | sed 's/Version:\s*//g')
    comm=$(git log | head -n 1 | cut -d ' ' -f 2)
    specm=$(cat $HOME/OBS/home:fusion809/openra-ura/openra-ura.spec | grep "define commit" | cut -d ' ' -f 3)

    if [[ $specn == $mastn ]]; then
         printf "OpenRA Red Alert Unplugged mod is up to date\!\n"
    else
         sed -i -e "s/$specn/$mastn/g" $HOME/OBS/home:fusion809/openra-ura/{openra-ura.spec,PKGBUILD}
         sed -i -e "s/$specm/$comm/g" $HOME/OBS/home:fusion809/openra-ura/{openra-ura.spec,PKGBUILD}
         if ! [[ $enpv == $enlv ]]; then
              sed -i -e "s/$enpv/$enlv/g" $HOME/OBS/home:fusion809/openra-ura/{openra-ura.spec,PKGBUILD}
              make
              tar czvf $HOME/OBS/home:fusion809/openra-ura/engine-${enlv}.tar.gz engine
              cdobsh openra-ura
              osc rm engine-${enpv}.tar.gz
              osc add engine-${enlv}.tar.gz
              cd -
         fi
         cd $HOME/OBS/home:fusion809/openra-ura
         if ! [[ $enpv == $enlv ]]; then
              osc ci -m "Bumping $specn->$mastn; engine $enpv->$enlv"
         else
              osc ci -m "Bumping $specn->$mastn; engine version is unchanged."
         fi
    fi
}

alias uraup=uRAup
