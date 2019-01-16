function update_openra_mod_nixpkg {
	# First input is path to mod repo
	# Second is the mod's number, with respect to its position in mods.nix (e.g. 1 for CA, 2 for D2, 3 for DR, etc.)
	# Third is the line on which the version for the mod is listed
	# Fourth is the line on which the commit for the mod is listed
	# Fifth is the line on which the commit/version for the mod's engine is listed
	# Sixth is the line the engine's source's sha256 is listed
	## Commit number (version)
	MOD_ID=$(grep "^MOD_ID" < $1/mod.config | head -n 1 | cut -d '"' -f 2)
	git -C ${1} pull origin $(git-branch "${1}") -q || (printf "Git pulling ${1} at line 10 of 05-nixoup2.sh failed.\n" && return)
	new_commit_number=$(latest_commit_number "${1}")
	printf "%s\n" "The new version (new_commit_number) is ${new_commit_number}."
	sed -i -e "${2}s|version = \".*\"|version = \"${new_commit_number}\"|" $OPENRA_NIXPKG_PATH/mods.nix || (printf "Sedding mod commit number at line 13 of 05-nixoup2.sh failed.\n" && return)

	## Commit hash
	new_commit_hash=$(latest_commit_on_branch "${1}")
	printf "%s\n" "The new version (new_commit_hash) is ${new_commit_hash}."
	sed -i -e "${3}s|rev = \".*\"|rev = \"${new_commit_hash}\"|" $OPENRA_NIXPKG_PATH/mods.nix || (printf "Sedding mod commit hash at line 18 of 05-nixoup2.sh failed.\n" && return)

	## Commit hash (engine) / version
	new_engine=$(new_engine_version ${1})
	printf "%s\n" "The new engine version is ${new_engine}."
	if sed -n "${4},${4}p" $OPENRA_NIXPKG_PATH/mods.nix | grep version &> /dev/null ; then
  	sed -i -e "${4}s|version = \".*\"|version = \"${new_engine}\"|" $OPENRA_NIXPKG_PATH/mods.nix || (printf "Sedding engine revision at line 24 of 05-nixoup2.sh failed.\n" && return)
	elif sed -n "${4},${4}p" $OPENRA_NIXPKG_PATH/mods.nix | grep commit &> /dev/null ; then
		sed -i -e "${4}s|commit = \".*\"|commit = \"${new_engine}\"|" $OPENRA_NIXPKG_PATH/mods.nix || (printf "Sedding engine revision at line 26 of 05-nixoup2.sh failed.\n" && return)
	else
		printf "Neither the keyword version or commit is found in line ${4} of mods.nix.\n"
		line=$(sed -n "${4},${4}p" $OPENRA_NIXPKG_PATH/mods.nix)
		printf "Here is line ${4}: \n${line}.\n"
	fi

	# Check if either engine, or mod has been updated, 
	# as nix-prefetch can chew up a bit of bandwidth unnecessarily if used when there is no need
	if ( ! [[ "$new_commit_hash" == "$comprese" ]] ) || ( ! [[ "$new_engine" == "$engrevpres" ]] ); then
		MOD_ID=$(grep "^MOD_ID" < $1/mod.config | head -n 1 | cut -d '"' -f 2)
		printf "MOD_ID is $MOD_ID.\n"
		sha256=$(nix-prefetch --force $NIXPKGS openraPackages.mods.${MOD_ID})
		printf "sha256 is $sha256.\n"
		# First is the mod's hash, second is engine
		sha256_1=$(echo $sha256 | head -n 1)
		sha256_2=$(echo $sha256 | tail -n 1)
		printf "sha256_1 is $sha256_1.\n"
		printf "sha256_2 is $sha256_2.\n"

		sed -i -e "$((${3}+1))s|sha256 = \"[a-z0-9]*\"|sha256 = \"${sha256_1}\"|" $OPENRA_NIXPKG_PATH/mods.nix || (printf "Sedding mod hash (${sha256_1}) at line 46 of 05-nixoup2.sh failed.\n" && return)
		sed -i -e "${5}s|sha256 = \"[a-z0-9]*\"|sha256 = \"${sha256_2}\"|" $OPENRA_NIXPKG_PATH/mods.nix || (printf "Sedding engine hash at line 47 of 05-nixoup2.sh failed.\n" && return)
	fi
	printf "%s\n" "${MOD_ID} has been updated.\n"
	question="Would you like to push the update to fusion809/nixpkgs?"
	if ! echo "$SHELL" | grep zsh > /dev/null 2>&1; then
		read -p "${question} [y/n] " yn
	else
		read "yn?${question} [y/n] "
	fi
	if [[ $yn == [yY]* ]]; then
		cdnp
		push "openra-${MOD_ID}: :arrow_up: ${new_commit_number}."
		cd -
	fi
}

alias nixoup2=update_openra_mod_nixpkg