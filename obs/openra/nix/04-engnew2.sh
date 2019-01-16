function engine_check_and_update {
    engver="${1}"
    engsrc="${2}"
    if [[ "$engver" == "{DEV_VERSION}" ]]; then
		git -C "$GHUBO/$engsrc" checkout bleed -q
        git -C "$GHUBO/$engsrc" pull origin bleed -q
	elif [[ "$engver" == "SP-Bleed-Branch" ]] && [[ $(git-branch $GHUBO/$engsrc) != "SP-Bleed-Branch" ]]; then
		git -C "$GHUBO/$engsrc" checkout SP-Bleed-Branch -q
        git -C "$GHUBO/$engsrc" pull origin SP-Bleed-Branch -q
	elif [[ "${engver}" == "MedievalWarfareEngine" ]] ; then
		git -C "$GHUBO/$engsrc" checkout MedievalWarfareEngine -q
        git -C "$GHUBO/$engsrc" pull origin MedievalWarfareEngine -q
	elif [[ "${engver}" == "DarkReign" ]]; then
		git -C "$GHUBO/$engsrc" checkout DarkReign -q
        git -C "$GHUBO/$engsrc" pull origin DarkReign -q
	else
		git -C "$GHUBO/$engsrc" checkout "${engver}" -q
        git -C "$GHUBO/$engsrc" pull origin ${engver} -q
	fi
}

function new_engine_version {
    #MOD_ID is
    MOD_ID=$(grep "^MOD_ID" < $1/mod.config | head -n 1 | cut -d '"' -f 2)
	# This does assume that if ENGINE_VERSION is {DEV_VERSION} my local copy of the engine repo is on the right branch for 
	# the mod, e.g. that OpenRA-mw is on the MedievalWarfareEngine branch
	# engine version per mod.config
	engver=$(grep "^ENGINE\_VERSION" < $1/mod.config | cut -d '"' -f 2)
    # What comes after archive in AUTOMATIC_ENGINE_SOURCE
	engver_src=$(grep "^AUTOMATIC_ENGINE_SOURCE" < $1/mod.config | cut -d '/' -f 7 | sed 's/\..*//g')
#    printf "engver_src is $engver_src.\n"
	# The engine's repo name
	engsrc=$(grep "^AUTOMATIC_ENGINE_SOURCE" < $1/mod.config | cut -d '/' -f 5)
#    printf "engsrc originally was $engsrc.\n"
	engown=$(grep "^AUTOMATIC_ENGINE_SOURCE" < $1/mod.config | cut -d '/' -f 4)
#    printf "engown is $engown.\n"
    if [[ $engown != "OpenRA" ]] && [[ $engsrc == "OpenRA" ]]; then
        engsrc="OpenRA-${MOD_ID}"
    fi
#    printf "engsrc is now $engsrc.\n"
#    printf "engown is $engown.\n"
	if [[ "${engver_src}" == '${ENGINE_VERSION}' ]]; then
		if echo $engver | grep "[0-9]" &> /dev/null ; then
			printf $engver
		else
            engine_check_and_update $engver $engsrc
			engver=$(latest_commit_on_branch $GHUBO/$engsrc)
			printf ${engver}
		fi
	else
		engver="${engver_src}"
		engine_check_and_update $engver $engsrc
		git -C "$GHUBO/$engsrc" pull origin ${engver} -q
		engver=$(latest_commit_on_branch $GHUBO/$engsrc)
		printf "${engver}"
	fi
}

alias engnew=new_engine_version