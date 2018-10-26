function spup {
	cdgo Shattered-Paradise || exit
	splver=$(git log | head -n 1 | cut -d ' ' -f 2)
	sppver=$(grep 'sp_commit' < /home/fusion809/OBS/home:fusion809/openra-sp/openra-sp.spec | sed 's/%define sp_commit //g')
	# Latest engine version
	enlv=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
	# OpenRA engine version in spec file
	enpv=$(grep "define engine\_version" < "$OBSH"/openra-sp/openra-sp.spec | cut -d ' ' -f 3)
	cd ../SP-OpenRAModSDK || exit
	sdklver=$(git log | head -n 1 | cut -d ' ' -f 2)
	sdklc=$(git rev-list --brarnches master --count)
	sdkpver=$(grep "commit" < cat /home/fusion809/OBS/home:fusion809/openra-sp/openra-sp.spec | sed 's/%define commit //g')
	sdkpc=$(grep "Version:" < /home/fusion809/OBS/home:fusion809/openra-sp/openra-sp.spec | sed 's/Version:\s*//g')

	# If OpenRAModSDK is outdated sed update it
	if [[ "$sdklc" == "$sdkpc" ]]; then
		 printf "%s\n" "SDK is up-to-date!"
	else
		 if ! [[ "$enpv" == "$enlv" ]]; then
			  printf "%s\n" "Updating the game engine to $enlv."
			  sed -i -e "s/$enpv/$enlv/g" "$OBSH"/openra-sp/{openra-sp.spec,PKGBUILD}
			  make clean || exit
			  make || exit
			  tar czvf "$OBSH"/openra-sp/engine-"${enlv}".tar.gz engine
			  cdobsh openra-sp || exit
			  osc rm engine-"${enpv}".tar.gz
			  osc add engine-"${enlv}".tar.gz
			  cd - || exit
		 fi
		 cdobsh openra-sp || exit
		 sed -i -e "s|$sdkpc|$sdklc|g" \
				-e "s|$sdkpver|$sdklver|g" openra-sp.spec
	fi

	# If Shattered Paradise is outdated sed update it
	if [[ "$splver" == "$sppver" ]]; then
		 printf "%s\n" "Latest Shattered Paradise commit is packaged!"
	else
		 cdobsh openra-sp || exit
		 sed -i -e "s|$sppver|$splver|g" openra-sp.spec
	fi

	# If OpenRAModSDK or Shattered Paradise repo is outdated commit updtae to repo
	if ! [[ "$sdkpver" == "$sdkpver" ]] || ! [[ "$splver" == "$sppver" ]]; then
		 cdobsh openra-sp || exit
		 osc ci -m "Bumping to SDK: $sdklc ($sdklver); SP: $splver"
	fi
	mod-build SP-OpenRAModSDK
}
