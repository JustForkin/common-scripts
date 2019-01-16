# Presently packaged version
function verpres {
	# $1 refers to the number of the item in the list:
	# grep "^    version = \"" < $OPENRA_NIXPKG_PATH/mods.nix 
	# we're interested in
	if ( ! [[ -n "$1" ]] ) || [[ "$1" == "1" ]]; then
		grep "^    version = \"" < $OPENRA_NIXPKG_PATH/mods.nix | head -n 1 | cut -d '"' -f 2
	else
		grep "^    version = \"" < $OPENRA_NIXPKG_PATH/mods.nix | head -n "$1" | tail -n 1 | cut -d '"' -f 2
	fi
}

# Presently packaged commit
function compres {
	if ( ! [[ -n "$1" ]] ) || [[ "$1" == "1" ]]; then
		grep "^      rev = \"" < $OPENRA_NIXPKG_PATH/mods.nix | head -n 1 | cut -d '"' -f 2
	else
		grep "^      rev = \"" < $OPENRA_NIXPKG_PATH/mods.nix | head -n "$1" | tail -n 1 | cut -d '"' -f 2
	fi
}

# Packaged engine commit hash
function comenpres {
	if ( ! [[ -n "$1" ]] ) || [[ "$1" == "1" ]]; then
		grep " commit = \"" < $OPENRA_NIXPKG_PATH/mods.nix | head -n 1 | cut -d '"' -f 2
	else
		grep " commit = \"" < $OPENRA_NIXPKG_PATH/mods.nix | head -n ${1} | tail -n 1 | cut -d '"' -f 2
	fi
}

# Packaged engine version hash
function enpres {
	if ( ! [[ -n "$1" ]] ) || [[ "$1" == "1" ]]; then
		grep "^      version = \"" < $OPENRA_NIXPKG_PATH/mods.nix | head -n 1 | cut -d '"' -f 2
	else
		grep "^      version = \"" < $OPENRA_NIXPKG_PATH/mods.nix | head -n ${1} | tail -n 1 | cut -d '"' -f 2
	fi
}