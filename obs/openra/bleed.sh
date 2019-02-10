function update_openra_bleed_obs_pkg_and_appimage {
	cdgo OpenRA || ( printf "\e[1;31m%-0s\e[m\n" "Failed to cd into $GHUBO/OpenRA." && return )
	git checkout bleed -q || ( printf "\e[1;31m%-0s\e[m\n" "Failed to checkout the bleed branch." && return )
	git pull origin bleed -q || ( printf "\e[1;31m%-0s\e[m\n" "Failed to pull from the bleed branch of the origin remote." && return)
	latest_commit_no=$(latest_commit_number)
	packaged_commit_number=$(vere openra-bleed)
	latest_commit_hash=$(latest_commit_on_branch)
	packaged_commit_hash=$(come openra-bleed)

	if [[ "$packaged_commit_number" == "$latest_commit_no" ]]; then
		 printf '\e[1;32m%-6s\e[m\n' "OpenRA Bleed is up-to-date!"
	else
		printf '\e[1;32m%-6s\e[m\n' "Updating OBS repo openra-bleed from $packaged_commit_number, $packaged_commit_hash to $latest_commit_no, $latest_commit_hash."
		sed -i -e "s/$packaged_commit_hash/$latest_commit_hash/g" "$OBSH"/openra-bleed/{openra-bleed.spec,PKGBUILD} || \
			   (printf "\e[1;31m%-0s\e[m\n" "Replacing ${packaged_commit_hash} with ${latest_commit_hash} failed." && return )
		sed -i -e "s/$packaged_commit_number/$latest_commit_no/g" "$OBSH"/openra-bleed/{openra-bleed.spec,PKGBUILD} || \
			   (printf "\e[1;31m%-0s\e[m\n" "Replacing ${packaged_commit_number} with ${latest_commit_no} failed." && return )
		rm -rf $HOME/.local/share/applications/*openra-{ra,cnc,d2k}.desktop
		make clean || ( printf "\e[1;31m%-0s\e[m\n" "make clean failed.\n" && return )
		make version VERSION="${latest_commit_no}" || ( printf "\e[1;31m%-0s\e[m\n" "make version failed." && return )
		make || ( printf "\e[1;31m%-0s\e[m\n" "make failed." && return )
		cd packaging/linux || ( printf "\e[1;31m%-0s\e[m\n" "cd'in' into packaging/linux failed." && return )
		cp ../../../OpenRA.backup/packaging/linux/buildpackage.sh . || ( printf "\e[1;31m%-0s\e[m\n" "Copying buildpackage.sh from OpenRA.backup failed." && return )
		rm $HOME/Applications/OpenRA-{Red-Alert,Dune-2000,Tiberian-Dawn,Tiberian-Sun}*.AppImage
		./buildpackage.sh "$latest_commit_no" "$HOME"/Applications || ( printf "\e[1;31m%-0s\e[m\n" "buildpackage.sh failed to run properly." && return )
		git stash || ( printf "\e[1;31m%-0s\e[m\n" "git stashing failed." && return )
		cdobsh openra-bleed || ( printf "\e[1;31m%-0s\e[m\n" "cding into $OBSH/openra-bleed." && return )
		osc ci -m "Bumping $packaged_commit_number->$latest_commit_no" || ( printf "\e[1;31m%-0s\e[m\n" "Committing changes to the OBS failed." && return )
#		sed -i -e "s/version=$packaged_commit_number/version=$latest_commit_no/g" \
#			-e "s/latest_commit_hashit=$packaged_commit_hash/latest_commit_hashit=$latest_commit_hash/g" "$PK"/void-packages-bleed/srcpkgs/openra-bleed/template
		if cat /etc/os-release | paste -d, -s | grep -vi "Fedora\|CentOS\|\|Scientific\|Mageia\|openSUSE\|Arch\|Void" > /dev/null 2>&1 ; then
			/usr/local/bin/openra-build-cli
		fi
		printf '\e[1;32m%-6s\e[m\n' "Updating local copy of my OpenRA repo fork..."
		cdora || ( printf "\e[1;31m%-0s\e[m\n" "cding into $PK/OpenRA failed.\n" && return )
		git fetch upstream -q ; git merge upstream/bleed ; git push origin bleed -q
		engine_update
	fi
}

alias openrabup=update_openra_bleed_obs_pkg_and_appimage