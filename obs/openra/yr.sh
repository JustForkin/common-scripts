# Yuri's Revenge update
# Last commit with OBS version is b76be97a97f499f1b1b716418c36f95f8483d17a
function yrup {
	pushd $GHUBO/yr || {printf "pushdin' into $GHUBO/yr failed.\n" && return}
	printf "Git pulling repository.\n"
	git pull origin master -q || {printf "Git pullin' repository failed.\n" && return} 
    # OpenRA latest engine version
#    enlv=${grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2}
    # OpenRA engine version in spec file
#    enpv=${grep "^%define engine" < "$HOME"/OBS/home:fusion809/openra-yr/openra-yr.spec | cut -d ' ' -f 3}
	if ! [[ -f $HOME/.local/share/openra-yr ]]; then
		printf "$HOME/.local/share/openra-yr does not exist, so creating it with touch.\n"
		touch $HOME/.local/share/openra-yr || {printf "Touching it failed.\n" && return}
	fi
	mastn=$(comno)
	specn=$(grep "VERSION" < $HOME/.local/share/openra-yr | cut -d ' ' -f 2)
	comm=$(loge)
	specm=$(grep "COMMIT" < $HOME/.local/share/openra-yr | cut -d ' ' -f 2)
	modname=$(grep "^PACKAGING_INSTALLER_NAME" < mod.config | cut -d '"' -f 2)

	if [[ $specn == $mastn ]] && [[ $comm == $specm ]]; then
		printf "OpenRA Yuri's Revenge is up-to-date!\n"
	else
		printf "Cleaning repository.\n"
		make clean || {printf "make cleanin' failed.\n" && return}
		# If mods/ra2 doesn't exist, copy it over
		if ! [[ -d mods/ra2 ]]; then
			printf "Copying mods/ra2 from $GHUBO/ra2 to mods folder.\n"
			cp -a ../ra2/mods/ra2 mods || {printf "Copying ../ra2/mods/ra2 to mods failed.\n" && return}
		fi
		printf "Setting version in $HOME/.local/share/openra-yr.\n"
		echo "VERSION ${mastn}\nCOMMIT ${comm}" > $HOME/.local/share/openra-yr
		make version VERSION=${mastn} || {printf "make versionin' failed.\n" && return}
		printf "Building yr ${mastn} (${comm}).\n"
		make || {printf "Running make in $GHUBO/yr failed.\n" && return}
		# Build AppImage
		printf "Creating an AppImage for yr version $mastn and commit $comm.\n"
		pushd packaging/linux || {printf "pushdin' into packaging/linux.\n" && return}
		./buildpackage.sh ${mastn} . || {printf "Building AppImage failed.\n" && return}
		if ls $HOME/Applications | grep ${modname} | grep AppImage > /dev/null 2>&1 ; then
			printf "An existing AppImage seems to exist in ~/Applications, so deleting it, so we can replace it with the successfully build AppImage for this new version.\n"
			rm $HOME/Applications/*${modname}*.AppImage || {printf "Removing this AppImage failed.\n" && return}
		fi
		printf "Moving AppImage to $HOME/Applications.\n"
		mv ${modname}-${mastn}.AppImage $HOME/Applications || {printf "Moving new AppImage to $HOME/Applications failed.\n" && return}
		printf "Removing existing desktop config files for this mod.\n"
		pushd $HOME/Applications || { printf "pushdin' into $HOME/Applications failed.\n" && exit }
		rm -rf $HOME/.local/share/applications/*openra-yr*.desktop || {printf "Removing $HOME/.local/share/applications/*openra-yr*.desktop failed.\n" && return}
		read -q "yn?Do you want to integrate and launch ${modname}-${mastn}.AppImage? "
		case $yn in
			[Yy]* ) ./AppImageLauncher*.AppImage ${modname}-${mastn}.AppImage ;;
			[Nn]* ) printf "OK. If you change your mind change into $HOME/Applications and run ./AppImageLauncher*.AppImage ${modname}-${mastn}.AppImage.\n" ;;
		esac
		popd || { printf "popdin' out of $HOME/Applications.\n" && return }
		popd || {printf "popdin' out of packaging/linux.\n" && return}
	fi
	popd || {printf "popdin' out of $GHUBO/yr.\n" && return}
}
