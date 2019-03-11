# RA Classic update
# Last latest_commit_hashit with OBS version is d69ef4c3eb12f8a4324d7322d592223ad71f68ea
#function racup {
	# A larger racup func was used in latest_commit_hashit eb723d4af07bf2a72038a938525f18cd98df2699 and earlier
#	openra_mod_appimage_build raclassic
#}
function racup {
	cdgo raclassic || return
	git pull origin master -q
	# OpenRA latest engine version
	latest_engine_version=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
	# OpenRA engine version in spec file
	packaged_engine_version=$(grep "define engine\_version" < "$OBSH"/openra-raclassic/openra-raclassic.spec | cut -d ' ' -f 3)
	latest_commit_no=$(latest_commit_number)
	packaged_commit_number=$(vere openra-raclassic)
	latest_commit_hash=$(latest_commit_on_branch)
	packaged_commit_hash=$(come openra-raclassic)

	if [[ $packaged_commit_number == $latest_commit_no ]]; then
		 printf "e[1;32m%-0se[m\n" "OpenRA raclassic is up-to-date\!"
	else
		 printf "Updating openra-raclassic spec file and PKGBUILD.\n"
		 sed -i -e "s/$packaged_commit_hash/$latest_commit_hash/g" \
		 		-e "s/$packaged_commit_number/$latest_commit_no/g" "$OBSH"/openra-raclassic/{openra-raclassic.spec,PKGBUILD}
		 if ! [[ "$packaged_engine_version" == "$latest_engine_version" ]]; then
			  printf "Updating OpenRA Red Alert 2 engine.\n"
			  sed -i -e "s/$packaged_engine_version/$latest_engine_version/g" "$OBSH"/openra-raclassic/{openra-raclassic.spec,PKGBUILD}
			  make clean || return
			  make || ( printf "Running make failed" && return )
			  tar czvf "$OBSH"/openra-raclassic/engine-"${latest_engine_version}".tar.gz engine
			  cdobsh openra-raclassic || return
			  osc rm engine*.tar.gz
			  osc add engine-"${latest_engine_version}".tar.gz
			  cd - || return
		 fi
		 printf "%s\n" "Comitting changes."
		 cdobsh openra-raclassic
		 osc ci -m "Bumping $packaged_commit_number->$latest_commit_no"
	fi
	openra_mod_appimage_build raclassic
	racnup "${1}"
}
