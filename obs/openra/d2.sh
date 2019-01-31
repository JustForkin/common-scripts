function d2up {
    cdgo d2 || return
    git pull origin master -q
    latest_commit_no=$(latest_commit_number)
    packaged_commit_number=$(vere openra-d2)
    latest_commit_hash=$(latest_commit_on_branch)
    packaged_commit_hash=$(come openra-d2)
    # OpenRA latest engine version
    latest_engine_version=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
    # OpenRA engine version in spec file
    packaged_engine_version=$(grep "define engine\_version" < "$HOME"/OBS/home:fusion809/openra-d2/openra-d2.spec | cut -d ' ' -f 3)

    if [[ ${packaged_commit_number} == ${latest_commit_no} ]]; then
         printf "\e[1;32m%-0s\e[m\n" "OpenRA RA2 is up-to-date!"
    else
         printf "\e[1;34m%-0s\e[m\n" "Updating d2 spec file and PKGBUILD."
         sed -i -e "s/${packaged_commit_hash}/${latest_commit_hash}/g" \
			 -e "s/${packaged_commit_number}/${latest_commit_no}/g" "$OBSH"/openra-d2/{openra-d2.spec,PKGBUILD}
         if ! [[ "$packaged_engine_version" == "$latest_engine_version" ]]; then
              printf "\e[1;34m%-0s\e[m\n" "Updating engine to $latest_engine_version."
              sed -i -e "s/define engine_version ${packaged_engine_version}/define engine_version ${latest_engine_version}/g" "$HOME"/OBS/home:fusion809/openra-d2/{openra-d2.spec,PKGBUILD}
              make clean || return
              make || return
              tar czvf "$HOME/OBS/home:fusion809/openra-d2/engine-${latest_engine_version}.tar.gz" engine
              cdobsh openra-d2 || return
              osc rm engine-"${packaged_engine_version}".tar.gz
              osc add engine-"${latest_engine_version}".tar.gz
              cd - || return
         fi
         printf "\e[1;34m%-0s\e[m\n" "Committing changes."
         cdobsh openra-d2 || return
         osc ci -m "Bumping ${packaged_commit_number}->${latest_commit_no}"
    fi

    	d2nup "${1}"
    # AppImage update not appropriate as it presently fails to run, due to missing d2k assembly. 
}
