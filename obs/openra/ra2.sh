function ra2up {
    cdgo ra2 || exit
    git pull origin master -q
    # OpenRA latest engine version
    enlv=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
    # OpenRA engine version in spec file
    enpv=$(grep "define engine\_version" < "$OBSH"/openra-ra2/openra-ra2.spec | cut -d ' ' -f 3)
    mastn=$(comno)
    specn=$(vere openra-ra2)
    comm=$(loge)
    specm=$(come openra-ra2)

    if [[ $specn == $mastn ]]; then
         printf "OpenRA RA2 is up to date!\n"
    else
         printf "Updating openra-ra2 spec file and PKGBUILD.\n"
         sed -i -e "s/$specn/$mastn/g" "$OBSH"/openra-ra2/{openra-ra2.spec,PKGBUILD}
         sed -i -e "s/$specm/$comm/g" "$OBSH"/openra-ra2/{openra-ra2.spec,PKGBUILD}
         if ! [[ "$enpv" == "$enlv" ]]; then
              printf "Updating OpenRA Red Alert 2 engine.\n"
              sed -i -e "s/$enpv/$enlv/g" "$OBSH"/openra-ra2/{openra-ra2.spec,PKGBUILD}
              make clean || exit
              make || exit
              tar czvf "$OBSH"/openra-ra2/engine-"${enlv}".tar.gz engine
              cdobsh openra-ra2 || exit
              osc rm engine-"${enpv}".tar.gz
              osc add engine-"${enlv}".tar.gz
              cd - || exit
         fi
         printf "%s\n" "Comitting changes."
         cdobsh openra-ra2
         osc ci -m "Bumping $specn->$mastn"
    fi
}

