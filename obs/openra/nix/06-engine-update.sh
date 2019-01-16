function engine_update {
	release="$(git -C $GHUBO/OpenRA tag | grep "release\-" | tail -n 1 | cut -d '-' -f 2)"
	release_oldver="$(grep "    version = \"" < $NIXPATH/engines.nix | head -n 1 | cut -d '"' -f 2)"
	playtest="$(git -C $GHUBO/OpenRA tag | grep "playtest\-" | tail -n 1 | cut -d '-' -f 2)"
	playtest_oldver="$(grep "    version = \"" < $NIXPATH/engines.nix | tail -n 1 | cut -d '"' -f 2)"
	bleed="$(git -C $GHUBO/OpenRA log | head -n 1 | cut -d ' ' -f 2)"
	bleed_oldver="$(grep " commit = \"" < $NIXPATH/engines.nix | head -n 1 | cut -d '"' -f 2)"
	
	if ! [[ "${release}" == "${release_oldver}" ]] ; then
		release_sha256=$(nix-prefetch $NIXPKGS openraPackages.engines.release)
		sed -i -e "25s|\".*\"|\"${release}\"|" $NIXPATH/engines.nix || (printf "Sedding release version (${release}) failed at line 11 of 06-engine.sh.\n" && return)
	    sed -i -e "27s|\".*\"|\"${release_sha256}\"|" $NIXPATH/engines.nix || (printf "Sedding release (${release}) hash (${release_sha256}) failed at line 12 of 06-engine.sh.\n" && return)
	fi

	if ! [[ "${playtest}" == "${playtest_oldver}" ]] ; then
	  playtest_sha256=$(nix-prefetch $NIXPKGS openraPackages.engines.playtest)
		sed -i -e "31s|\".*\"|\"${playtest}\"|" $NIXPATH/engines.nix || (printf "Sedding playtest version (${playtest}) failed at line 17 of 06-engine.sh.\n" && return)
		sed -i -e "33s|\".*\"|\"${playtest_sha256}\"|" $NIXPATH/engines.nix || (printf "Sedding playtest (${playtest}) hash (${playtest_sha256}) failed at line 18 of 06-engine.sh.\n" && return)
	fi

	if ! [[ "${bleed}" == "${bleed_oldver}" ]] ; then
		bleed_sha256=$(nix-prefetch $NIXPKGS openraPackages.engines.bleed)
		sed -i -e "36s|\".*\"|\"${bleed}\"|" $NIXPATH/engines.nix || (printf "Sedding bleed version (${bleed}) failed at line 23 of 06-engine.sh.\n" && return)
		sed -i -e "39s|\".*\"|\"${bleed_sha256}\"|" $NIXPATH/engines.nix  || (printf "Sedding bleed version (${bleed_sha256}) hash (${bleed_sha256}) failed at line 24 of 06-engine.sh.\n" && return)
  fi
}