# RA Classic update
# Last commit with OBS version is d69ef4c3eb12f8a4324d7322d592223ad71f68ea
function racup {
	printf "pushin' into $GHUBO/raclassic.\n"
	pushd $GHUBO/raclassic || {printf "pushdin' into $GHUBO/raclassic failed.\n" && return}
	printf "Git pulling repository.\n"
	git pull origin master -q || {printf "Git pullin' repository failed.\n" && return}
    # OpenRA latest engine version
#    enlv=${grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2}
    # OpenRA engine version in spec file
#    enpv=${grep "^%define engine" < "$HOME"/OBS/home:fusion809/openra-raclassic/openra-raclassic.spec | cut -d ' ' -f 3}
	if ! [[ -f $HOME/.local/share/openra-raclassic ]]; then
		printf "$HOME/.local/share/openra-raclassic does not exist, so creating it with touch.\n"
		touch $HOME/.local/share/openra-raclassic || {printf "Touching it failed.\n" && return}
	fi
	mastn=$(comno)
	specn=$(grep "VERSION" < $HOME/.local/share/openra-raclassic | cut -d ' ' -f 2)
	comm=$(loge)
	specm=$(grep "COMMIT" < $HOME/.local/share/openra-raclassic | cut -d ' ' -f 2)
	modname=$(grep "^PACKAGING_INSTALLER_NAME" < mod.config | cut -d '"' -f 2)

	if [[ $specn == $mastn ]] && [[ $comm == $specm ]]; then
		printf "OpenRA RA Classic is up-to-date!\n"
	else
		printf "Cleaning repository.\n"
		make clean || {printf "Make cleanin' $GHUBO/raclassic failed.\n" && return}
		# Setting version
		printf "Setting version in $HOME/.local/share/openra-raclassic.\n"
		echo "VERSION ${mastn}\nCOMMIT ${comm}" > $HOME/.local/share/openra-raclassic
		make version VERSION=${mastn} || {printf "Make versionin' $GHUBO/raclassic failed.\n" && return}
		# Building $GHUBO/raclassic
		printf "Building raclassic ${mastn} (${comm}).\n"
		make || {printf "Making $GHUBO/raclassic failed.\n" && return}
		# Build AppImage
		pushd packaging/linux || {printf "pushdin' into packaging/linux.\n" && return}
		./buildpackage.sh ${mastn} . || {printf "Building AppImage failed.\n" && return}
		if ls $HOME/Applications | grep "${modname}-" | grep AppImage > /dev/null 2>&1 ; then
 			printf "An existing AppImage seems to exist in $HOME/Applications, so deleting it, so we can replace it with the successfully build AppImage for this new version.\n"
			rm $HOME/Applications/*${modname}-*.AppImage || {printf "Removing this AppImage failed.\n" && return}
		fi
		printf "Moving AppImage to $HOME/Applications.\n"
		mv ${modname}-${mastn}.AppImage $HOME/Applications || {printf "Moving new AppImage to $HOME/Applications failed.\n" && return}
		printf "Removing existing desktop config files for this mod.\n"
		pushd $HOME/Applications || {printf "Changing into $HOME/Applications failed.\n" && return}
		rm -rf $HOME/.local/share/applications/*openra-raclassic*.desktop || {printf "Removing old openra-raclassic.desktop config file from $HOME/.local/share/applications failed.\n" && return}
		read -q "yn?Do you want to integrate and launch ${modname}-${mastn}.AppImage? "
		case $yn in
			[Yy]* ) ./AppImageLauncher*.AppImage ${modname}-${mastn}.AppImage ;;
			[Nn]* ) printf "OK. If you change your mind change into $HOME/Applications and run ./AppImageLauncher*.AppImage ${modname}-${mastn}.AppImage.\n" ;;
		esac
		popd || {printf "popdin' out of packaging/linux.\n" && return}
	fi

	popd || {printf "popdin' out of $GHUBO/raclassic.\n" && return}
}

