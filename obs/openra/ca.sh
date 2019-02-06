# Combined Arms update
# Last latest_commit_hashit with OBS version is b76be97a97f499f1b1b716418c36f95f8483d17a
function caup {
	cdgo CAmod || ( printf "\e[1;31m%-0s\e[m\n" "cd'in' into $GHUBO/CAmod failed.\n" && return )
	git pull origin master -q || ( printf "\e[1;31m%-0s\e[m\n" "Git pull master branch from origin ref failed." && return)
	# OpenRA latest engine version
	latest_engine_version=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
	# OpenRA engine version in spec file
	packaged_engine_version=$(grep "^%define engine" < "$HOME"/OBS/home:fusion809/openra-ca/openra-ca.spec | cut -d ' ' -f 3)
	latest_commit_no=$(latest_commit_number)
	packaged_commit_number=$(vere openra-ca)
	latest_commit_hash=$(latest_commit_on_branch)
	packaged_commit_hash=$(come openra-ca)

	if [[ ${packaged_commit_number} == ${latest_commit_no} ]]; then
		printf "\e[1;34m%-0s\e[m\n" "OpenRA Combined Arms is up-to-date\!"
	else
		sed -i -e "s/${packaged_commit_hash}/${latest_commit_hash}/g" \
			   -e "s/${packaged_commit_number}/${latest_commit_no}/g" "$OBSH"/openra-ca/{openra-ca.spec,PKGBUILD}
		if ! [[ "$packaged_engine_version" == "$latest_engine_version" ]]; then
			sed -i -e "s/$packaged_engine_version/$latest_engine_version/g" "$HOME"/OBS/home:fusion809/openra-ca/{openra-ca.spec,PKGBUILD}
			make clean || return
			make || return
			tar czvf "$HOME"/OBS/home:fusion809/openra-ca/engine-"${latest_engine_version}".tar.gz engine
			cdobsh openra-ca || return
			osc rm engine*.tar.gz
			osc add engine-"${latest_engine_version}".tar.gz
			cd - || return
		fi
		cdobsh openra-ca || return
		osc ci -m "Bumping $packaged_commit_number->$latest_commit_no"
	fi
	# An expanded caup func was used in latest_commit_hashit eb723d4af07bf2a72038a938525f18cd98df2699 and earlier
	openra_mod_appimage_build CAmod
	canup "${1}"
}
