# openra-build-all builds all OpenRA mods as AppImages. If one fails it continues on.
# Function takes a singular input: the name of the folder used by the mod in $HOME/GitHub/others
function mod-build {
	cd $GHUBO/"$1"
	MOD=$(grep "^MOD_ID" < mod.config | cut -d '"' -f 2)
	printf '\e[1;32m%-6s\e[m\n' "Mod name is $MOD."
	git stash -q || { printf '\e[1;31m%-6s\e[m\n' "git stashin' failed." && return}
git pull origin $(git-branch) -q || {printf '\e[1;31m%-6s\e[m\n' "git pullin' on branch $(git-branch) failed." && return}
	# Present commit number
	numbc=$(git rev-list --branches $(git-branch) --count)
	# Present commit
	commitc=$(loge)
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
		make version VERSION=${numbc} || {printf '\e[1;31m%-6s\e[m\n' "Make versionin' $GHUBO/$1 failed." && return}
		# Building $GHUBO/$1
		printf '\e[1;32m%-6s\e[m\n' "Building $MOD ${numbc} (${commitc})."
		make || {printf '\e[1;31m%-6s\e[m\n' "Making $GHUBO/$1 failed." && return}
		# Build AppImage
		pushd packaging/linux || {printf '\e[1;31m%-6s\e[m\n' "pushdin' into packaging/linux." && return}
		chmod +x buildpackage.sh || {printf '\e[1;31m%-6s\e[m\n' "Could not make buildpackage.sh executable." && return}
		./buildpackage.sh ${numbc} . || {printf '\e[1;31m%-6s\e[m\n' "Building AppImage failed." && return}
		if ls $HOME/Applications | grep "${APPNAME}-" | grep AppImage > /dev/null 2>&1 ; then
			printf '\e[1;32m%-6s\e[m\n' "An existing AppImage seems to exist in $HOME/Applications, so deleting it, so we can replace it with the successfully build AppImage for this new version."
			rm -rf $HOME/Applications/*${APPNAME}-*.AppImage || {printf '\e[1;31m%-6s\e[m\n' "Removing this AppImage failed." && return}
		fi
		printf '\e[1;32m%-6s\e[m\n' "Moving AppImage to $HOME/Applications."
		mv ${APPNAME}-${numbc}.AppImage $HOME/Applications || {printf '\e[1;31m%-6s\e[m\n' "Moving new AppImage to $HOME/Applications failed." && return}
		printf '\e[1;32m%-6s\e[m\n' "Removing existing desktop config files for older versions of this mod."
		if ls $HOME/.local/share/applications | grep openra-${MOD} > /dev/null 2>&1 ; then
			rm -rf $HOME/.local/share/applications/*openra-${MOD}*.desktop || {printf '\e[1;31m%-6s\e[m\n' "Removing old openra-${MOD}.desktop config file from $HOME/.local/share/applications failed." && return}
		fi
		popd || {printf '\e[1;31m%-6s\e[m\n' "popdin' out of packaging/linux." && return}
		echo "VERSION ${numbc}\nCOMMIT ${commitc}" > $HOME/.local/share/openra-${MOD}
	else
		printf '\e[1;32m%-6s\e[m\n' "OpenRA ${MOD} is up-to-date mate!"
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