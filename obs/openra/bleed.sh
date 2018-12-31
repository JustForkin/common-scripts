function openrabup {
	cdgo OpenRA || return
	git checkout bleed -q
	git pull origin bleed -q
	mastn=$(comno)
	specn=$(vere openra-bleed)
	comm=$(loge)
	specm=$(come openra-bleed)

	if [[ "$specn" == "$mastn" ]]; then
		 printf '\e[1;32m%-6s\e[m\n' "OpenRA Bleed is up-to-date!"
	else
		printf '\e[1;32m%-6s\e[m\n' "Updating OBS repo openra-bleed from $specn, $specm to $mastn, $comm."
		sed -i -e "s/$specn/$mastn/g" "$OBSH"/openra-bleed/{openra-bleed.spec,PKGBUILD} "$NIXPKGS"/pkgs/games/openra/default.nix || return
		sed -i -e "s/$specm/$comm/g" "$OBSH"/openra-bleed/{openra-bleed.spec,PKGBUILD} "$NIXPKGS"/pkgs/games/openra/default.nix || return
		#nix-prefetch-url $NIXPKGS --attr openra.src &> /tmp/sha256
		#sha256=$(cat /tmp/sha256 | tail -n 1)
		#sed -i -e "23s/sha256 = \".*\"/sha256 = \"${sha256}\"/" "$NIXPKGS"/pkgs/games/openra/default.nix || return
		#rm /tmp/sha256 || return
		rm -rf $HOME/.local/share/applications/*openra-{ra,cnc,d2k}.desktop
		make clean
		make version VERSION=${mastn}
		make
		cd packaging/linux || return
		cp ../../../OpenRA.backup/packaging/linux/buildpackage.sh . || return
		./buildpackage.sh "$mastn" "$HOME"/Applications
		git stash
		cdobsh openra-bleed || return
		osc ci -m "Bumping $specn->$mastn"
#		sed -i -e "s/version=$specn/version=$mastn/g" \
#			-e "s/commit=$specm/commit=$comm/g" "$PK"/void-packages-bleed/srcpkgs/openra-bleed/template
		if cat /etc/os-release | paste -d, -s | grep -vi "Fedora\|CentOS\|\|Scientific\|Mageia\|openSUSE\|Arch\|Void" > /dev/null 2>&1 ; then
			/usr/local/bin/openra-build-cli
		fi
		printf '\e[1;32m%-6s\e[m\n' "Updating local copy of my OpenRA repo fork..."
		cdora ; git fetch upstream ; git merge upstream/bleed ; git push origin bleed -q
		cdnp pkgs/games/openra || return
		printf '\e[1;34m%-6s\e[m' 'Time to update OpenRA nixpkg checksums by:'
		printf '\e[1;34m%-6s\e[m' '* Running nix-env -f $NIXPKGS -iA openra, which will fail but tell you the correct checksums.'
		printf '\e[1;34m%-6s\e[m' '* Running sedsha 23 "checksum".'
	fi
}
