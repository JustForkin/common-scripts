# OpenRA mod Nixpkg updater
# sha256 nix-prefetch-url lines are commented out as they do not give the correct sha256
function nixoup {
	# Change to mod source directory
	cd $GHUBO/"$1"
	# Determine mod name
	MOD=$(grep "^MOD_ID" < mod.config | cut -d '"' -f 2)
	# Print mod name (largely to check for errors)
	printf '\e[1;32m%-6s\e[m\n' "Mod name is $MOD."
	# Stash changes, so that pull works fine
	git stash -q || { printf '\e[1;31m%-6s\e[m\n' "git stashin' failed, so exiting." && return }
	# Pull upstream changes
	git pull origin $(git-branch) -q || { printf '\e[1;31m%-6s\e[m\n' "git pullin' on branch $(git-branch) failed." && return }
	# Present commit number
	numbc=$(git rev-list --branches $(git-branch) --count)
	printf '\e[1;32m%-6s\e[m\n' "Current commit number (numbc) is ${numbc}."
	# Present commit hash
	commitc=$(loge)
	printf '\e[1;32m%-6s\e[m\n' "Current commit hash (commitc) is ${commitc}."
	# Engine name
	enginec=$(grep "^ENGINE_VERSION" < mod.config | cut -d '"' -f 2)
	printf '\e[1;32m%-6s\e[m\n' "Current engine version (enginec) is ${enginec}."
	if [[ $enginec == "{DEV_VERSION}" ]]; then
		git -C $GHUBO/OpenRA pull origin bleed
		enginec=$(git -C $GHUBO/OpenRA log | head -n 1 | cut -d ' ' -f 2)
	fi
	# Presently packaged versions
	enginen=$(grep '^\s*engine-version' < $NIXPKGS/pkgs/games/openra-$MOD/default.nix | cut -d '"' -f 2)
	printf '\e[1;32m%-6s\e[m\n' "Presently packaged engine version (enginen) is ${enginen}."
	numbn=$(grep "^\s*version" < $NIXPKGS/pkgs/games/openra-$MOD/default.nix | cut -d '"' -f 2)
	printf '\e[1;32m%-6s\e[m\n' "Presently packaged commit number (numbn) is ${numbn}."
	commitn=$(grep "^\s*rev" < $NIXPKGS/pkgs/games/openra-$MOD/default.nix | head -n 1 | cut -d '"' -f 2)
	printf '\e[1;32m%-6s\e[m\n' "Presently packaged commit hash (commitn) is ${commitn}."
	if [[ ${commitn} == ${commitc} ]]; then
		return
	fi
	# Mod itself
	owner1=$(grep "owner" < $NIXPKGS/pkgs/games/openra-${MOD}/default.nix | head -n 1 | cut -d '"' -f 2)
	printf '\e[1;32m%-6s\e[m\n' "Mod repo's owner (owner1) is ${owner1}."
	repo1=$(grep "repo" < $NIXPKGS/pkgs/games/openra-${MOD}/default.nix | head -n 1 | cut -d '"' -f 2)
	printf '\e[1;32m%-6s\e[m\n' "Mod repo's name (repo1) is ${repo1}."
	# Nixpkg checksum for mod's latest commit's tar archive
	#nix-prefetch-url https://github.com/$owner1/$repo1/archive/${commitc}.tar.gz &> /tmp/sha256_1
	#sha256 for this archive
	#sha256_1=$(cat /tmp/sha256_1 | tail -n 1)
	#printf '\e[1;32m%-6s\e[m\n' "Checksum for mod's latest commit's tar archive (sha256_1) is ${sha256_1}."
	# Engine
	# Owner name
	owner2=$(grep "owner" < $NIXPKGS/pkgs/games/openra-${MOD}/default.nix | head -n 3 | tail -n 1 | cut -d '"' -f 2)
	printf '\e[1;32m%-6s\e[m\n' "Engine owner's name (owner2) is ${owner2}."
	# Repo name
	repo2=$(grep "repo" < $NIXPKGS/pkgs/games/openra-${MOD}/default.nix | head -n 3 | tail -n 1 | cut -d '"' -f 2)
	printf '\e[1;32m%-6s\e[m\n' "Engine repo's name (repo2) is ${repo2}."
	# Checksum for tar repo2's archive
	#nix-prefetch-url https://github.com/$owner2/$repo2/archive/${enginec}.tar.gz &> /tmp/sha256_2
	#sha256_2=$(cat /tmp/sha256_2 | tail -n 1)
	# Below two lines are from the first sed to appear below
	#			   -e "26s|sha256 = \".*\"|sha256 = \"${sha256_1}\"|" \
	#			   -e "33s|sha256 = \".*\"|sha256 = \"${sha256_2}\"|" \
	# This line is from the second sed
	# 			   -e "26s|sha256 = \".*\"|sha256 = \"${sha256_1}\"|" \
	# printf '\e[1;32m%-6s\e[m\n' "Checksum for the engine's tar archive (sha256_2) is ${sha256_2}."
	# rm /tmp/sha256*
    # Update engine and mod, if needed, otherwise just update the mod itself
	if ! [[ ${enginen} == ${enginec} ]]; then
		sed -i -e "13s|${numbn}|${numbc}|" \
		       -e "25s|${commitn}|${commitc}|" \
		       -e "14s|${enginen}|${enginec}|" \
			   -e "26s|sha256 = \".*\"|sha256 = \"1q5jbkpyhz1p0n7w0v8g6l8p3xcbnmcn0hvf3wxxs48n6fjyw6f9\"|" \
			   -e "33s|sha256 = \".*\"|sha256 = \"1q5jbkpyhz1p0n7w0v8g6l8p3xcbnmcn0hvf3wxxs48n6fjyw6f2\"|" \
			   $NIXPKGS/pkgs/games/openra-${MOD}/default.nix
	else
		sed -i -e "13s|${numbn}|${numbc}|g" \
		       -e "25s|${commitn}|${commitc}|g" \
			   -e "26s|sha256 = \".*\"|sha256 = \"1q5jbkpyhz1p0n7w0v8g6l8p3xcbnmcn0hvf3wxxs48n6fjyw694\"|" \
			   $NIXPKGS/pkgs/games/openra-${MOD}/default.nix
	fi
	cd "/data/GitHub/mine/packaging/nixpkgs/pkgs/games/openra-${MOD}"
	nixb
	# Build package, to get sha256
	printf "You will have to update the sha256 field of /data/GitHub/mine/packaging/nixpkgs/pkgs/games/openra-${MOD}/default.nix,\n"
	printf 'based on the output of nix-env -f $NIXPKGS -iA openra-'
	printf "${MOD}\n"
}

# openra-build-all builds all OpenRA mods as AppImages. If one fails it continues on.
# Function takes a singular input: the name of the folder used by the mod in $HOME/GitHub/others
function mod-build {
	cd $GHUBO/"$1"
	MOD=$(grep "^MOD_ID" < mod.config | cut -d '"' -f 2)
	printf '\e[1;32m%-6s\e[m\n' "Mod name is $MOD."
	git stash -q || { printf '\e[1;31m%-6s\e[m\n' "git stashin' failed." && return }
	git pull origin $(git-branch) -q || { printf '\e[1;31m%-6s\e[m\n' "git pullin' on branch $(git-branch) failed." && return }
	# Present commit number
	numbc=$(git rev-list --branches $(git-branch) --count)
	# Present commit
	commitc=$(loge)
	if ! grep -i "NixOS" < /etc/os-release > /dev/null 2>&1 ; then
		if ! [[ -f $HOME/.local/share/openra-$MOD ]]; then
			touch $HOME/.local/share/openra-$MOD
		fi
		# Already built commit number   
		numbn=$(grep "VERSION" < $HOME/.local/share/openra-$MOD | cut -d ' ' -f 2)
		commitn=$(grep "COMMIT" < $HOME/.local/share/openra-$MOD | cut -d ' ' -f 2)
		# AppImage name
		APPNAME=$(grep "^PACKAGING_INSTALLER_NAME" < mod.config | cut -d '"' -f 2)
		if (! [[ $numbc == $numbn ]] ) || (! [[ $commitc == $commitn ]] ); then
			printf '\e[1;32m%-6s\e[m\n' "Setting version in $HOME/.local/share/openra-${MOD}."
			make version VERSION=${numbc} || { printf '\e[1;31m%-6s\e[m\n' "Make versionin' $GHUBO/$1 failed." && return }
			# Building $GHUBO/$1
			printf '\e[1;32m%-6s\e[m\n' "Building $MOD ${numbc} (${commitc})."
			make || { printf '\e[1;31m%-6s\e[m\n' "Making $GHUBO/$1 failed." && return }
			# Build AppImage
			pushd packaging/linux || { printf '\e[1;31m%-6s\e[m\n' "pushdin' into packaging/linux." && return }
			chmod +x buildpackage.sh || { printf '\e[1;31m%-6s\e[m\n' "Could not make buildpackage.sh executable." && return }
			./buildpackage.sh ${numbc} . || { printf '\e[1;31m%-6s\e[m\n' "Building AppImage failed." && return }
			if ls $HOME/Applications | grep "${APPNAME}-" | grep AppImage > /dev/null 2>&1 ; then
				printf '\e[1;32m%-6s\e[m\n' "An existing AppImage seems to exist in $HOME/Applications, so deleting it, so we can replace it with the successfully build AppImage for this new version."
				rm -rf $HOME/Applications/*${APPNAME}-*.AppImage || { printf '\e[1;31m%-6s\e[m\n' "Removing this AppImage failed." && return }
			fi
			# Moving to $HOME/Applications
			printf '\e[1;32m%-6s\e[m\n' "Moving AppImage to $HOME/Applications."
			mv ${APPNAME}-${numbc}.AppImage $HOME/Applications || { printf '\e[1;31m%-6s\e[m\n' "Moving new AppImage to $HOME/Applications failed." && return }
			# Updating desktop config file
			printf '\e[1;32m%-6s\e[m\n' "Removing existing desktop config files for older versions of this mod."
			if ls $HOME/.local/share/applications | grep openra-${MOD} > /dev/null 2>&1 ; then
				rm -rf $HOME/.local/share/applications/*openra-${MOD}*.desktop || { printf '\e[1;31m%-6s\e[m\n' "Removing old openra-${MOD}.desktop config file from $HOME/.local/share/applications failed." && return }
			fi
			popd || { printf '\e[1;31m%-6s\e[m\n' "popdin' out of packaging/linux." && return }
			# Updating version on ~/.local/share
			echo "VERSION ${numbc}\nCOMMIT ${commitc}" > $HOME/.local/share/openra-${MOD}
			if ! [[ $MOD == "mw\|dr" ]]; then
				nixoup "$1"
			fi
		else
			printf '\e[1;32m%-6s\e[m\n' "OpenRA ${MOD} is up-to-date, mate!"
		fi
	else
		numbn=$(grep " version = " < $NIXPKGS/pkgs/games/openra-${MOD}/default.nix | cut -d '"' -f 2)
		commitn=$(grep " rev = " < $NIXPKGS/pkgs/games/openra-${MOD}/default.nix | head -n 1 | cut -d '"' -f 2)
		if (! [[ $numbc == $numbn ]] ) || (! [[ $commitc == $commitn ]] ); then
			printf '\e[1;32m%-6s\e[m\n' "Bumping $numbn->$numbc; $commitn->$commitc."
			nixoup "$1"
		fi
	fi
}

function mod-build-all {
	cdgo
	for i in *
	do
		if ( [[ -f "$i/fetch-engine.sh" ]] ) && ( echo $i | grep -v backup > /dev/null 2>&1 ) && ( [[ -d "$i/packaging/linux" ]] ); then
			mod-build "$i"
		fi
	done
}
