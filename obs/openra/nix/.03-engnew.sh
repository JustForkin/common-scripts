function engnew {
	# This does assume that if ENGINE_VERSION is {DEV_VERSION} my local copy of the engine repo is on the right branch for 
	# the mod, e.g. that OpenRA-mw is on the MedievalWarfareEngine branch
	# engine version per mod.config
	engver=$(grep "^ENGINE\_VERSION" < $1/mod.config | cut -d '"' -f 2)
	engver_src=$(grep "^AUTOMATIC_ENGINE_SOURCE" < $1/mod.config | cut -d '/' -f 7 | sed 's/\..*//g')
	# The engine's repo name
	engsrc=$(grep "^AUTOMATIC_ENGINE_SOURCE" < $1/mod.config | cut -d '/' -f 5)
	engown=$(grep "^AUTOMATIC_ENGINE_SOURCE" < $1/mod.config | cut -d '/' -f 4)
	MOD_ID=$(grep "^MOD_ID" < $1/mod.config | head -n 1 | cut -d '"' -f 2)
	if [[ "${engver_src}" == '${ENGINE_VERSION}' ]]; then
		if echo $engver | grep "[0-9]" &> /dev/null ; then
			printf $engver
		else
			if [[ "$engver" == "{DEV_VERSION}" ]]; then
				git -C "$GHUBO/$engsrc" checkout bleed
			elif [[ "$engver" == "SP-Bleed-Branch" ]] && [[ $(git-branch $GHUBO/$engsrc) != "SP-Bleed-Branch" ]]; then
				git -C "$GHUBO/$engsrc" checkout SP-Bleed-Branch
			elif [[ "${engver}" == "MedievalWarfareEngine" ]] ; then
				git -C "$GHUBO/$engsrc" checkout MedievalWarfareEngine
			elif [[ "${engver}" == "DarkReign" ]]; then
				git -C "$GHUBO/$engsrc" checkout DarkReign
			else
				git -C "$GHUBO/$engsrc" checkout ${engver}
			fi
			git -C "$GHUBO/$engsrc" pull origin $(git-branch $GHUBO/$engsrc) -q
			engver=$(loge $GHUBO/$engsrc)
			printf ${engver}
		fi
	else
		engver="${engver_src}"
		if [[ "$engver" == "{DEV_VERSION}" ]]; then
			git -C "$GHUBO/$engsrc" checkout bleed
		elif [[ "$engver" == "SP-Bleed-Branch" ]] && [[ $(git-branch $GHUBO/$engsrc) != "SP-Bleed-Branch" ]]; then
			git -C "$GHUBO/$engsrc" checkout SP-Bleed-Branch
		elif [[ "${engver}" == "MedievalWarfareEngine" ]] ; then
			git -C "$GHUBO/$engsrc" checkout MedievalWarfareEngine
		elif [[ "${engver}" == "DarkReign" ]]; then
			git -C "$GHUBO/$engsrc" checkout DarkReign
		else
			git -C "$GHUBO/$engsrc" checkout ${engver}
		fi
		git -C "$GHUBO/$engsrc" pull origin $(git-branch $GHUBO/$engsrc) -q
		engver=$(loge $GHUBO/$engsrc)
		printf "${engver}"
	fi