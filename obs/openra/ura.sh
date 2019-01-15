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
		 sed -i -e "s/$specm/$comm/g" \
		 		-e "s/$specn/$mastn/g" "$OBSH"/openra-ura/{openra-ura.spec,PKGBUILD} 
		 if ! [[ "$enpv" == "$enlv" ]]; then
			  sed -i -e "s/$enpv/$enlv/g" "$OBSH"/openra-ura/{openra-ura.spec,PKGBUILD}
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
	fi
	mod-build uRA
	if grep "Arch" < /etc/os-release &> /dev/null ; then
		printf "Run mwnup under NixOS, as in an Arch chroot nix-prefetch fails.\n"
	elif grep "NixOS" < /etc/os-release &> /dev/null ; then
		uranup
	fi
}

alias uraup=uRAup
