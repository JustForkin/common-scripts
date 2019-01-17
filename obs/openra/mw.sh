function mwup {
	cdgo Medieval-Warfare || return
	git pull origin Next -q
	# OpenRA latest engine version
	latest_engine_version=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
	if [[ $latest_engine_version == "{DEV_VERSION}" ]]; then
		latest_engine_version=$(git -C $GHUBO/OpenRA-mw log | head -n 1 | cut -d ' ' -f 2)
	fi
	# OpenRA engine version in spec file
	packaged_engine_version=$(grep "define engine\_version" < "$OBSH"/openra-mw/openra-mw.spec | cut -d ' ' -f 3)
	latest_latest_commit_hashit_number=$(git rev-list --branches Next --count)
	packaged_latest_commit_hashit_number=$(grep "Version\:" < "$OBSH"/openra-mw/openra-mw.spec | sed 's/Version:\s*//g')
	latest_commit_hash=$(git log | head -n 1 | cut -d ' ' -f 2)
	packaged_commit_hash=$(grep "define latest_commit_hashit" < "$OBSH"/openra-mw/openra-mw.spec | cut -d ' ' -f 3)

	if [[ $packaged_latest_commit_hashit_number == $latest_latest_commit_hashit_number ]]; then
		printf "%s\n" "OpenRA Medieval Warfare mod is up to date!"
	else
		sed -i -e "s/$packaged_commit_hash/$latest_commit_hash/g" \
			   -e "s/$packaged_latest_commit_hashit_number/$latest_latest_commit_hashit_number/g" "$OBSH"/openra-mw/{openra-mw.spec,PKGBUILD}
		if [[ $latest_engine_version == "{DEV_VERSION}" ]]; then
			pushd $GHUBO/OpenRA || return
			git pull origin bleed
			latest_engine_version=$(git rev-list --branches bleed --count)
			popd || return
		fi
		if ! [[ "$packaged_engine_version" == "$latest_engine_version" ]]; then
			sed -i -e "s/$packaged_engine_version/$latest_engine_version/g" "$OBSH"/openra-mw/{openra-mw.spec,PKGBUILD}
			make || return
			tar czvf "$OBSH"/openra-mw/engine-"${latest_engine_version}".tar.gz engine
			cdobsh openra-mw || return
			osc rm engine-"${packaged_engine_version}".tar.gz
			osc add engine-"${latest_engine_version}".tar.gz
			cd - || return
		fi
		cdobsh openra-mw || return
		if ! [[ "$packaged_engine_version" == "$latest_engine_version" ]]; then
			osc ci -m "Bumping $packaged_latest_commit_hashit_number->$latest_latest_commit_hashit_number; engine $packaged_engine_version->$latest_engine_version"
		else
			osc ci -m "Bumping $packaged_latest_commit_hashit_number->$latest_latest_commit_hashit_number; engine version is unchanged."
		fi
	fi
	openra_mod_appimage_build Medieval-Warfare
	if grep "Arch" < /etc/os-release &> /dev/null ; then
		printf "%s\n" "Run mwnup under NixOS, as in an Arch chroot nix-prefetch fails."
	elif grep "NixOS" < /etc/os-release &> /dev/null ; then
		mwnup
	fi
}
