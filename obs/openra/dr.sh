# Dark Reign update
function drup {
	cdgo DarkReign || return
	git pull origin master -q
	# OpenRA latest engine version
	if [[ $(grep "^AUTOMATIC_ENGINE_SOURCE" < mod.config | cut -d '/' -f 7 | cut -d "." -f 1) == '${ENGINE_VERSION}' ]]; then
		latest_engine_version=$(grep '^ENGINE_VERSION' < mod.config | cut -d '"' -f 2)
	elif [[ $(grep "^AUTOMATIC_ENGINE_SOURCE" < mod.config | cut -d '/' -f 7 | cut -d "." -f 1) == 'DarkReign' ]]; then
		latest_engine_version=$(loge $GHUBO/OpenRA-dr)
	fi
	# OpenRA engine version in spec file
	packaged_engine_version=$(grep "^%define engine" < "$HOME"/OBS/home:fusion809/openra-dr/openra-dr.spec | cut -d ' ' -f 3)
	latest_commit_no=$(latest_commit_number)
	packaged_commit_number=$(vere openra-dr)
	latest_commit_hash=$(latest_commit_on_branch)
	packaged_commit_hash=$(come openra-dr)

	if [[ $packaged_commit_number == $latest_commit_no ]]; then
		printf "e[1;32m%-0se[m\n" "OpenRA Dark Reign is up-to-date\!"
	else
		sed -i -e "s/$packaged_commit_hash/$latest_commit_hash/g" \
			   -e "s/$packaged_commit_number/$latest_commit_no/g" "$OBSH"/openra-dr/{openra-dr.spec,PKGBUILD}
		if ! [[ "$packaged_engine_version" == "$latest_engine_version" ]]; then
			sed -i -e "s/$packaged_engine_version/$latest_engine_version/g" "$HOME"/OBS/home:fusion809/openra-dr/{openra-dr.spec,PKGBUILD}
			make clean || return
			make || ( printf "Running make failed" && return )
			tar czvf "$HOME"/OBS/home:fusion809/openra-dr/engine-"${latest_engine_version}".tar.gz engine
			cdobsh openra-dr || return
			osc rm engine-"${packaged_engine_version}".tar.gz
			osc add engine-"${latest_engine_version}".tar.gz
			cd - || return
		fi
		cdobsh openra-dr || return
		osc ci -m "Bumping $packaged_commit_number->$latest_commit_no"
	fi
	openra_mod_appimage_build DarkReign
	drnup "${1}"
}

