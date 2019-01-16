function rvup {
	cdgo rv || return
	git pull origin master -q
	# OpenRA latest engine version
	enlv=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
	# OpenRA engine version in spec file
	enpv=$(grep "define engine\_version" < "$OBSH"/openra-rv/openra-rv.spec | cut -d ' ' -f 3)
	mastn=$(comno)
	specn=$(vere openra-rv)
	comm=$(latest_commit_on_branch)
	specm=$(come openra-rv)

	if [[ $specn == $mastn ]]; then
		 printf "OpenRA Romanov's Vengeance is up-to-date!\n"
	else
		 printf "Updating openra-rv spec file and PKGBUILD.\n"
		 sed -i -e "s/$specm/$comm/g" \
		 		-e "s/$specn/$mastn/g" "$OBSH"/openra-rv/{openra-rv.spec,PKGBUILD}
		 if ! [[ "$enpv" == "$enlv" ]]; then
			  printf "Updating OpenRA Romanov's Vengeance engine.\n"
			  sed -i -e "s/$enpv/$enlv/g" "$OBSH"/openra-rv/{openra-rv.spec,PKGBUILD}
			  make clean || return
			  make || return
			  tar czvf "$OBSH"/openra-rv/engine-"${enlv}".tar.gz engine
			  cdobsh openra-rv || return
			  osc rm engine-"${enpv}".tar.gz
			  osc add engine-"${enlv}".tar.gz
			  cd - || return
		 fi
		 printf "%s\n" "Comitting changes."
		 cdobsh openra-rv
		 osc ci -m "Bumping $specn->$mastn"
	fi
	mod-build rv
	if grep "Arch" < /etc/os-release &> /dev/null ; then
		printf "Run mwnup under NixOS, as in an Arch chroot nix-prefetch fails.\n"
	elif grep "NixOS" < /etc/os-release &> /dev/null ; then
		rvnup
	fi
}
