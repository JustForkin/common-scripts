function kkndup {
	cdgo kknd || return
	git pull origin master -q
	# OpenRA latest engine version
	enlv=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
	# OpenRA engine version in spec file
	enpv=$(grep "define engine\_version" < "$OBSH"/openra-kknd/openra-kknd.spec | cut -d ' ' -f 3)
	mastn=$(comno)
	specn=$(vere openra-kknd)
	comm=$(loge)
	specm=$(come openra-kknd)

	if [[ $specn == $mastn ]]; then
		 printf "OpenRA KKnD is up-to-date!\n"
	else
		 printf "Updating openra-kknd spec file and PKGBUILD.\n"
		 sed -i -e "s/$specn/$mastn/g" "$OBSH"/openra-kknd/{openra-kknd.spec,PKGBUILD}
		 sed -i -e "s/$specm/$comm/g" "$OBSH"/openra-kknd/{openra-kknd.spec,PKGBUILD}
		 if ! [[ "$enpv" == "$enlv" ]]; then
			  printf "Updating OpenRA Krush, Kill n' Destroy engine.\n"
			  sed -i -e "s/$enpv/$enlv/g" "$OBSH"/openra-kknd/{openra-kknd.spec,PKGBUILD}
			  make clean || return
			  make || return
			  tar czvf "$OBSH"/openra-kknd/engine-"${enlv}".tar.gz engine
			  cdobsh openra-kknd || return
			  osc rm engine-"${enpv}".tar.gz
			  osc add engine-"${enlv}".tar.gz
			  cd - || return
		 fi
		 printf "%s\n" "Comitting changes."
		 cdobsh openra-kknd
		 osc ci -m "Bumping $specn->$mastn"
	fi
	mod-build kknd
}
