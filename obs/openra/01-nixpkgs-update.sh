# This function is from msteen @ GitHub.
nix-prefetch() {
  local help_ret=1 nixpkgs expr
  if
    [[ $1 =~ ^(-h|--help)$ ]] && help_ret=0 || {
      (( $# == 2 )) && nixpkgs=$1 && shift || nixpkgs='<nixpkgs>'
      (( $# == 1 )) && expr=$1 && shift
      ! (( $# == 0 ))
    }
  then
    help_msg='Print the the hash of the sources.

Usage:
  nix-prefetch [<nixpkgs>] <srcs>
  nix-prefetch -h | --help

Options:
  -h, --help  Show help message.'
    ! (( help_ret )) && echo "$help_msg" || echo "$help_msg" >&2
    return $help_ret
  fi
  local src_drvs src_drv hash_size output
  src_drvs=$(nix eval --raw '(
    let
      pkgs = import '"$nixpkgs"' { };
      x = with pkgs; '"$expr"';
      xs = if builtins.isList x then x else [ x ];
      srcs = builtins.concatMap (x: x.srcs or [ (x.src or x) ]) xs;
      dummyHashes = {
        sha1   = "00000000000000000000000000000000";
        sha256 = "0000000000000000000000000000000000000000000000000000";
        sha512 = "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
      };
      dummySrcs = map (src: src.overrideAttrs (oldAttrs: {
        outputHash = dummyHashes.${oldAttrs.outputHashAlgo};
      })) srcs;
      srcDrvs = map (src: "${src.drvPath} ${toString (builtins.stringLength src.outputHash)}") dummySrcs;
    in builtins.concatStringsSep "\n" srcDrvs
  )') &&
  while IFS=' ' read -r src_drv hash_size; do
    if output=$(nix-store --quiet --realize "$src_drv" 2>&1); then
      echo "Something went wrong with the output hash, the dummy hash should always fail to build." >&2
      return 1
    else
      sed -n "s/.*\([a-z0-9]\{$hash_size\}\).*[a-z0-9]\{$hash_size\}.*/\1/p" <<< "$output"
    fi
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
	# engine version per mod.config
	engver=$(grep "^ENGINE\_VERSION" < $1/mod.config | cut -d '"' -f 2)
	# The engine's repo name
	engsrc=$(grep "ENGINE\_VERSION" < $1/mod.config | tail -n 1 | cut -d '"' -f 2 | cut -d '/' -f 5)
	MOD_ID=$(grep "^MOD_ID" < $1/mod.config | head -n 1 | cut -d '"' -f 2)
	# The following two should match, assuming $engsrc is the name of the repo copy in $GHUBO
	engsrcurl=$(grep "^AUTOMATIC_ENGINE_SOURCE" < $1/mod.config | tail -n 1 | cut -d '"' -f 2 | sed 's|https://||g' | sed 's|/archive/.*.zip||g')
	if [[ -d $GHUBO/$engsrc ]]; then
		engsrcrepoorigin=$(git -C $GHUBO/$engsrc remote -v | head -n 1 | sed 's|.*://||g' | sed 's/.git (fetch)//g' | sed 's/ (fetch)//g')
	elif [[ -d $GHUBO/OpenRA-mods/$engsrc ]]; then
		engsrcrepoorigin=$(git -C $GHUBO/OpenRA-mods/$engsrc remote -v | head -n 1 | sed 's|.*://||g' | sed 's/.git (fetch)//g' | sed 's/ (fetch)//g')
	fi

	if ( ! [[ -d $GHUBO/$engsrc ]] ) || ( ! [[ -d $GHUBO/OpenRA-mods/$engsrc ]] ); then
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
	# as nix-prefetch can chew up a bit of bandwidth unnecessarily if used when there is no need
	if ( ! [[ "$comnew" == "$comprese" ]] ) || ( ! [[ "$engrevnew" == "$engrevpres" ]] ); then
		MOD_ID=$(grep "^MOD_ID" < $1/mod.config | head -n 1 | cut -d '"' -f 2)
		sha256=$(nix-prefetch $NIXPKGS openraPackages.mods.${MOD_ID})
		# First is the mod's hash, second is engine
		sha256_1=$(echo $sha256 | head -n 1)
		sha256_2=$(echo $sha256 | tail -n 1)

		sed -i -e "$((${4}+1))s|\".*\"|\"${sha256_1}\"|" $NIXPATH/mods.nix
		sed -i -e "${6}s|\".*\"|\"${sha256_2}\"|" $NIXPATH/mods.nix
	fi
}

function engine_update {
	release="$(git -C $GHUBO/OpenRA tag | grep "release\-" | tail -n 1 | cut -d '-' -f 2)"
	release_oldver="$(grep "    version = \"" < $NIXPATH/engines.nix | head -n 1 | cut -d '"' -f 2)"
	playtest="$(git -C $GHUBO/OpenRA tag | grep "playtest\-" | tail -n 1 | cut -d '-' -f 2)"
	playtest_oldver="$(grep "    version = \"" < $NIXPATH/engines.nix | tail -n 1 | cut -d '"' -f 2)"
	bleed="$(git -C $GHUBO/OpenRA log | head -n 1 | cut -d ' ' -f 2)"
	bleed_oldver="$(grep " commit = \"" < $NIXPATH/engines.nix | head -n 1 | cut -d '"' -f 2)"
	
	if ! [[ "${release}" == "${release_oldver}" ]] ; then
		release_sha256=$(nix-prefetch $NIXPKGS openraPackages.engines.release)
		sed -i -e "25s|\".*\"|\"${release}\"|" \
	    	   -e "27s|\".*\"|\"${release_sha256}\"|" $NIXPATH/engines.nix
	fi
	if ! [[ "${playtest}" == "${playtest_oldver}" ]] ; then
	    playtest_sha256=$(nix-prefetch $NIXPKGS openraPackages.engines.playtest)
		sed -i -e "31s|\".*\"|\"${playtest}\"|" \
		   	   -e "33s|\".*\"|\"${playtest_sha256}\"|" $NIXPATH/engines.nix
	fi
	if ! [[ "${bleed}" == "${bleed_oldver}" ]] ; then
		bleed_sha256=$(nix-prefetch $NIXPKGS openraPackages.engines.bleed)
		sed -i -e "36s|\".*\"|\"${bleed}\"|" \
		       -e "39s|\".*\"|\"${bleed_sha256}\"|" $NIXPATH/engines.nix
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
	engine_update
}
