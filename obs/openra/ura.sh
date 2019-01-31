function uRAup {
	cdgo uRA || return
	git pull origin master -q
	# Latest engine version
	latest_engine_version=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
	# OpenRA engine version in spec file
	packaged_engine_version=$(grep "define engine\_version" < "$OBSH"/openra-ura/openra-ura.spec | cut -d ' ' -f 3)
	latest_commit_no=$(git rev-list --branches master --count)
	packaged_commit_number=$(grep "Version\:" < "$OBSH"/openra-ura/openra-ura.spec | sed 's/Version:\s*//g')
	latest_commit_hash=$(git log | head -n 1 | cut -d ' ' -f 2)
	packaged_commit_hash=$(grep "define commit" < "$OBSH"/openra-ura/openra-ura.spec | cut -d ' ' -f 3)

	if [[ "$packaged_commit_number" == "$latest_commit_no" ]]; then
		 printf "%s\n" "OpenRA Red Alert Unplugged mod is up to date\!"
	else
		 sed -i -e "s/$packaged_commit_hash/$latest_commit_hash/g" \
		 		-e "s/$packaged_commit_number/$latest_commit_no/g" "$OBSH"/openra-ura/{openra-ura.spec,PKGBUILD} 
		 if ! [[ "$packaged_engine_version" == "$latest_engine_version" ]]; then
			  sed -i -e "s/$packaged_engine_version/$latest_engine_version/g" "$OBSH"/openra-ura/{openra-ura.spec,PKGBUILD}
			  make clean || return
			  make || ( printf "Running make failed" && return )
			  tar czvf "$OBSH"/openra-ura/engine-"${latest_engine_version}".tar.gz engine
			  cdobsh openra-ura || return
			  osc rm engine-"${packaged_engine_version}".tar.gz
			  osc add engine-"${latest_engine_version}".tar.gz
			  cd - || return
		 fi
		 cdobsh openra-ura || return
		 if ! [[ "$packaged_engine_version" == "$latest_engine_version" ]]; then
			  osc ci -m "Bumping $packaged_commit_number->$latest_commit_no; engine $packaged_engine_version->$latest_engine_version"
		 else
			  osc ci -m "Bumping $packaged_commit_number->$latest_commit_no; engine version is unchanged."
		 fi
	fi
	openra_mod_appimage_build uRA
	uranup "${1}"
}

alias uraup=uRAup
