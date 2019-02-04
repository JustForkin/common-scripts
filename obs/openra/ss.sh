function ssup {
	cdgo sole-survivor || return
	git pull origin master -q
	# OpenRA latest engine version utilized by mod
	latest_engine_version=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
	# OpenRA engine version in spec file
	packaged_engine_version=$(grep "define engine\_version" < "$OBSH"/openra-ss/openra-ss.spec | cut -d ' ' -f 3)
	latest_commit_no=$(latest_commit_number)
	packaged_commit_number=$(vere openra-ss)
	latest_commit_hash=$(latest_commit_on_branch)
	packaged_commit_hash=$(come openra-ss)

	if [[ $packaged_commit_number == $latest_commit_no ]]; then
		 printf "e[1;32m%-0se[m\n" "OpenRA Sole Survivor is up-to-date\!"
	else
		 printf "Updating openra-ss spec file and PKGBUILD.\n"
		 sed -i -e "s/$packaged_commit_hash/$latest_commit_hash/g" \
		 		-e "s/$packaged_commit_number/$latest_commit_no/g" "$OBSH"/openra-ss/{openra-ss.spec,PKGBUILD}
		 if ! [[ "$packaged_engine_version" == "$latest_engine_version" ]]; then
			  printf "Updating OpenRA Sole Survivor engine.\n"
			  sed -i -e "s/$packaged_engine_version/$latest_engine_version/g" "$OBSH"/openra-ss/{openra-ss.spec,PKGBUILD}
			  make clean || return
			  make || ( printf "Running make failed" && return )
			  tar czvf "$OBSH"/openra-ss/engine-"${latest_engine_version}".tar.gz engine
			  cdobsh openra-ss || return
			  osc rm engine-"${packaged_engine_version}".tar.gz
			  osc add engine-"${latest_engine_version}".tar.gz
			  cd - || return
		 fi
		 printf "%s\n" "Comitting changes."
		 cdobsh openra-ss
		 osc ci -m "Bumping $packaged_commit_number->$latest_commit_no"
	fi
	openra_mod_appimage_build ss
	ssnup "${1}"
}
