# Dark Reign update
function drup {
	cdgo DarkReign || return
	git pull origin master -q
	# OpenRA latest engine version
	enlv=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
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
	mod-build DarkReign
	if grep "Arch" < /etc/os-release &> /dev/null ; then
		printf "Run drnup under NixOS, as in an Arch chroot nix-prefetch fails.\n"
	elif grep "NixOS" < /etc/os-release &> /dev/null ; then
		drnup
	fi
}

