# OpenRA mod Nixpkg updater
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
	# Present commit
	commitc=$(loge)
	# Engine name
	enginec=$(grep "^ENGINE_VERSION" < mod.config | cut -d '"' -f 2)
	# Present versions
	enginen=$(grep '^\s*engine-version' < $NIXPKGS/pkgs/games/openra-$MOD/default.nix | cut -d '"' -f 2)
	numbn=$(grep "^\s*version" < $NIXPKGS/pkgs/games/openra-$MOD/default.nix | cut -d '"' -f 2)
	commitn=$(grep "^\s*rev" < $NIXPKGS/pkgs/games/openra-$MOD/default.nix | head -n 1 | cut -d '"' -f 2)
	if [[ $MOD == "yr" ]]; then
		# Get data on ra2
		commitn2=$(grep "^\s*rev" < $NIXPKGS/pkgs/games/openra-$MOD/default.nix | head -n 2 | tail -n 1 | cut -d '"' -f 2)
		cdgo ra2
		git pull origin $(git-branch)
		commitc2=$(loge)
		# Update nix file
		if [[ $enginen == $enginec ]]; then
			if [[ $commitn2 == $commitc2 ]]; then
				sed -i -e "s|$numbn|$numbc|g" \
			    	   -e "s|$commitn|$commitc|g" \
					   -e '26s|sha256 = ".*"|sha256 = "06ibyi602qk23g254gisn7s1fvbsg6f7bmbhqaypxm1ldgvwmq88"|' \
					   $NIXPKGS/pkgs/games/openra-${MOD}/default.nix		   
			else
				sed -i -e "s|$numbn|$numbc|g" \
				       -e "s|$commitn|$commitc|g" \
					   -e "s|$commitn2|$commitc2|g" \
					   -e '26s|sha256 = ".*"|sha256 = "06ibyi602qk23g254gisn7s1fvbsg6f7bmbhqaypxm1ldgvwmq88"|' \
					   -e '33s|sha256 = ".*"|sha256 = "06ibyi602qk23g254gisn7s1fvbsg6f7bmbhqaypxm1ldgvwmq88"|' \
					   $NIXPKGS/pkgs/games/openra-${MOD}/default.nix
			fi
		else
			# If the engine has been updated its sha256 needs to be changed, so it is downloaded
			if [[ $commitn2 == $commitc2 ]]; then
				sed -i -e "s|$numbn|$numbc|g" \
				       -e "s|$commitn|$commitc|g" \
					   -e '26s|sha256 = ".*"|sha256 = "06ibyi602qk23g254gisn7s1fvbsg6f7bmbhqaypxm1ldgvwmq88"|' \
					   -e '40s|sha256 = ".*"|sha256 = "06ibyi602qk23g254gisn7s1fvbsg6f7bmbhqaypxm1ldgvwmq88"|' \
				       -e "s|$enginen|$enginec|g" \
					   $NIXPKGS/pkgs/games/openra-${MOD}/default.nix
			else
				sed -i -e "s|$numbn|$numbc|g" \
				       -e "s|$commitn|$commitc|g" \
					   -e "s|$commitn2|$commitc2|g" \
					   -e '26s|sha256 = ".*"|sha256 = "06ibyi602qk23g254gisn7s1fvbsg6f7bmbhqaypxm1ldgvwmq88"|' \
					   -e '33s|sha256 = ".*"|sha256 = "06ibyi602qk23g254gisn7s1fvbsg6f7bmbhqaypxm1ldgvwmq88"|' \
					   -e '40s|sha256 = ".*"|sha256 = "06ibyi602qk23g254gisn7s1fvbsg6f7bmbhqaypxm1ldgvwmq88"|' \
				       -e "s|$enginen|$enginec|g" \
					   $NIXPKGS/pkgs/games/openra-${MOD}/default.nix
			fi
		fi
	else
		# Update nix file
		if ! [[ $enginen == $enginec ]]; then
			sed -i -e "s|$numbn|$numbc|g" \
			       -e "s|$commitn|$commitc|g" \
				   -e '26s|sha256 = ".*"|sha256 = "06ibyi602qk23g254gisn7s1fvbsg6f7bmbhqaypxm1ldgvwmq88"|' \
				   -e '33s|sha256 = ".*"|sha256 = "06ibyi602qk23g254gisn7s1fvbsg6f7bmbhqaypxm1ldgvwmq88"|' \
			       -e "s|$enginen|$enginec|g" \
				   $NIXPKGS/pkgs/games/openra-${MOD}/default.nix
		else
			sed -i -e "s|$numbn|$numbc|g" \
			       -e "s|$commitn|$commitc|g" \
				   -e '26s|sha256 = ".*"|sha256 = "06ibyi602qk23g254gisn7s1fvbsg6f7bmbhqaypxm1ldgvwmq88"|' \
				   $NIXPKGS/pkgs/games/openra-${MOD}/default.nix
		fi
	fi
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
			printf '\e[1;32m%-6s\e[m\n' "OpenRA ${MOD} is up-to-date mate!"
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
