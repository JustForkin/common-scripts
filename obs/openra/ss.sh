function ssup {
	cdgo ss || return
	git pull origin master -q
	# OpenRA latest engine version utilized by mod
	enlv=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
	# OpenRA engine version in spec file
	enpv=$(grep "define engine\_version" < "$OBSH"/openra-ss/openra-ss.spec | cut -d ' ' -f 3)
	mastn=$(comno)
	specn=$(vere openra-ss)
	comm=$(loge)
	specm=$(come openra-ss)

	if [[ $specn == $mastn ]]; then
		 printf "OpenRA Sole Survivor is up-to-date!\n"
	else
		 printf "Updating openra-ss spec file and PKGBUILD.\n"
		 sed -i -e "s/$specn/$mastn/g" "$OBSH"/openra-ss/{openra-ss.spec,PKGBUILD}
		 sed -i -e "s/$specm/$comm/g" "$OBSH"/openra-ss/{openra-ss.spec,PKGBUILD}
		 if ! [[ "$enpv" == "$enlv" ]]; then
			  printf "Updating OpenRA Sole Survivor engine.\n"
			  sed -i -e "s/$enpv/$enlv/g" "$OBSH"/openra-ss/{openra-ss.spec,PKGBUILD}
			  make clean || return
			  make || return
			  tar czvf "$OBSH"/openra-ss/engine-"${enlv}".tar.gz engine
			  cdobsh openra-ss || return
			  osc rm engine-"${enpv}".tar.gz
			  osc add engine-"${enlv}".tar.gz
			  cd - || return
		 fi
		 printf "%s\n" "Comitting changes."
		 cdobsh openra-ss
		 osc ci -m "Bumping $specn->$mastn"
	fi
	mod-build ss
}