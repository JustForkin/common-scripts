# Combined Arms update
# Last commit with OBS version is b76be97a97f499f1b1b716418c36f95f8483d17a
function caup {
	printf "pushin' into $GHUBO/CAmod.\n"
	pushd $GHUBO/CAmod || printf "pushdin' into $GHUBO/CAmod failed.\n" && exit
	printf "Git pulling repository.\n"
	git pull origin master -q || printf "Git pullin' repository failed.\n" && exit
    # OpenRA latest engine version
#    enlv=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
    # OpenRA engine version in spec file
#    enpv=$(grep "^%define engine" < "$HOME"/OBS/home:fusion809/openra-ca/openra-ca.spec | cut -d ' ' -f 3)
	mastn=$(comno)
	specn=$(grep "VERSION" < $HOME/.local/share/openra-ca | cut -d ' ' -f 2)
	comm=$(loge)
	specm=$(grep "COMMIT" < $HOME/.local/share/openra-ca | cut -d ' ' -f 2)

	if [[ $specn == $mastn ]] && [[ $comm == $specm ]]; then
		printf "OpenRA Combined Arms is up-to-date!\n"
	else
		printf "Cleaning repository.\n"
		make clean || printf "Make cleanin' $GHUBO/CAmod failed.\n" && exit
		# Setting version
		printf "Setting version in $HOME/.local/share/openra-ca.\n"
		echo "VERSION ${mastn}\nCOMMIT ${comm}" > $HOME/.local/share/openra-ca
		make version VERSION=${mastn} || printf "Make versionin' $GHUBO/CAmod failed.\n" && exit
		# Building $GHUBO/CAmod
		printf "Building CAmod.\n"
		make || printf "Making $GHUBO/CAmod failed.\n" && exit
		# Build AppImage
		pushd packaging/linux || printf "pushdin' into packaging/linux.\n" && exit
		./buildpackage.sh ${mastn} $HOME/Applications || printf "Building the AppImage with buildpackage.sh failed.\n" && exit
		popd || printf "popdin' out of packaging/linux.\n" && exit
	fi

	popd || printf "popdin' out of $GHUBO/CAmod.\n" && exit
}

