function ra2up {
	cdgo ra2 || return
	git pull origin master -q
	# OpenRA latest engine version
	enlv=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
	# OpenRA engine version in spec file
	enpv=$(grep "define engine\_version" < "$OBSH"/openra-ra2/openra-ra2.spec | cut -d ' ' -f 3)
	mastn=$(comno)
	specn=$(vere openra-ra2)
	comm=$(latest_commit_on_branch)
	specm=$(come openra-ra2)

	if [[ $specn == $mastn ]]; then
		 printf "OpenRA RA2 is up-to-date!\n"
	else
		 printf "Updating openra-ra2 spec file and PKGBUILD.\n"
		 sed -i -e "s/$specm/$comm/g" \
		 		-e "s/$specn/$mastn/g" "$OBSH"/openra-ra2/{openra-ra2.spec,PKGBUILD}
		 if ! [[ "$enpv" == "$enlv" ]]; then
			  printf "Updating OpenRA Red Alert 2 engine.\n"
			  sed -i -e "s/$enpv/$enlv/g" "$OBSH"/openra-ra2/{openra-ra2.spec,PKGBUILD}
			  make clean || return
			  make || return
			  tar czvf "$OBSH"/openra-ra2/engine-"${enlv}".tar.gz engine
			  cdobsh openra-ra2 || return
			  osc rm engine-"${enpv}".tar.gz
			  osc add engine-"${enlv}".tar.gz
			  cd - || return
		 fi
		 printf "%s\n" "Comitting changes."
		 cdobsh openra-ra2
		 osc ci -m "Bumping $specn->$mastn"
	fi
	mod-build ra2
	if grep "Arch" < /etc/os-release &> /dev/null ; then
		printf "Run mwnup under NixOS, as in an Arch chroot nix-prefetch fails.\n"
	elif grep "NixOS" < /etc/os-release &> /dev/null ; then
		ra2nup
	fi
}
