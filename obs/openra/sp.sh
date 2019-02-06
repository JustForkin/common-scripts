function spup {
	#splver=$(git log | head -n 1 | cut -d ' ' -f 2)
	#sppver=$(grep '%define sp_latest_commit_hashit' < /home/fusion809/OBS/home:fusion809/openra-sp/openra-sp.spec | sed 's/%define sp_latest_commit_hashit //g')
	# Latest engine version
	cdgo SP-OpenRAModSDK || return
	latest_engine_version=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
	if [[ $latest_engine_version = "SP-Bleed-Branch" ]]; then
		latest_engine_version=$(git -C $GHUBO/OpenRA-sp log | head -n 1 | cut -d ' ' -f 2)
	fi
	# OpenRA engine version in spec file
	packaged_engine_version=$(grep "%define engine\_version" < "$OBSH"/openra-sp/openra-sp.spec | cut -d ' ' -f 3)
	git pull origin Shattered-Paradise-Master
	sdklver=$(git log | head -n 1 | cut -d ' ' -f 2)
	sdklc=$(git rev-list --branches Shattered-Paradise-Master --count)
	sdkpver=$(grep "%define commit" < /home/fusion809/OBS/home:fusion809/openra-sp/openra-sp.spec | sed 's/%define commit //g')
	sdkpc=$(grep "Version:" < /home/fusion809/OBS/home:fusion809/openra-sp/openra-sp.spec | sed 's/Version:\s*//g')

	# If OpenRAModSDK is outdated sed update it
	if [[ "$sdklc" == "$sdkpc" ]]; then
		 printf "\e[1;32m%-0s\e[m\n" "SDK is up-to-date\!"
	else
		 if ! [[ "$packaged_engine_version" == "$latest_engine_version" ]]; then
			  printf "%s\n" "Updating the game engine to $latest_engine_version."
			  sed -i -e "s|${packaged_engine_version}|${latest_engine_version}|g" "$OBSH"/openra-sp/{openra-sp.spec,PKGBUILD} || ( printf "Replacing packaged_engine_version ($packaged_engine_version) with latest_engine_version ($latest_engine_version) failed" && return) 
			  make clean || return
			  make || ( printf "Running make failed" && return )
			  tar czvf "$OBSH"/openra-sp/engine-"${latest_engine_version}".tar.gz engine
			  cdobsh openra-sp || return
			  osc rm engine*.tar.gz
			  osc add engine-"${latest_engine_version}".tar.gz
			  cd - || return
		 fi
		 cdobsh openra-sp || return
		 sed -i -e "s|${sdkpver}|${sdklver}|g" \
		 		-e "s|${sdkpc}$|${sdklc}|g" PKGBUILD openra-sp.spec || ( printf "Replacing sdkpver ($sdkpver) with sdklver ($sdklver) failed.\n" && return )
	fi

	openra_mod_appimage_build SP-OpenRAModSDK
	spnup "${1}"
}
