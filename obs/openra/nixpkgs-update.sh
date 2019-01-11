function pkg_src_sha256s {
  src_drvs=$(nix-instantiate --eval --strict --json --expr \
    "let pkg = with import $NIXPKGS { }; $1; in map (src: src.drvPath) pkg.srcs or [ pkg.src ]" |
    jq --raw-output '.[]') &&
  for src_drv in $(echo $src_drvs); do
    result=$(nix-store --quiet --realize "$src_drv" 2>&1) &&
    nix-store --query --hash "$result" | cut -d: -f2 ||
    sed -n 's/.*\([a-z0-9]\{52\}\).*[a-z0-9]\{52\}.*/\1/p' <<< "$result"
  done
}

nix-prefetch-src() {
  local help_ret=1 nixpkgs
  if
    [[ $1 =~ ^(-h|--help)$ ]] && help_ret=0 || {
      (( $# > 1 )) && nixpkgs=$1 && shift || nixpkgs='<nixpkgs>'
      ! (( $# == 1 ))
    }
  then
    help_msg='Print the the hash of the sources.

Usage:
  nix-prefetch-src [<nixpkgs>] <srcs>
  nix-prefetch-src -h | --help

Options:
  -h, --help  Show help message.'
    ! (( help_ret )) && echo "$help_msg" || echo "$help_msg" >&2
    return $help_ret
  fi
  src_drvs=$(nix eval --raw '(
    let
      x = with import '"$nixpkgs"' { }; ('"$1"');
      xs = if builtins.isList x then x else [ x ];
      srcs = builtins.concatMap (x: if builtins.isList x then x else x.srcs or [ (x.src or x) ]) xs;
      src_drvs = map (src: (src.overrideAttrs (_: { outputHash = "0000000000000000000000000000000000000000000000000000"; })).drvPath) srcs;
    in builtins.concatStringsSep "\n" src_drvs
  )') &&
  while IFS= read -r src_drv; do
    result=$(nix-store --quiet --realize "$src_drv" 2>&1) &&
    nix-store --query --hash "$result" | cut -d: -f2 ||
    sed -n 's/.*\([a-z0-9]\{52\}\).*[a-z0-9]\{52\}.*/\1/p' <<< "$result"
  done <<< "$src_drvs"
}

# Presently packaged version
function verpres {
	# $1 refers to the number of the item in the list:
	# grep "^    version = \"" < $NIXPATH/mods.nix 
	# we're interested in
	if ( ! [[ -n "$1" ]] ) || [[ "$1" == "1" ]]; then
		grep "^    version = \"" < $NIXPATH/mods.nix | head -n 1 | cut -d '"' -f 2
	else
		tailno=$((${1}-1))
		grep "^    version = \"" < $NIXPATH/mods.nix | head -n "$1" | tail -n 1 | cut -d '"' -f 2
	fi
}

# Presently packaged commit
function compres {
	if ( ! [[ -n "$1" ]] ) || [[ "$1" == "1" ]]; then
		grep "^      rev = \"" < $NIXPATH/mods.nix | head -n 1 | cut -d '"' -f 2
	else
		grep "^      rev = \"" < $NIXPATH/mods.nix | head -n "$1" | tail -n 1 | cut -d '"' -f 2
	fi
}

# Packaged engine commit hash
function comenpres {
	if ( ! [[ -n "$1" ]] ) || [[ "$1" == "1" ]]; then
		grep " commit = \"" < $NIXPATH/mods.nix | head -n 1 | cut -d '"' -f 2
	else
		grep " commit = \"" < $NIXPATH/mods.nix | head -n ${1} | tail -n 1 | cut -d '"' -f 2
	fi
}

# New engine commit hash
function engnew {
	# This does assume that if ENGINE_VERSION is {DEV_VERSION} my local copy of the engine repo is on the right branch for the mod
	# e.g. that OpenRA-mw is on the MedievalWarfareEngine branch
	engver=$(grep "^ENGINE\_VERSION" < $1/mod.config | cut -d '"' -f 2)
	engsrc=$(grep "ENGINE\_VERSION" < $1/mod.config | tail -n 1 | cut -d '"' -f 2 | cut -d '/' -f 5)
	MOD_ID=$(grep "^MOD_ID" < $1/mod.config | head -n 1 | cut -d '"' -f 2)
	# The following two should match
	engsrcurl=$(grep "^AUTOMATIC_ENGINE_SOURCE" < $1/mod.config | tail -n 1 | cut -d '"' -f 2 | sed 's|https://||g' | sed 's|/archive/.*.zip||g')
	if [[ -d $GHUBO/$engsrc ]]; then
		engsrcrepoorigin=$(git -C $GHUBO/$engsrc remote -v | head -n 1 | sed 's|.*://||g' | sed 's/.git (fetch)//g' | sed 's/ (fetch)//g')
	fi

	if ! [[ -d $GHUBO/$engsrc ]]; then
		git clone -q https://$engsrcurl $GHUBO/$engsrc
		engsrcrepoorigin="${engineurl}"
	fi
	
	if ! [[ $engsrcurl == $engsrcrepoorigin ]]; then
		if [[ -d $GHUBO/OpenRA-${MOD_ID} ]]; then
			engsrc="OpenRA-${MOD_ID}"
			engsrcrepoorigin=$(git -C $GHUBO/$engsrc remote -v | head -n 1 | sed 's|.*://||g' | sed 's/.git (fetch)//g' | sed 's/ (fetch)//g')
		elif [[ -d $GHUBO/OpenRA-mods/OpenRA-${MOD_ID} ]]; then
			engsrc="OpenRA-mods/OpenRA-${MOD_ID}"
			engsrcrepoorigin=$(git -C $GHUBO/$engsrc remote -v | head -n 1 | sed 's|.*://||g' | sed 's/.git (fetch)//g' | sed 's/ (fetch)//g')
	    else
			engsrcrepoorigin=$(git -C $GHUBO/$engsrc remote -v | head -n 1 | sed 's|.*://||g' | sed 's/.git (fetch)//g' | sed 's/ (fetch)//g')
			printf "Cannot find engine source directory, as it doesn't seem to be either $engsrc, nor $GHUBO/OpenRA-${MOD_ID}, nor $GHUBO/OpenRA-mods/OpenRA-${MOD_ID}.\n" && return
		fi
	fi
			
	if [[ $engver == "{DEV_VERSION}" ]] && [[ $engsrcrepoorigin == $engsrcurl ]] ; then
		git -C "$GHUBO/$engsrc" pull origin $(git-branch $GHUBO/$engsrc) -q
		engver=$(loge $GHUBO/$engsrc)
	fi

	printf "${engver}\n"
}

function nixoup2 {
	# First input is path to mod repo
	# Second is the mod's number, with respect to its position in mods.nix (e.g. 1 for CA, 2 for D2, 3 for DR, etc.)
	# Third is the line on which the version for the mod is listed
	# Fourth is the line on which the commit for the mod is listed
	# Fifth is the line on which the commit/version for the mod's engine is listed
	# Sixth is the line the engine's source's sha256 is listed
	## Commit number (version)
	git -C ${1} pull origin $(git-branch "${1}") -q
	vernew=$(comno "${1}")
	verprese=$(verpres "${2}")

	sed -i -e "${3}s|${verprese}|${vernew}|" $NIXPATH/mods.nix

	## Commit hash
	comnew=$(loge "${1}")
	comprese=$(compres "${2}")
	
	sed -i -e "${4}s|${comprese}|${comnew}|" $NIXPATH/mods.nix

	## Commit hash (engine)
	engrevnew=$(engnew ${1})
	engrevpres=$(comenpres "${2}")
	sed -i -e "${5}s|${engrevpres}|${engrevnew}|" $NIXPATH/mods.nix

	# Check if either engine, or mod has been updated, 
	# as nix-prefetch-src can chew up a bit of bandwidth unnecessarily if used when there is no need
	if ( ! [[ "$comnew" == "$comprese" ]] ) || ( ! [[ "$engrevnew" == "$engrevpres" ]] ); then
		MOD_ID=$(grep "^MOD_ID" < $1/mod.config | head -n 1 | cut -d '"' -f 2)
		sha256=$(nix-prefetch-src $NIXPKGS openraPackages.mods.${MOD_ID})
		# First is the mod's hash, second is engine
		sha256_1=$(echo $sha256 | head -n 1)
		sha256_2=$(echo $sha256 | tail -n 1)

		sed -i -e "$((${4}+1))s|\".*\"|\"${sha256_1}\"|" $NIXPATH/mods.nix
		sed -i -e "${6}s|\".*\"|\"${sha256_2}\"|" $NIXPATH/mods.nix
	fi
}

function nixpkgs-openra-up {
	# ca

	nixoup2 "$GHUBO/CAmod" "1" "10" "17" "20" "26"
	
	# d2

	nixoup2 "$GHUBO/d2" "2" "34" "41" "45" "51"

	# dr

	nixoup2 "$GHUBO/DarkReign" "3" "63" "70" "73" "79"

	# gen
	
	nixoup2 "$GHUBO/Generals-Alpha" "4" "87" "94" "98" "103"

	# kknd
	
	nixoup2 "$GHUBO/KKnD" "5" "111" "118" "121" "127"

	# mw

	nixoup2 "$GHUBO/Medieval-Warfare" "6" "135" "142" "145" "151"

	# ra2

	nixoup2 "$GHUBO/ra2" "7" "159" "166" "170" "175"

	# raclassic

	nixoup2 "$GHUBO/raclassic" "8" "187" "194" "198" "203"

	# rv

	nixoup2 "$GHUBO/Romanovs-Vengeance" "9" "211" "218" "221" "228"

	# sp

	nixoup2 "$GHUBO/SP-OpenRAModSDK" "10" "240" "247" "250" "257"

	# ss

	nixoup2 "$GHUBO/Sole-Survivor" "11" "265" "272" "275" "281"

	# ura

	nixoup2 "$GHUBO/uRA" "12" "289" "296" "300" "305"

	# yr
	nixoup2 "$GHUBO/yr" "13" "313" "320" "324" "329"

	# Engines
	release="$(git -C $GHUBO/OpenRA tag | grep "release\-" | tail -n 1 | cut -d '-' -f 2)"
	release_oldver="$(grep "    version = \"" < engines.nix | head -n 1 | cut -d '"' -f 2)"
	playtest="$(git -C $GHUBO/OpenRA tag | grep "playtest\-" | tail -n 1 | cut -d '-' -f 2)"
	playtest_oldver="$(grep "    version = \"" < engines.nix | tail -n 1 | cut -d '"' -f 2)"
	bleed="$(git -C $GHUBO/OpenRA log | head -n 1 | cut -d ' ' -f 2)"
	bleed_oldver="$(grep " commit = \"" < engines.nix | head -n 1 | cut -d '"' -f 2)"
	
	if ! [[ "${release}" == "${release_oldver}" ]] ; then
		release_sha256=$(nix-prefetch-src $NIXPKGS openraPackages.engines.release)
		sed -i -e "25s|\".*\"|\"${release}\"|" \
	    	   -e "27s|\".*\"|\"${release_sha256}\"|" $NIXPATH/engines.nix
	fi
	if ! [[ "${playtest}" == "${playtest_oldver}" ]] ; then
	    playtest_sha256=$(nix-prefetch-src $NIXPKGS openraPackages.engines.playtest)
		sed -i -e "31s|\".*\"|\"${playtest}\"|" \
		   	   -e "33s|\".*\"|\"${playtest_sha256}\"|" $NIXPATH/engines.nix
	fi
	if ! [[ "${bleed}" == "${bleed_oldver}" ]] ; then
		bleed_sha256=$(nix-prefetch-src $NIXPKGS openraPackages.engines.bleed)
		sed -i -e "36s|\".*\"|\"${bleed}\"|" \
		       -e "39s|\".*\"|\"${bleed_sha256}\"|" $NIXPATH/engines.nix
    fi
}
