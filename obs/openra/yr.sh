# Yuri's Revenge update
# Last commit with OBS version is b76be97a97f499f1b1b716418c36f95f8483d17a
function yrup {
	pushd $GHUBO/yr || printf "pushdin' into $GHUBO/yr.\n" exit
	printf "Git pulling repository.\n"
	git pull origin master -q || printf "Git pullin' repository failed.\n" && exit 
    # OpenRA latest engine version
#    enlv=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
    # OpenRA engine version in spec file
#    enpv=$(grep "^%define engine" < "$HOME"/OBS/home:fusion809/openra-yr/openra-yr.spec | cut -d ' ' -f 3)
	mastn=$(comno)
	specn=$(grep "VERSION" < $HOME/.local/share/openra-yr | cut -d ' ' -f 2)
	comm=$(loge)
	specm=$(grep "COMMIT" < $HOME/.local/share/openra-yr | cut -d ' ' -f 2)

	if [[ $specn == $mastn ]] && [[ $comm == $specm ]]; then
		printf "OpenRA Yuri's Revenge is up-to-date!\n"
	else
		printf "Cleaning repository.\n"
		make clean || printf "make cleanin' failed.\n" && exit
		printf "Setting version in $HOME/.local/share/openra-yr.\n"
		echo "VERSION ${mastn}\nCOMMIT ${comm}" > $HOME/.local/share/openra-yr
		make version VERSION=${mastn} || printf "make versionin' failed.\n" && exit
		printf "Building yr.\n"
		make || printf "Running make in $GHUBO/yr failed.\n" && exit
		# Build AppImage
		printf "Creating an AppImage for yr version $mastn and commit $comm.\n"
		pushd packaging/linux || printf "pushdin' into packaging/linux.\n" && exit
		./buildpackage.sh ${mastn} $HOME/Applications || printf "Building AppImage failed.\n" && exit
		popd || printf "popdin' out of packaging/linux.\n" && exit
	fi
	popd || printf "popdin' out of $GHUBO/yr.\n" && exit
}

