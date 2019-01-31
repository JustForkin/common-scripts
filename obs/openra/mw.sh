function mwup {
	cdgo Medieval-Warfare || return
	git pull origin Next -q
	# OpenRA latest engine version
	if [[ $(grep "^AUTOMATIC_ENGINE_SOURCE" < mod.config | cut -d '/' -f 7 | cut -d "." -f 1) == '${ENGINE_VERSION}' ]]; then
		latest_engine_version=$(grep '^ENGINE_VERSION' < mod.config | cut -d '"' -f 2)
	elif [[ $(grep "^AUTOMATIC_ENGINE_SOURCE" < mod.config | cut -d '/' -f 7 | cut -d "." -f 1) == 'MedievalWarfareEngine' ]]; then
		latest_engine_version=$(latest_commit_on_branch $GHUBO/OpenRA-mw)
	fi
	# OpenRA engine version in spec file
	packaged_engine_version=$(grep "define engine\_version" < "$OBSH"/openra-mw/openra-mw.spec | cut -d ' ' -f 3)
	packaged_commit_hash_number=$(git rev-list --branches Next --count)
	packaged_commit_hash_number=$(grep "Version\:" < "$OBSH"/openra-mw/openra-mw.spec | sed 's/Version:\s*//g')
	packaged_commit_hash=$(git log | head -n 1 | cut -d ' ' -f 2)
	packaged_commit_hash=$(grep "define commit" < "$OBSH"/openra-mw/openra-mw.spec | cut -d ' ' -f 3)

	if [[ $packaged_commit_hash_number == $packaged_commit_hash_number ]]; then
		printf "%s\n" "OpenRA Medieval Warfare mod is up to date\!"
	else
		sed -i -e "s/$packaged_commit_hash/$packaged_commit_hash/g" \
			   -e "s/$packaged_commit_hash_number/$packaged_commit_hash_number/g" "$OBSH"/openra-mw/{openra-mw.spec,PKGBUILD}
		if ! [[ "$packaged_engine_version" == "$latest_engine_version" ]]; then
			sed -i -e "s/$packaged_engine_version/$latest_engine_version/g" "$OBSH"/openra-mw/{openra-mw.spec,PKGBUILD}
			make || ( printf "Running make failed" && return )
			tar czvf "$OBSH"/openra-mw/engine-"${latest_engine_version}".tar.gz engine
			cdobsh openra-mw || return
			osc rm engine-"${packaged_engine_version}".tar.gz
			osc add engine-"${latest_engine_version}".tar.gz
			cd - || return
		fi
		cdobsh openra-mw || return
		if ! [[ "$packaged_engine_version" == "$latest_engine_version" ]]; then
			osc ci -m "Bumping $packaged_commit_hash_number->$packaged_commit_hash_number; engine $packaged_engine_version->$latest_engine_version"
		else
			osc ci -m "Bumping $packaged_commit_hash_number->$packaged_commit_hash_number; engine version is unchanged."
		fi
	fi
	openra_mod_appimage_build Medieval-Warfare
	mwnup "${1}"
}
