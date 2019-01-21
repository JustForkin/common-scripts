function engine_check_and_update {
    latest_engine_version="${1}"
    engine_repository_name="${2}"
    if [[ "$latest_engine_version" == "{DEV_VERSION}" ]]; then
		git -C "$GHUBO/$engine_repository_name" checkout bleed -q
        git -C "$GHUBO/$engine_repository_name" pull origin bleed -q
	elif [[ "$latest_engine_version" == "SP-Bleed-Branch" ]] && [[ $(git-branch $GHUBO/$engine_repository_name) != "SP-Bleed-Branch" ]]; then
		git -C "$GHUBO/$engine_repository_name" checkout SP-Bleed-Branch -q
        git -C "$GHUBO/$engine_repository_name" pull origin SP-Bleed-Branch -q
	elif [[ "${latest_engine_version}" == "MedievalWarfareEngine" ]] ; then
		git -C "$GHUBO/$engine_repository_name" checkout MedievalWarfareEngine -q
        git -C "$GHUBO/$engine_repository_name" pull origin MedievalWarfareEngine -q
	elif [[ "${latest_engine_version}" == "DarkReign" ]]; then
		git -C "$GHUBO/$engine_repository_name" checkout DarkReign -q
        git -C "$GHUBO/$engine_repository_name" pull origin DarkReign -q
	else
		git -C "$GHUBO/$engine_repository_name" checkout "${latest_engine_version}" -q
        git -C "$GHUBO/$engine_repository_name" pull origin ${latest_engine_version} -q
	fi
}

function new_engine_version {
    #MOD_ID is
    MOD_ID=$(grep "^MOD_ID" < $1/mod.config | head -n 1 | cut -d '"' -f 2)
	# This does assume that if ENGINE_VERSION is {DEV_VERSION} my local copy of the engine repo is on the right branch for 
	# the mod, e.g. that OpenRA-mw is on the MedievalWarfareEngine branch
	# engine version per mod.config
	latest_engine_version=$(grep "^ENGINE\_VERSION" < $1/mod.config | cut -d '"' -f 2)
    # What comes after archive in AUTOMATIC_ENGINE_SOURCE
	latest_engine_version_src=$(grep "^AUTOMATIC_ENGINE_SOURCE" < $1/mod.config | cut -d '/' -f 7 | sed 's/\..*//g')
	# The engine's repo name
	engine_repository_name=$(grep "^AUTOMATIC_ENGINE_SOURCE" < $1/mod.config | cut -d '/' -f 5)
#    printf "engine_repository_name originally was $engine_repository_name.\n"
	engine_repository_owner=$(grep "^AUTOMATIC_ENGINE_SOURCE" < $1/mod.config | cut -d '/' -f 4)
#    printf "engine_repository_owner is $engine_repository_owner.\n"
    if [[ $engine_repository_owner != "OpenRA" ]] && [[ $engine_repository_name == "OpenRA" ]]; then
        engine_repository_name="OpenRA-${MOD_ID}"
    fi
#    printf "engine_repository_name is now $engine_repository_name.\n"
#    printf "engine_repository_owner is $engine_repository_owner.\n"
	if [[ "${latest_engine_version_src}" == '${ENGINE_VERSION}' ]]; then
		if echo $latest_engine_version | grep "[0-9]" &> /dev/null ; then
			printf $latest_engine_version
		else
            engine_check_and_update $latest_engine_version $engine_repository_name
			latest_engine_version=$(latest_commit_on_branch $GHUBO/$engine_repository_name)
			printf ${latest_engine_version}
		fi
	else
		latest_engine_version="${latest_engine_version_src}"
		engine_check_and_update $latest_engine_version $engine_repository_name
		git -C "$GHUBO/$engine_repository_name" pull origin ${latest_engine_version} -q
		latest_engine_version=$(latest_commit_on_branch $GHUBO/$engine_repository_name)
		printf "${latest_engine_version}"
	fi

	if [[ "$2" == "--debug" ]]; then
		printf "\n%s\n" "MOD_ID is ${MOD_ID}."
		printf "%s\n" "latest_engine_version is ${latest_engine_version}."
    	printf "%s\n" "latest_engine_version_src is ${latest_engine_version_src}."
		printf "%s\n" "engine_repository_name is ${engine_repository_name}."
		printf "%s\n" "engine_repository_owner is ${engine_repository_owner}."
	fi
}

alias engnew=new_engine_version