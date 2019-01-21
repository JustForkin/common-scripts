# Dark Reign update
function drup {
	cdgo DarkReign || return
	git pull origin master -q
	# OpenRA latest engine version
	if [[ $(grep "^AUTOMATIC_ENGINE_SOURCE" < mod.config | cut -d '/' -f 7 | cut -d "." -f 1) == '${ENGINE_VERSION}' ]]; then
		enlv=$(grep '^ENGINE_VERSION' < mod.config | cut -d '"' -f 2)
	elif [[ $(grep "^AUTOMATIC_ENGINE_SOURCE" < mod.config | cut -d '/' -f 7 | cut -d "." -f 1) == 'DarkReign' ]]; then
		enlv=$(loge $GHUBO/OpenRA-dr)
	fi
	# OpenRA engine version in spec file
	enpv=$(grep "^%define engine" < "$HOME"/OBS/home:fusion809/openra-dr/openra-dr.spec | cut -d ' ' -f 3)
	mastn=$(latest_commit_number)
	specn=$(vere openra-dr)
	comm=$(latest_commit_on_branch)
	specm=$(come openra-dr)

	if [[ $specn == $mastn ]]; then
		printf "OpenRA Dark Reign is up-to-date!\n"
	else
		sed -i -e "s/$specm/$comm/g" \
			   -e "s/$specn/$mastn/g" "$OBSH"/openra-dr/{openra-dr.spec,PKGBUILD}
		if ! [[ "$enpv" == "$enlv" ]]; then
			sed -i -e "s/$enpv/$enlv/g" "$HOME"/OBS/home:fusion809/openra-dr/{openra-dr.spec,PKGBUILD}
			make clean || return
			make || return
			tar czvf "$HOME"/OBS/home:fusion809/openra-dr/engine-"${enlv}".tar.gz engine
			cdobsh openra-dr || return
			osc rm engine-"${enpv}".tar.gz
			osc add engine-"${enlv}".tar.gz
			cd - || return
		fi
		cdobsh openra-dr || return
		osc ci -m "Bumping $specn->$mastn"
	fi
	openra_mod_appimage_build DarkReign
	drnup "${1}"
}

