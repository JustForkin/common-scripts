# RA Classic update
# Last commit with OBS version is d69ef4c3eb12f8a4324d7322d592223ad71f68ea
#function racup {
	# A larger racup func was used in commit eb723d4af07bf2a72038a938525f18cd98df2699 and earlier
#	mod-build raclassic
#}
function racup {
	cdgo raclassic || return
	git pull origin master -q
	# OpenRA latest engine version
	enlv=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
	# OpenRA engine version in spec file
	enpv=$(grep "define engine\_version" < "$OBSH"/openra-raclassic/openra-raclassic.spec | cut -d ' ' -f 3)
	mastn=$(latest_commit_number)
	specn=$(vere openra-raclassic)
	comm=$(latest_commit_on_branch)
	specm=$(come openra-raclassic)

	if [[ $specn == $mastn ]]; then
		 printf "OpenRA raclassic is up-to-date!\n"
	else
		 printf "Updating openra-raclassic spec file and PKGBUILD.\n"
		 sed -i -e "s/$specm/$comm/g" \
		 		-e "s/$specn/$mastn/g" "$OBSH"/openra-raclassic/{openra-raclassic.spec,PKGBUILD}
		 if ! [[ "$enpv" == "$enlv" ]]; then
			  printf "Updating OpenRA Red Alert 2 engine.\n"
			  sed -i -e "s/$enpv/$enlv/g" "$OBSH"/openra-raclassic/{openra-raclassic.spec,PKGBUILD}
			  make clean || return
			  make || return
			  tar czvf "$OBSH"/openra-raclassic/engine-"${enlv}".tar.gz engine
			  cdobsh openra-raclassic || return
			  osc rm engine-"${enpv}".tar.gz
			  osc add engine-"${enlv}".tar.gz
			  cd - || return
		 fi
		 printf "%s\n" "Comitting changes."
		 cdobsh openra-raclassic
		 osc ci -m "Bumping $specn->$mastn"
	fi
	mod-build raclassic
	if grep "Arch" < /etc/os-release &> /dev/null ; then
		printf "Run racnup under NixOS, as in an Arch chroot nix-prefetch fails.\n"
	elif grep "NixOS" < /etc/os-release &> /dev/null ; then
		racnup
	fi
}
