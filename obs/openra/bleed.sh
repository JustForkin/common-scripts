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
		sed -i -e "s/$specn/$mastn/g" "$OBSH"/openra-bleed/{openra-bleed.spec,PKGBUILD} "$PK"/games/openra/default.nix || return
		sed -i -e "s/$specm/$comm/g" "$OBSH"/openra-bleed/{openra-bleed.spec,PKGBUILD} "$PK"/games/openra/default.nix || return
		rm $HOME/.local/share/applications/*openra-{ra,cnc,d2k}.desktop || return
		make clean
		make
		cd packaging/linux || return
		cp ../../../OpenRA.backup/packaging/linux/buildpackage.sh . || return
		./buildpackage.sh "$mastn" "$HOME"/Applications
		cdobsh openra-bleed || return
		osc ci -m "Bumping $specn->$mastn"
#		sed -i -e "s/version=$specn/version=$mastn/g" \
#			-e "s/commit=$specm/commit=$comm/g" "$PK"/void-packages-bleed/srcpkgs/openra-bleed/template
		if cat /etc/os-release | paste -d, -s | grep -vi "Fedora\|CentOS\|\|Scientific\|Mageia\|openSUSE\|Arch\|Void" > /dev/null 2>&1 ; then
			/usr/local/bin/openra-build-cli
		fi
		printf '\e[1;32m%-6s\e[m\n' "Updating local copy of my OpenRA repo fork..."
		cdora ; git pull upstream bleed -q ; git push origin bleed -q
		cdnp pkgs/games/openra || return
		nix-env -f "$PK" -iA openra
		printf '\e[1;34m%-6s\e[m\n' "You may need to update the sha256 based on the above output."
	fi
}