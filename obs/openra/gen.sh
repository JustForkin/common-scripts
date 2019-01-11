# Dark Reign update
function genup {
	cdgo Generals-Alpha || return
	git pull origin master -q
	# OpenRA latest engine version
	enlv=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
	# OpenRA engine version in spec file
	enpv=$(grep "define engine\_version" < "$HOME"/OBS/home:fusion809/openra-gen/openra-gen.spec | cut -d ' ' -f 3)
	mastn=$(comno)
	specn=$(vere openra-gen)
	comm=$(loge)
	specm=$(come openra-gen)

	if [[ $specn == $mastn ]]; then
		printf "%s\n" "OpenRA Generals Alpha is up-to-date!"
	else
		printf "%s\n" "Updating openra-gen spec file and PKGBUILD."
		sed -i -e "s/$specm/$comm/g" \
			   -e "s/$specn/$mastn/g" "$OBSH"/openra-gen/{openra-gen.spec,PKGBUILD}
		if ! [[ $enpv == $enlv ]]; then
			printf "%s\n" "Updating Generals Alpha engine."
			sed -i -e "s/$enpv/$enlv/g" "$HOME"/OBS/home:fusion809/openra-gen/{openra-gen.spec,PKGBUILD}
			make clean || return
			make || return
			tar czvf "$HOME"/OBS/home:fusion809/openra-gen/engine-"${enlv}".tar.gz generals-alpha-engine
			cdobsh openra-gen
			osc rm engine-"${enpv}".tar.gz
			osc add engine-"${enlv}".tar.gz
			cd - || return
		fi
		printf "%s\n" "Committing changes."
		cdobsh openra-gen || return
		osc ci -m "Bumping $specn->$mastn"
	fi
	mod-build Generals-Alpha
	nixoup2 "$GHUBO/Generals-Alpha" "4" "87" "94" "98" "103"
}

