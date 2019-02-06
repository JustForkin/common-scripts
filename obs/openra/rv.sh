function rvup {
	cdgo rv || return
	git pull origin master -q
	# OpenRA latest engine version
	latest_engine_version=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
	# OpenRA engine version in spec file
	packaged_engine_version=$(grep "define engine\_version" < "$OBSH"/openra-rv/openra-rv.spec | cut -d ' ' -f 3)
	latest_commit_no=$(latest_commit_number)
	packaged_commit_number=$(vere openra-rv)
	latest_commit_hash=$(latest_commit_on_branch)
	packaged_commit_hash=$(come openra-rv)

	if [[ $packaged_commit_number == $latest_commit_no ]]; then
		 printf "e[1;32m%-0se[m\n" "OpenRA Romanov's Vengeance is up-to-date\!"
	else
		 printf "Updating openra-rv spec file and PKGBUILD.\n"
		 sed -i -e "s/$packaged_commit_hash/$latest_commit_hash/g" \
		 		-e "s/$packaged_commit_number/$latest_commit_no/g" "$OBSH"/openra-rv/{openra-rv.spec,PKGBUILD}
		 if  [[ "$packaged_engine_version" == "$latest_engine_version" ]]; then
			  printf "Updating OpenRA Romanov's Vengeance engine.\n"
			  sed -i -e "s/$packaged_engine_version/$latest_engine_version/g" "$OBSH"/openra-rv/{openra-rv.spec,PKGBUILD}
			  make clean || return
			  make || ( printf "Running make failed" && return )
			  tar czvf "$OBSH"/openra-rv/engine-"${latest_engine_version}".tar.gz engine
			  cdobsh openra-rv || return
			  osc rm engine*.tar.gz
			  osc add engine-"${latest_engine_version}".tar.gz
			  cd - || return
		 fi
		 printf "%s\n" "Comitting changes."
		 cdobsh openra-rv
		 osc ci -m "Bumping $packaged_commit_number->$latest_commit_no"
	fi
	openra_mod_appimage_build rv
	rvnup "${1}"
}
