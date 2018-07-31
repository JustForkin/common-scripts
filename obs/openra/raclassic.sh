# Red Alert Classic update

function racb {
    cdgo raclassic
    make clean
    make
    if `cat /etc/os-release | grep openSUSE > /dev/null 2>&1`; then
         tar czvf $HOME/OBS/home:fusion809/openra-ura/engine-${enlv}.tar.gz engine
         cdobsh openra-raclassic
         osc rm engine-${enpv}.tar.gz
         osc add engine-${enlv}.tar.gz
         cd -
         printf "Please remember to run racb on Arch Linux too.\n" && exit
    elif `cat /etc/os-release | grep Arch > /dev/null 2>&1`; then
         tar czvf $HOME/OBS/home:fusion809/openra-raclassic/engine-arch-${enlv}.tar.gz engine
         cdobsh openra-raclassic
         osc rm engine-arch-${enpv}.tar.gz
         osc add engine-arch-${enlv}.tar.gz
         cd -
         printf "Please remember to run racb on Tumbleweed too. Then you can commit the changes\n" && exit
    fi
}

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
              printf "Please remember to run racb on Arch and Tumbleweed, then remove old tarball with osc rm and add new one with osc add and then commit changes.\n"
         else
              cdobsh openra-raclassic
              osc ci -m "Bumping $specn->$mastn"
         fi
    fi
}

