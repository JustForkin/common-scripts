function kkndup {
	cdgo kknd || return
	git pull origin master -q
	# OpenRA latest engine version
	latest_engine_version=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
	# OpenRA engine version in spec file
	packaged_engine_version=$(grep "define engine\_version" < "$OBSH"/openra-kknd/openra-kknd.spec | cut -d ' ' -f 3)
	latest_commit_no=$(latest_commit_number)
	packaged_commit_number=$(vere openra-kknd)
	latest_commit_hash=$(latest_commit_on_branch)
	packaged_commit_hash=$(come openra-kknd)

	if [[ $packaged_commit_number == $latest_commit_no ]]; then
		 printf "OpenRA KKnD is up-to-date\!\n"
	else
		 printf "Updating openra-kknd spec file and PKGBUILD.\n"
  		 sed -i -e "s/$packaged_commit_hash/$latest_commit_hash/g" \
			    -e "s/$packaged_commit_number/$latest_commit_no/g" "$OBSH"/openra-kknd/{openra-kknd.spec,PKGBUILD}
		 if ! [[ "$packaged_engine_version" == "$latest_engine_version" ]]; then
			  printf "Updating OpenRA Krush, Kill n' Destroy engine.\n"
			  sed -i -e "s/$packaged_engine_version/$latest_engine_version/g" "$OBSH"/openra-kknd/{openra-kknd.spec,PKGBUILD}
			  make clean || return
			  make || ( printf "Running make failed" && return )
			  tar czvf "$OBSH"/openra-kknd/engine-"${latest_engine_version}".tar.gz engine
			  cdobsh openra-kknd || return
			  osc rm engine-"${packaged_engine_version}".tar.gz
			  osc add engine-"${latest_engine_version}".tar.gz
			  cd - || return
		 fi
		 printf "%s\n" "Comitting changes."
		 cdobsh openra-kknd
		 osc ci -m "Bumping $packaged_commit_number->$latest_commit_no"
	fi
	openra_mod_appimage_build kknd
	kkndnup "${1}"
}
