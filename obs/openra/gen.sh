# Dark Reign update
function genup {
	cdgo Generals-Alpha || return
	git pull origin master -q
	# OpenRA latest engine version
	latest_engine_version=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
	# OpenRA engine version in spec file
	packaged_engine_version=$(grep "define engine\_version" < "$HOME"/OBS/home:fusion809/openra-gen/openra-gen.spec | cut -d ' ' -f 3)
	latest_commit_no=$(latest_commit_number)
	packaged_commit_number=$(vere openra-gen)
	latest_commit_hash=$(latest_commit_on_branch)
	packaged_commit_hash=$(come openra-gen)

	if [[ ${packaged_commit_number} == ${latest_commit_no} ]]; then
		printf "\e[1;32m%-0s\e[m\n" "OpenRA Generals Alpha is up-to-date\!"
	else
		printf "\e[1;34m%-0s\e[m\n" "Updating openra-gen spec file and PKGBUILD."
		sed -i -e "s/${packaged_commit_hash}/${latest_commit_hash}/g" \
			   -e "s/${packaged_commit_number}/${latest_commit_no}/g" "$OBSH"/openra-gen/{openra-gen.spec,PKGBUILD}
		if ! [[ ${packaged_engine_version} == ${latest_engine_version} ]]; then
			printf "\e[1;34m%-0s\e[m\n" "Updating Generals Alpha engine."
			sed -i -e "s/${packaged_engine_version}/${latest_engine_version}/g" "$HOME"/OBS/home:fusion809/openra-gen/{openra-gen.spec,PKGBUILD}
			make clean || return
			make || ( printf "Running make failed" && return )
			tar czvf "$HOME"/OBS/home:fusion809/openra-gen/engine-"${latest_engine_version}".tar.gz generals-alpha-engine
			cdobsh openra-gen
			osc rm engine*.tar.gz
			osc add engine-"${latest_engine_version}".tar.gz
			cd - || return
		fi
		printf "%s\n" "Committing changes."
		cdobsh openra-gen || return
		osc ci -m "Bumping ${packaged_commit_number}->${latest_commit_no}"
	fi
	openra_mod_appimage_build Generals-Alpha
	gennup "${1}"
}

