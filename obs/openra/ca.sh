# Combined Arms update
# Last commit with OBS version is b76be97a97f499f1b1b716418c36f95f8483d17a
function caup {
	cdgo CAmod || exit
	git pull origin master -q
	# OpenRA latest engine version
	enlv=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
	# OpenRA engine version in spec file
	enpv=$(grep "^%define engine" < "$HOME"/OBS/home:fusion809/openra-ca/openra-ca.spec | cut -d ' ' -f 3)
	mastn=$(comno)
	specn=$(vere openra-ca)
	comm=$(loge)
	specm=$(come openra-ca)

	if [[ $specn == $mastn ]]; then
		printf "OpenRA Combined Arms is up-to-date!\n"
	else
		sed -i -e "s/$specm/$comm/g" \
			   -e "s/$specn/$mastn/g" "$OBSH"/openra-ca/{openra-ca.spec,PKGBUILD}
		if ! [[ "$enpv" == "$enlv" ]]; then
			sed -i -e "s/$enpv/$enlv/g" "$HOME"/OBS/home:fusion809/openra-ca/{openra-ca.spec,PKGBUILD}
			make clean || exit
			make || exit
			tar czvf "$HOME"/OBS/home:fusion809/openra-ca/engine-"${enlv}".tar.gz engine
			cdobsh openra-ca || exit
			osc rm engine-"${enpv}".tar.gz
			osc add engine-"${enlv}".tar.gz
			cd - || exit
		fi
		cdobsh openra-ca || exit
		osc ci -m "Bumping $specn->$mastn"
	fi
	# An expanded caup func was used in commit eb723d4af07bf2a72038a938525f18cd98df2699 and earlier
	mod-build CAmod
	canup
}
