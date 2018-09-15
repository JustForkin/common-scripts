# Dark Reign update
function drup {
    cdgo DarkReign || exit
    git pull origin master -q
    # OpenRA latest engine version
    enlv=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
    # OpenRA engine version in spec file
    enpv=$(grep "^%define engine" < "$HOME"/OBS/home:fusion809/openra-dr/openra-dr.spec | cut -d ' ' -f 3)
    mastn=$(comno)
    specn=$(vere openra-dr)
    comm=$(loge)
    specm=$(come openra-dr)

    if [[ $specn == $mastn ]]; then
         printf "OpenRA Dark Reign is up-to-date!\n"
    else
         sed -i -e "s/$specn/$mastn/g" "$OBSH"/openra-dr/{openra-dr.spec,PKGBUILD}
         sed -i -e "s/$specm/$comm/g" "$OBSH"/openra-dr/{openra-dr.spec,PKGBUILD}
         if ! [[ "$enpv" == "$enlv" ]]; then
              sed -i -e "s/$enpv/$enlv/g" "$HOME"/OBS/home:fusion809/openra-dr/{openra-dr.spec,PKGBUILD}
              make clean || exit
              make || exit
              tar czvf "$HOME"/OBS/home:fusion809/openra-dr/engine-"${enlv}".tar.gz engine
              cdobsh openra-dr || exit
              osc rm engine-"${enpv}".tar.gz
              osc add engine-"${enlv}".tar.gz
              cd - || exit
         fi
         cdobsh openra-dr || exit
         osc ci -m "Bumping $specn->$mastn"
    fi
}

