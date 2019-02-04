function ask2 {
	# Now to check whether changes this function has made to my nixpkgs fork is to be committed. 
	question2="Would you like to change into the nixpkgs directory, add changes (with git add --all) and open a commit message-editing dialogue (with git commit)?"

	if ! echo "$SHELL" | grep zsh > /dev/null 2>&1; then
		read -p "${question2} [y/n] " yn
	else
		read "yn?${question2} [y/n] "
	fi
	# Act on user input
	if [[ "${yn}" == [yY]* ]]; then
		# Commit changes, but allow for an extended commit message
		cdnp
		git add --all
		git commit
		git push origin $(git-branch) -f
	elif [[ "${yn}" == [Nn]* ]]; then
		printf "OK, it's your funeral. Run ask2 again if you change your mind.\n"
	else
		printf "Only [nN]* and [yY]* are accepted inputs.\n Running ask2 again.\n" && ask2
	fi
}

# Ask whether 
function ask {
	question1="Would you like to push the update to fusion809/nixpkgs?"
	# Check whether the shell is Zsh, or not (and as I only use Bash and Zsh this will mean it is Bash)
	if ! echo "$SHELL" | grep zsh > /dev/null 2>&1; then
		read -p "${question1} [y/n] " yn
	else
		read "yn?${question1} [y/n] "
	fi
	# Act on input
	if [[ "${yn}" == [yY]* ]]; then
		# Commit changes
		cdnp
		if ! grep "${1} = .*[bB]uildOpenRAMod" < $OPENRA_NIXPKG_PATH/mods.nix &> /dev/null; then
			push "${1}: :arrow_up: ${2}."
		else
			push "openra-${1}: :arrow_up: ${2}."
		fi
		cd -
	elif [[ "${yn}" == [Nn]* ]]; then
		# Ask another question
		ask2 "$1" "$2"
	else
		printf "Only [yY]* and [nN]* are accepted inputs. Running ask again.\n"
		ask "$1" "$2"
	fi
}

function update_openra_mod_nixpkg {
	# First input is path to mod repo.
	# Second is the line number the mod's version definition appears at.
	# Third is the line on which the commit hash for the mod is listed; it is assumed the next line is where the commit's sha256 is specified.
	# Fourth is the line on which the commit/version for the mod's engine is listed
	# Fifth is the line the engine's source's sha256 is listed
	# Sixth is optional, and basically prevents being asked the question of whether to commit changes to nixpkgs.
	if [[ "${1}" == "-h" ]] || [[ "${1}" == "--help" ]] || ! [[ -n "${1}" ]]; then
		cat <<'EOF' > "/dev/stdout"
First input (or argument) is the path to the mod repository.
Second input is the line number at which the mod version is specified.
Third input is the line number at which the commit hash of the mod itself is.
Fourth argument is the line number at which the mod version or commit hash is specified. 
-->*Beware* it would be prudent to check that the engine repository has not changed, as sometimes it does!
Fifth argument is the line number at which the mod engine checksum (sha256) is specified.
Sixth argument is *optional*, and merely specifies whether changes are committed to nixpkgs or not. 
-->If it is ommitted a prompt will appear asking whether these changes will be made.
EOF
	elif [[ -f "$GHUBO/${1}/mod.config" ]]; then
		mod_repository="$GHUBO/${1}"
	elif ! [[ -f "${1}/mod.config" ]]; then
		printf "%s\n" "Argument one seems invalid, as neither $GHUBO/${mod_repository}, nor ${mod_repository}/mod.config exists."
	else
		mod_repository="${1}"
	fi

	mod_version_line_number="${2}"
	mod_commit_hash_line_number="${3}"

	if sed -n "${4},${4}p" $OPENRA_NIXPKG_PATH/mods.nix | grep version &> /dev/null ; then
		engine_version_line_number="${4}"
	elif sed -n "${4},${4}p" $OPENRA_NIXPKG_PATH/mods.nix | grep commit &> /dev/null ; then
		engine_commit_line_number="${4}"
	else
		printf "Neither the keyword version nor commit is found in line ${4} of mods.nix.\n"
		line=$(sed -n "${4},${4}p" $OPENRA_NIXPKG_PATH/mods.nix)
		printf "Here is line ${4}: \n${line}.\n" && return
	fi

	engine_sha256_line_number="${5}"

	## Commit number (version)
	MOD_ID=$(grep "^MOD_ID" < ${mod_repository}/mod.config | head -n 1 | cut -d '"' -f 2)
	git -C ${mod_repository} pull origin $(git-branch "${mod_repository}") -q || (printf "Git pulling ${mod_repository} at line 44 of ${0} failed.\n" && return)
	new_commit_number=$(latest_commit_number "${mod_repository}")
	printf "%s\n" "The new version (new_commit_number) is ${new_commit_number}."
	sed -i -e "${mod_version_line_number}s|version = \".*\"|version = \"${new_commit_number}\"|" $OPENRA_NIXPKG_PATH/mods.nix || (printf "Sedding mod commit number at line 47 of ${0} failed.\n" && return)

	## Commit hash
	new_commit_hash=$(latest_commit_on_branch "${mod_repository}")
	printf "%s\n" "The new version (new_commit_hash) is ${new_commit_hash}."
	sed -i -e "${mod_commit_hash_line_number}s|rev = \".*\"|rev = \"${new_commit_hash}\"|" $OPENRA_NIXPKG_PATH/mods.nix || (printf "Sedding mod commit hash at line 52 of ${0} failed.\n" && return)

	## Commit hash (engine) / version
	new_engine=$(new_engine_version ${mod_repository})
	printf "%s\n" "The new engine version is ${new_engine}."
	if [[ -n "${engine_version_line_number}" ]]; then
  		sed -i -e "${engine_version_line_number}s|version = \".*\"|version = \"${new_engine}\"|" $OPENRA_NIXPKG_PATH/mods.nix || (printf "Sedding engine revision at line 58 of ${0} failed.\n" && return)
	else
		sed -i -e "${engine_commit_line_number}s|commit = \".*\"|commit = \"${new_engine}\"|" $OPENRA_NIXPKG_PATH/mods.nix || (printf "Sedding engine revision at line 60 of ${0} failed.\n" && return)
	fi

	# Check if either engine, or mod has been updated, 
	# as nix-prefetch can chew up a bit of bandwidth unnecessarily if used when there is no need
	if ( ! [[ "${new_commit_hash}" == "${comprese}" ]] ) || ( ! [[ "${new_engine}" == "${engrevpres}" ]] ); then
		MOD_ID=$(grep "^MOD_ID" < $1/mod.config | head -n 1 | cut -d '"' -f 2)
		printf "MOD_ID is ${MOD_ID}.\n"
		sha256=$(nix-prefetch --force $NIXPKGS openraPackages.mods.${MOD_ID})
		printf "sha256 is ${sha256}.\n"
		# First is the mod's hash, second is engine
		sha256_1=$(echo ${sha256} | head -n 1)
		sha256_2=$(echo ${sha256} | tail -n 1)
		printf "sha256_1 is ${sha256_1}.\n"
		printf "sha256_2 is ${sha256_2}.\n"
		# Update checksums
		sed -i -e "$((${mod_commit_hash_line_number}+1))s|sha256 = \"[a-z0-9]*\"|sha256 = \"${sha256_1}\"|" ${OPENRA_NIXPKG_PATH}/mods.nix || (printf "Sedding mod hash (${sha256_1}) at line 76 of ${0} failed.\n" && return)
		sed -i -e "${engine_sha256_line_number}s|sha256 = \"[a-z0-9]*\"|sha256 = \"${sha256_2}\"|" ${OPENRA_NIXPKG_PATH}/mods.nix || (printf "Sedding engine hash at line 77 of ${0} failed.\n" && return)
	fi

	printf "%s\n" "${MOD_ID} has been updated."

	# Check what argument 6 is and act accordingly.
	if [[ "${6}" == "-y" ]] || [[ "${6}" == "--yes" ]] ; then
		cdnp
		push "openra-${MOD_ID}: :arrow_up: ${new_commit_number}."
		cd -
	elif [[ "${6}" == "-n" ]] || [[ "${6}" == "--no" ]]; then
		yn="n"
	elif ! [[ -n "${6}" ]]; then
		ask "${MOD_ID}" "${new_commit_number}"
	else
		cat <<'EOF' > "/dev/stderr"
Incorrect sixth argument given to nixoup2. This argument determines whether the changes will be committed to my nixpkgs fork.

It can be:

-y/--yes: which will cause the changes to be automatically committed.
-n/--no:  which will cause the changes to be automatically committed. 

If no, or the wrong argument is given, then you will be prompted with a question as to whether you wish to commit the changes.
EOF
		ask "${MOD_ID}" "${new_commit_number}"
	fi
	
}

# The old name for this func.
# It was called nixoup2 because it was the second OpenRA nixpkg update function I wrote
alias nixoup2=update_openra_mod_nixpkg