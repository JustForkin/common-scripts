function ra2up {
	cdgo ra2 || return
	git pull origin master -q
	# OpenRA latest engine version
	latest_engine_version=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
	# OpenRA engine version in spec file
	packaged_engine_version=$(grep "define engine\_version" < "$OBSH"/openra-ra2/openra-ra2.spec | cut -d ' ' -f 3)
	latest_commit_number=$(latest_commit_number)
	packaged_commit_number=$(vere openra-ra2)
	latest_commit_hash=$(latest_commit_on_branch)
	packaged_commit_hash=$(come openra-ra2)

	if [[ "${packaged_commit_number}" == "${latest_commit_number}" ]]; then
		 printf "OpenRA RA2 is up-to-date!\n"
	else
		 printf "Updating openra-ra2 spec file and PKGBUILD.\n"
		 sed -i -e "s/${packaged_commit_hash}/${latest_commit_hash}/g" \
		 		-e "s/${packaged_commit_number}/${latest_commit_number}/g" "$OBSH"/openra-ra2/{openra-ra2.spec,PKGBUILD}
		 if ! [[ "${packaged_engine_version}" == "${latest_engine_version}" ]]; then
			  printf "Updating OpenRA Red Alert 2 engine.\n"
			  sed -i -e "s/${packaged_engine_version}/${latest_engine_version}/g" "$OBSH"/openra-ra2/{openra-ra2.spec,PKGBUILD}
			  make clean || return
			  make || return
			  tar czvf "$OBSH"/openra-ra2/engine-"${latest_engine_version}".tar.gz engine
			  cdobsh openra-ra2 || return
			  osc rm engine-"${packaged_engine_version}".tar.gz
			  osc add engine-"${latest_engine_version}".tar.gz
			  cd - || return
		 fi
		 printf "%s\n" "Comitting changes."
		 cdobsh openra-ra2
		 osc ci -m "Bumping ${packaged_commit_number}->${latest_commit_number}"
	fi
	openra_mod_appimage_build ra2
	ra2nup "${1}"
}
