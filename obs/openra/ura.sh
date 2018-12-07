function uRAup {
	cdgo uRA || return
	git pull origin master -q
	# Latest engine version
	enlv=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
	# OpenRA engine version in spec file
	enpv=$(grep "define engine\_version" < "$OBSH"/openra-ura/openra-ura.spec | cut -d ' ' -f 3)
	mastn=$(git rev-list --branches master --count)
	specn=$(grep "Version\:" < "$OBSH"/openra-ura/openra-ura.spec | sed 's/Version:\s*//g')
	comm=$(git log | head -n 1 | cut -d ' ' -f 2)
	specm=$(grep "define commit" < "$OBSH"/openra-ura/openra-ura.spec | cut -d ' ' -f 3)

	if [[ "$specn" == "$mastn" ]]; then
		 printf "%s\n" "OpenRA Red Alert Unplugged mod is up to date!"
	else
		 sed -i -e "s/$specn/$mastn/g" "$OBSH"/openra-ura/{openra-ura.spec,PKGBUILD} "$PK"/nixpkgs/pkgs/games/openra-ura/default.nix
		 sed -i -e "s/$specm/$comm/g" "$OBSH"/openra-ura/{openra-ura.spec,PKGBUILD} "$PK"/nixpkgs/pkgs/games/openra-ura/default.nix 
		 if ! [[ "$enpv" == "$enlv" ]]; then
			  sed -i -e "s/$enpv/$enlv/g" "$OBSH"/openra-ura/{openra-ura.spec,PKGBUILD} "$PK"/nixpkgs/pkgs/games/openra-ura/default.nix
			  make clean || return
			  make || return
			  tar czvf "$OBSH"/openra-ura/engine-"${enlv}".tar.gz engine
			  cdobsh openra-ura || return
			  osc rm engine-"${enpv}".tar.gz
			  osc add engine-"${enlv}".tar.gz
			  cd - || return
		 fi
		 cdobsh openra-ura || return
		 if ! [[ "$enpv" == "$enlv" ]]; then
			  osc ci -m "Bumping $specn->$mastn; engine $enpv->$enlv"
		 else
			  osc ci -m "Bumping $specn->$mastn; engine version is unchanged."
		 fi

		 cdpk nixpkgs/pkgs/games/openra-ura || return

		 if ! [[ "$enpv" == "$enlv" ]]; then
			  push "openra-ura: $specn->$mastn; engine $enpv->$enlv"
		 else
			  push "openra-ura: $specn->$mastn; engine version is unchanged."
		 fi
	fi
	mod-build uRA
}

alias uraup=uRAup
