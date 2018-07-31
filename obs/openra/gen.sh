# Dark Reign update
function genup {
    cdgo Generals-Alpha
    git pull origin master -q
    # OpenRA latest engine version
    enlv=$(cat mod.config | grep '^ENGINE\_VERSION' | cut -d '"' -f 2)
    # OpenRA engine version in spec file
    enpv=$(cat $HOME/OBS/home:fusion809/openra-gen/openra-gen.spec | grep "define engine\_version" | cut -d ' ' -f 3)
    mastn=$(comno)
    specn=$(vere openra-gen)
    comm=$(loge)
    specm=$(come openra-gen)

    if [[ $specn == $mastn ]]; then
         printf "OpenRA Generals Alpha is up to date!\n"
    else
         printf "Updating openra-gen spec file and PKGBUILD.\n"
         sed -i -e "s/$specn/$mastn/g" $OBSH/openra-gen/{openra-gen.spec,PKGBUILD}
         sed -i -e "s/$specm/$comm/g" $OBSH/openra-gen/{openra-gen.spec,PKGBUILD}
         if ! [[ $enpv == $enlv ]]; then
              printf "Updating Generals Alpha engine.\n"
              sed -i -e "s/$enpv/$enlv/g" $HOME/OBS/home:fusion809/openra-gen/{openra-gen.spec,PKGBUILD}
              make clean
              make
              tar czvf $HOME/OBS/home:fusion809/openra-gen/engine-${enlv}.tar.gz generals-alpha-engine
              cdobsh openra-gen
              osc rm engine-${enpv}.tar.gz
              osc add engine-${enlv}.tar.gz
              cd -
         fi
         printf "Committing changes.\n"
         cdobsh openra-gen
         osc ci -m "Bumping $specn->$mastn"
    fi
}

