function mwup {
	cdgo Medieval-Warfare || return
	git pull origin Next -q
	# OpenRA latest engine version
	enlv=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
	# OpenRA engine version in spec file
	enpv=$(grep "define engine\_version" < "$OBSH"/openra-mw/openra-mw.spec | cut -d ' ' -f 3)
	mastn=$(git rev-list --branches Next --count)
	specn=$(grep "Version\:" < "$OBSH"/openra-mw/openra-mw.spec | sed 's/Version:\s*//g')
	comm=$(git log | head -n 1 | cut -d ' ' -f 2)
	specm=$(grep "define commit" < "$OBSH"/openra-mw/openra-mw.spec | cut -d ' ' -f 3)

	if [[ $specn == $mastn ]]; then
		printf "%s\n" "OpenRA Medieval Warfare mod is up to date!"
	else
		sed -i -e "s/$specn/$mastn/g" "$OBSH"/openra-mw/{openra-mw.spec,PKGBUILD}
		sed -i -e "s/$specm/$comm/g" "$OBSH"/openra-mw/{openra-mw.spec,PKGBUILD}
		if [[ $enlv == "{DEV_VERSION}" ]]; then
			pushd $GHUBO/OpenRA || return
			git pull origin bleed
			enlv=$(git rev-list --branches bleed --count)
			popd || return
		fi
		if ! [[ "$enpv" == "$enlv" ]]; then
			sed -i -e "s/$enpv/$enlv/g" "$OBSH"/openra-mw/{openra-mw.spec,PKGBUILD}
			make || return
			tar czvf "$OBSH"/openra-mw/engine-"${enlv}".tar.gz engine
			cdobsh openra-mw || return
			osc rm engine-"${enpv}".tar.gz
			osc add engine-"${enlv}".tar.gz
			cd - || return
		fi
		cdobsh openra-mw || return
		if ! [[ "$enpv" == "$enlv" ]]; then
			osc ci -m "Bumping $specn->$mastn; engine $enpv->$enlv"
		else
			osc ci -m "Bumping $specn->$mastn; engine version is unchanged."
		fi
	fi
	mod-build Medieval-Warfare
}
