# openra-build-all builds all OpenRA mods as AppImages. If one fails it continues on.

function mod-build {
	cd $GHUBO/"$i"
	MOD=$(grep "^MOD_ID" < mod.config | cut -d '"' -f 2)
	printf "Mod name is $MOD.\n"
	git stash -q || { printf "git stashin' failed.\n" && return}
	git pull origin $(git-branch) -q || {printf "git pullin' on branch $(git-branch) failed.\n" && return}
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
		printf "Setting version in $HOME/.local/share/openra-${MOD}.\n"
		make version VERSION=${numbc} || {printf "Make versionin' $GHUBO/$1 failed.\n" && return}
		# Building $GHUBO/$1
		printf "Building $MOD ${numbc} (${commitc}).\n"
		make || {printf "Making $GHUBO/$1 failed.\n" && return}
		# Build AppImage
		pushd packaging/linux || {printf "pushdin' into packaging/linux.\n" && return}
		chmod +x buildpackage.sh || {printf "Could not make buildpackage.sh executable.\n" && return}
		./buildpackage.sh ${numbc} . || {printf "Building AppImage failed.\n" && return}
		if ls $HOME/Applications | grep "${MOD}-" | grep AppImage > /dev/null 2>&1 ; then
			printf "An existing AppImage seems to exist in $HOME/Applications, so deleting it, so we can replace it with the successfully build AppImage for this new version.\n"
			rm -rf $HOME/Applications/*${APPNAME}-*.AppImage || {printf "Removing this AppImage failed.\n" && return}
		fi
		printf "Moving AppImage to $HOME/Applications.\n"
		mv ${APPNAME}-${numbc}.AppImage $HOME/Applications || {printf "Moving new AppImage to $HOME/Applications failed.\n" && return}
		printf "Removing existing desktop config files for older versions of this mod.\n"
		if ls $HOME/.local/share/applications | grep openra-${MOD} > /dev/null 2>&1 ; then
			rm -rf $HOME/.local/share/applications/*openra-${MOD}*.desktop || {printf "Removing old openra-${MOD}.desktop config file from $HOME/.local/share/applications failed.\n" && return}
		fi
		popd || {printf "popdin' out of packaging/linux.\n" && return}
		echo "VERSION ${numbc}\nCOMMIT ${commitc}" > $HOME/.local/share/openra-${MOD}
	else
		printf "OpenRA ${MOD} is up-to-date mate!\n"
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
