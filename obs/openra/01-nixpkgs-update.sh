# This function is from msteen @ GitHub and taken from NixOS/nixpkgs#53878
function nix-prefetch {
[[ $1 =~ ^(-v|--version)$ ]] && echo '@version@' && exit
if
  [[ $1 =~ ^(-h|--help)$ ]] && help_ret=0 || ! {
    help_ret=1
    [[ $1 == --ignore-hash ]] && ignore_hash=1 && shift || ignore_hash=0
    (( $# == 2 )) && nixpkgs=$1 && shift || nixpkgs='<nixpkgs>'
    (( $# == 1 )) && expr=$1 && shift
  }
then
  cat <<'EOF' > "/dev/std$( (( ! help_ret )) && echo out || echo err )"
Print the output hash of the package sources.

Usage:
  nix-prefetch --ignore-hash [<nixpkgs>] <sources>
  nix-prefetch -v | --version
  nix-prefetch -h | --help

Examples:
  nix-prefetch hello
  nix-prefetch --ignore-hash hello
  nix-prefetch hello.src
  nix-prefetch '[ hello.src ]'
  nix-prefetch 'let name = "hello"; in pkgs.${name}'

Options:
  --ignore-hash  Ignore the hash provided in the sources, use a dummy hash instead.
  -h, --help     Show help message.
  -v, --version  Show the version.
EOF
  exit $help_ret
fi

lines=$(nix eval --raw '(
  let
    dummyHashes = {
      sha1   = "00000000000000000000000000000000";
      sha256 = "0000000000000000000000000000000000000000000000000000";
      sha512 = "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    };
    pkgs = import '"$nixpkgs"' { };
  in with pkgs.lib; let
    x = with pkgs; '"$expr"';
    xs = if isList x then x else [ x ];
    srcs = concatMap (x: x.srcs or [ (x.src or x) ]) xs;
    overridenSrcs = (if '"$ignore_hash"' != 0
      then map (src: src.overrideAttrs (oldAttrs: {
        outputHash = dummyHashes.${oldAttrs.outputHashAlgo};
      }))
      else id
    ) srcs;
    lines = map (src:
      let
        wantedHashSize = stringLength dummyHashes.${src.outputHashAlgo};
        values = [ src.drvPath src.outputHash wantedHashSize ];
      in concatStringsSep " " (map toString values)
    ) overridenSrcs;
  in concatStringsSep "\n" lines
)') &&
while IFS=' ' read -r src_drv src_output_hash wanted_hash_size; do
  if output=$(nix-store --quiet --realize "$src_drv" 2>&1); then
    if (( ignore_hash )); then
      echo "Something went wrong, the dummy hash should always fail to build." >&2
      exit 1
    else
      echo "$src_output_hash"
    fi
  else
    # Check for the new format:
    # https://github.com/NixOS/nix/commit/5e6fa9092fb5be722f3568c687524416bc746423
    grep -o "[a-z0-9]\{$wanted_hash_size\}" <<< "$output" > >( [[ $output == 'hash mismatch'* ]] && tail -1 || head -1 )
  fi
done <<< "$lines"

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
# First and only input is the path to the repo
function engnew {
	# This does assume that if ENGINE_VERSION is {DEV_VERSION} my local copy of the engine repo is on the right branch for 
	# the mod, e.g. that OpenRA-mw is on the MedievalWarfareEngine branch
	# engine version per mod.config
	engver=$(grep "^ENGINE\_VERSION" < $1/mod.config | cut -d '"' -f 2)
	# The engine's repo name
	engsrc=$(grep "ENGINE\_VERSION" < $1/mod.config | tail -n 1 | cut -d '"' -f 2 | cut -d '/' -f 5)
	MOD_ID=$(grep "^MOD_ID" < $1/mod.config | head -n 1 | cut -d '"' -f 2)
	# The following two should match, assuming $engsrc is the name of the repo copy in $GHUBO
	# First is the engine URL, without protocol (so no https://), according to mod.config
	engsrcurl=$(grep "^AUTOMATIC_ENGINE_SOURCE" < $1/mod.config | tail -n 1 | cut -d '"' -f 2 | sed 's|https://||g' | sed 's|/archive/.*.zip||g')
	if [[ -d $GHUBO/$engsrc ]]; then
		# This is the URL according to what git remote in the engine repo says, it is needed in case the repo 
		# just has the same name, e.g. some mods do not rename OpenRA when they fork it.
		engsrcrepoorigin=$(git -C $GHUBO/$engsrc remote -v | head -n 1 | sed 's|.*://||g' | sed 's/.git (fetch)//g' | sed 's/ (fetch)//g')
	elif [[ -d $GHUBO/OpenRA-mods/$engsrc ]]; then
		engsrcrepoorigin=$(git -C $GHUBO/OpenRA-mods/$engsrc remote -v | head -n 1 | sed 's|.*://||g' | sed 's/.git (fetch)//g' | sed 's/ (fetch)//g')
	else
		# If $GHUBO/$engsrc cannot be found, clone it
		git clone -q https://$engsrcurl $GHUBO/$engsrc
		engsrcrepoorigin="${engineurl}"
	fi
	
	# Determine whether these two URL match.
	if ! [[ "${engsrcurl}" == "${engsrcrepoorigin}" ]]; then
		if [[ -d $GHUBO/OpenRA-${MOD_ID} ]]; then
			engsrc="OpenRA-${MOD_ID}"
			engsrcrepoorigin=$(git -C $GHUBO/$engsrc remote -v | head -n 1 | sed 's|.*://||g' | sed 's/.git (fetch)//g' | sed 's/ (fetch)//g')
		elif [[ -d $GHUBO/OpenRA-mods/OpenRA-${MOD_ID} ]]; then
			engsrc="OpenRA-mods/OpenRA-${MOD_ID}"
			engsrcrepoorigin=$(git -C $GHUBO/$engsrc remote -v | head -n 1 | sed 's|.*://||g' | sed 's/.git (fetch)//g' | sed 's/ (fetch)//g')
	  else
			engsrcrepoorigin=$(git -C $GHUBO/$engsrc remote -v | head -n 1 | sed 's|.*://||g' | sed 's/.git (fetch)//g' | sed 's/ (fetch)//g') || return
			## Give myself some details, of the variables being used, should something go wrong. 
			printf "Cannot find engine source directory, as it doesn't seem to be $GHBUO/$engsrc, nor $GHUBO/OpenRA-${MOD_ID}, nor $GHUBO/OpenRA-mods/OpenRA-${MOD_ID}.\n" 
			printf "engsrcrepoorigin is $engsrcrepoorigin. engsrcurl is $engsrcurl. engver is $engver.\n" && return
		fi
	fi
			
	if ( [[ $engver == "{DEV_VERSION}" ]] || [[ $engver == "SP-Bleed-Branch" ]] || [[ $engver == "MedievalWarfareEngine" ]]) && [[ $engsrcrepoorigin == $engsrcurl ]] ; then
		if [[ $engver == "{DEV_VERSION}" ]] && [[ $(git-branch $GHUBO/$engsrc) != "bleed" ]]; then
			git -C "$GHUBO/$engsrc" checkout bleed
		elif [[ $engver == "SP-Bleed-Branch" ]] && [[ $(git-branch $GHUBO/$engsrc) != "SP-Bleed-Branch" ]]; then
			git -C "$GHUBO/$engsrc" checkout SP-Bleed-Branch
		elif [[ $engver == "MedievalWarfareEngine" ]] && [[ $(git-branch $GHUBO/$engsrc) != "MedievalWarfareEngine" ]]; then
			git -C "$GHUBO/$engsrc" checkout MedievalWarfareEngine
		fi
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
	git -C ${1} pull origin $(git-branch "${1}") -q || (printf "Git pulling ${1} at line 137 of 01-nixpkgs-update.sh failed.\n" && return)
	vernew=$(comno "${1}")
	verprese=$(verpres "${2}")

	sed -i -e "${3}s|${verprese}|${vernew}|" $NIXPATH/mods.nix || (printf "Sedding mod commit number at line 141 of 01-nixpkgs-update.sh failed.\n" && return)

	## Commit hash
	comnew=$(loge "${1}")
	comprese=$(compres "${2}")
	
	sed -i -e "${4}s|${comprese}|${comnew}|" $NIXPATH/mods.nix || (printf "Sedding mod commit hash at line 147 of 01-nixpkgs-update.sh failed.\n" && return)

	## Commit hash (engine)
	engrevnew=$(engnew ${1})
	engrevpres=$(comenpres "${2}")
	sed -i -e "${5}s|${engrevpres}|${engrevnew}|" $NIXPATH/mods.nix || (printf "Sedding engine revision at line 152 of 01-nixpkgs-update.sh failed.\n" && return)

	# Check if either engine, or mod has been updated, 
	# as nix-prefetch can chew up a bit of bandwidth unnecessarily if used when there is no need
	if ( ! [[ "$comnew" == "$comprese" ]] ) || ( ! [[ "$engrevnew" == "$engrevpres" ]] ); then
		MOD_ID=$(grep "^MOD_ID" < $1/mod.config | head -n 1 | cut -d '"' -f 2)
		sha256=$(nix-prefetch $NIXPKGS openraPackages.mods.${MOD_ID})
		# First is the mod's hash, second is engine
		sha256_1=$(echo $sha256 | head -n 1)
		sha256_2=$(echo $sha256 | tail -n 1)

		sed -i -e "$((${4}+1))s|\".*\"|\"${sha256_1}\"|" $NIXPATH/mods.nix || (printf "Sedding mod hash (${sha256_1}) at line 163 of 01-nixpkgs-update.sh failed.\n" && return)
		sed -i -e "${6}s|\".*\"|\"${sha256_2}\"|" $NIXPATH/mods.nix || (printf "Sedding engine hash at line 164 of 01-nixpkgs-update.sh failed.\n" && return)
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
		sed -i -e "25s|\".*\"|\"${release}\"|" $NIXPATH/engines.nix || (printf "Sedding release version (${release}) failed at line 178 of 01-nixpkgs-update.sh.\n" && return)
	  sed -i -e "27s|\".*\"|\"${release_sha256}\"|" $NIXPATH/engines.nix || (printf "Sedding release (${release}) hash (${release_sha256}) failed at line 179 of 01-nixpkgs-update.sh.\n" && return)
	fi

	if ! [[ "${playtest}" == "${playtest_oldver}" ]] ; then
	  playtest_sha256=$(nix-prefetch $NIXPKGS openraPackages.engines.playtest)
		sed -i -e "31s|\".*\"|\"${playtest}\"|" $NIXPATH/engines.nix || (printf "Sedding playtest version (${playtest}) failed at line 183 of 01-nixpkgs-update.sh.\n" && return)
		sed -i -e "33s|\".*\"|\"${playtest_sha256}\"|" $NIXPATH/engines.nix || (printf "Sedding playtest (${playtest}) hash (${playtest_sha256}) failed at line 184 of 01-nixpkgs-update.sh.\n" && return)
	fi

	if ! [[ "${bleed}" == "${bleed_oldver}" ]] ; then
		bleed_sha256=$(nix-prefetch $NIXPKGS openraPackages.engines.bleed)
		sed -i -e "36s|\".*\"|\"${bleed}\"|" $NIXPATH/engines.nix || (printf "Sedding bleed version (${bleed}) failed at line 188 of 01-nixpkgs-update.sh.\n" && return)
		sed -i -e "39s|\".*\"|\"${bleed_sha256}\"|" $NIXPATH/engines.nix  || (printf "Sedding bleed version (${bleed_sha256}) hash (${bleed_sha256}) failed at line 189 of 01-nixpkgs-update.sh.\n" && return)
  fi
}

function canup {
	nixoup2 "$GHUBO/CAmod" "1" "10" "17" "20" "26"
}

function d2nup {
	nixoup2 "$GHUBO/d2" "2" "34" "41" "45" "51"
}

function drnup {
	nixoup2 "$GHUBO/DarkReign" "3" "63" "70" "73" "79"
}

function gennup {
	nixoup2 "$GHUBO/Generals-Alpha" "4" "87" "94" "98" "103"
}

function kkndnup {
	nixoup2 "$GHUBO/KKnD" "5" "111" "118" "121" "127"
}

function mwnup {
	nixoup2 "$GHUBO/Medieval-Warfare" "6" "135" "142" "145" "151"
}

function ra2nup {
	nixoup2 "$GHUBO/ra2" "7" "159" "166" "170" "175"
}

function racnup {
	nixoup2 "$GHUBO/raclassic" "8" "187" "194" "198" "203"
}

function rvnup {
	nixoup2 "$GHUBO/Romanovs-Vengeance" "9" "211" "218" "221" "228"
}

function spnup {
	nixoup2 "$GHUBO/SP-OpenRAModSDK" "10" "240" "247" "250" "257"
}

function ssnup {
	nixoup2 "$GHUBO/sole-survivor" "11" "265" "272" "275" "281"
}

function uranup {
	nixoup2 "$GHUBO/uRA" "12" "289" "296" "300" "305"
}

function yrnup {
	nixoup2 "$GHUBO/yr" "13" "313" "320" "324" "329"
}

function nixpkgs-openra-up {
	# Mods
	canup ; d2nup ; drnup ; gennup ; kkndnup ; mwnup ; ra2nup ; racnup ; rvnup ; spnup ; ssnup ; uranup ; yrnup

	# Engines
	engine_update
}
