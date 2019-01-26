function spup {
	#splver=$(git log | head -n 1 | cut -d ' ' -f 2)
	#sppver=$(grep '%define sp_commit' < /home/fusion809/OBS/home:fusion809/openra-sp/openra-sp.spec | sed 's/%define sp_commit //g')
	# Latest engine version
	cdgo SP-OpenRAModSDK || return
	enlv=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
	# OpenRA engine version in spec file
	enpv=$(grep "%define engine\_version" < "$OBSH"/openra-sp/openra-sp.spec | cut -d ' ' -f 3)
	git pull origin Shattered-Paradise-Master
	sdklver=$(git log | head -n 1 | cut -d ' ' -f 2)
	sdklc=$(git rev-list --branches Shattered-Paradise-Master --count)
	sdkpver=$(grep "%define commit" < /home/fusion809/OBS/home:fusion809/openra-sp/openra-sp.spec | sed 's/%define commit //g')
	sdkpc=$(grep "Version:" < /home/fusion809/OBS/home:fusion809/openra-sp/openra-sp.spec | sed 's/Version:\s*//g')

	# If OpenRAModSDK is outdated sed update it
	if [[ "$sdklc" == "$sdkpc" ]]; then
		 printf "%s\n" "SDK is up-to-date!"
	else
		 if ! [[ "$enpv" == "$enlv" ]]; then
			  printf "%s\n" "Updating the game engine to $enlv."
			  sed -i -e "s|${enpv}|${enlv}|g" "$OBSH"/openra-sp/{openra-sp.spec,PKGBUILD} || ( printf "Replacing enpv ($enpv) with enlv ($enlv) failed" && return) 
			  make clean || return
			  make || return
			  tar czvf "$OBSH"/openra-sp/engine-"${enlv}".tar.gz engine
			  cdobsh openra-sp || return
			  osc rm engine-"${enpv}".tar.gz
			  osc add engine-"${enlv}".tar.gz
			  cd - || return
		 fi
		 cdobsh openra-sp || return
		 sed -i -e "s|${sdkpver}|${sdklver}|g" \
		 		-e "s|${sdkpc}$|${sdklc}|g" PKGBUILD openra-sp.spec || ( printf "Replacing sdkpver ($sdkpver) with sdklver ($sdklver) failed" && return )
	fi

	openra_mod_appimage_build SP-OpenRAModSDK
	spnup "${1}"
}
