function engine_update {
	latest_release_version="$(git -C $GHUBO/OpenRA tag | grep "release\-" | tail -n 1 | cut -d '-' -f 2)"
	old_release_version="$(grep "    version = \"" < $OPENRA_NIXPKG_PATH/engines.nix | head -n 1 | cut -d '"' -f 2)"
	latest_playtest_version="$(git -C $GHUBO/OpenRA tag | grep "playtest\-" | tail -n 1 | cut -d '-' -f 2)"
	old_playtest_version="$(grep "    version = \"" < $OPENRA_NIXPKG_PATH/engines.nix | tail -n 1 | cut -d '"' -f 2)"
	latest_bleed_hash="$(git -C $GHUBO/OpenRA log | head -n 1 | cut -d ' ' -f 2)"
	latest_bleed_7_character_hash=$(echo ${latest_bleed_hash} | head -c 7)
	latest_bleed_number=$(git -C $GHUBO/OpenRA rev-list --branches bleed --count)
	old_bleed_hash="$(grep " commit = \"" < $OPENRA_NIXPKG_PATH/engines.nix | head -n 1 | cut -d '"' -f 2)"
	
	if ! [[ "${latest_release_version}" == "${old_release_version}" ]] ; then
		printf "latest_release_version is ${latest_release_version}.\n"
		sed -i -e "25s|\".*\"|\"${latest_release_version}\"|" $OPENRA_NIXPKG_PATH/engines.nix || (printf "Sedding release version (${latest_release_version}) failed at line 13 of 05-engine-update.sh.\n" && return)
	    release_sha256=$(nix-prefetch --force $NIXPKGS openraPackages.engines.release)
		printf "release_sha256 is ${release_sha256}.\n"
	    sed -i -e "27s|\".*\"|\"${release_sha256}\"|" $OPENRA_NIXPKG_PATH/engines.nix || (printf "Sedding release (${latest_release_version}) hash (${release_sha256}) failed at line 16 of 05-engine-update.sh.\n" && return)
		cdnp; push "openra: :arrow_up: ${latest_release_version}"
	fi

	if ! [[ "${latest_playtest_version}" == "${old_playtest_version}" ]] ; then
		printf "latest_playtest_version is ${latest_playtest_version}.\n"
		sed -i -e "31s|\".*\"|\"${latest_playtest_version}\"|" $OPENRA_NIXPKG_PATH/engines.nix || (printf "Sedding playtest version (${latest_playtest_version}) failed at line 22 of 05-engine-update.sh.\n" && return)
		playtest_sha256=$(nix-prefetch --force $NIXPKGS openraPackages.engines.playtest)
		printf "playtest_sha256 is ${playtest_sha256}.\n"
		sed -i -e "33s|\".*\"|\"${playtest_sha256}\"|" $OPENRA_NIXPKG_PATH/engines.nix || (printf "Sedding playtest (${latest_playtest_version}) hash (${playtest_sha256}) failed at line 25 of 05-engine-update.sh.\n" && return)
		cdnp; push "openra: :arrow_up: ${latest_playtest_version}"
	fi

	if ! [[ "${latest_bleed_hash}" == "${old_bleed_hash}" ]] ; then
		printf "latest_bleed_hash is ${latest_bleed_hash}.\n"
		printf "latest_bleed_number is ${latest_bleed_number}.\n"
		sed -i -e "36s|\".*\"|\"${latest_bleed_hash}\"|" $OPENRA_NIXPKG_PATH/engines.nix || (printf "Sedding bleed hash (${latest_bleed_hash}) failed at line 32 of 05-engine-update.sh.\n" && return)
		bleed_sha256=$(nix-prefetch --force $NIXPKGS openraPackages.engines.bleed)
		printf "bleed_sha256 is ${bleed_sha256}.\n"
		sed -i -e "37s|\".*\"|\"${latest_bleed_number}\".git.\${latest_bleed_7_character_hash}\"|" $OPENRA_NIXPKG_PATH/engines.nix || ( printf "Sedding bleed commit version (${latest_bleed_number}.git.${latest_bleed_7_character_hash}) failed at line 35 of 05-engine-update.sh.\n" && return )
		sed -i -e "39s|\".*\"|\"${bleed_sha256}\"|" $OPENRA_NIXPKG_PATH/engines.nix || (printf "Sedding bleed version (${latest_bleed_hash}) checksum (${bleed_sha256}) failed at line 36 of 05-engine-update.sh.\n" && return)
		push "openra: :arrow_up: ${latest_bleed_number} (${latest_bleed_7_character_hash})"
	fi
}