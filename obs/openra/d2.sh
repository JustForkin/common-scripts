function d2up {
    cdgo d2
    git pull origin master -q
    mastn=$(comno)
    specn=$(vere openra-d2)
    comm=$(loge)
    specm=$(come openra-d2)
    # OpenRA latest engine version
    enlv=$(cat mod.config | grep '^ENGINE\_VERSION' | cut -d '"' -f 2)
    # OpenRA engine version in spec file
    enpv=$(cat $HOME/OBS/home:fusion809/openra-d2/openra-d2.spec | grep "define engine\_version" | cut -d ' ' -f 3)

    if [[ $specn == $mastn ]]; then
         printf "OpenRA RA2 is up to date!\n"
    else
         printf "Updating d2 spec file and PKGBUILD.\n"
         sed -i -e "s/$specn/$mastn/g" $OBSH/openra-d2/{openra-d2.spec,PKGBUILD}
         sed -i -e "s/$specm/$comm/g" $OBSH/openra-d2/{openra-d2.spec,PKGBUILD}
         if ! [[ $enpv == $enlv ]]; then
              printf "Updating engine to $enlv.\n"
              sed -i -e "s/define engine_version $enpv/define engine_version $enlv/g" "$HOME"/OBS/home:fusion809/openra-d2/{openra-d2.spec,PKGBUILD}
              make clean
              make
              tar czvf "$HOME/OBS/home:fusion809/openra-d2/engine-${enlv}.tar.gz" engine
              cdobsh openra-d2
              osc rm engine-${enpv}.tar.gz
              osc add engine-${enlv}.tar.gz
              cd -
         fi
         printf "Committing changes.\n"
         cdobsh openra-d2
         osc ci -m "Bumping $specn->$mastn"
    fi
}

