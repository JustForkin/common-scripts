function d2up {
    cdgo d2 || return
    git pull origin master -q
    mastn=$(latest_commit_number)
    specn=$(vere openra-d2)
    comm=$(latest_commit_on_branch)
    specm=$(come openra-d2)
    # OpenRA latest engine version
    enlv=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
    # OpenRA engine version in spec file
    enpv=$(grep "define engine\_version" < "$HOME"/OBS/home:fusion809/openra-d2/openra-d2.spec | cut -d ' ' -f 3)

    if [[ $specn == $mastn ]]; then
         printf "%s\n" "OpenRA RA2 is up-to-date!"
    else
         printf "%s\n" "Updating d2 spec file and PKGBUILD."
         sed -i -e "s/$specm/$comm/g" \
			 -e "s/$specn/$mastn/g" "$OBSH"/openra-d2/{openra-d2.spec,PKGBUILD}
         if ! [[ "$enpv" == "$enlv" ]]; then
              printf "%s\n" "Updating engine to $enlv."
              sed -i -e "s/define engine_version $enpv/define engine_version $enlv/g" "$HOME"/OBS/home:fusion809/openra-d2/{openra-d2.spec,PKGBUILD}
              make clean || return
              make || return
              tar czvf "$HOME/OBS/home:fusion809/openra-d2/engine-${enlv}.tar.gz" engine
              cdobsh openra-d2 || return
              osc rm engine-"${enpv}".tar.gz
              osc add engine-"${enlv}".tar.gz
              cd - || return
         fi
         printf "%s\n" "Committing changes."
         cdobsh openra-d2 || return
         osc ci -m "Bumping $specn->$mastn"
    fi

    	d2nup
    # AppImage update not appropriate as it presently fails to run, due to missing d2k assembly. 
}
