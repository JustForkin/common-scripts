# Presently packaged version
function presently_packaged_mod_versions {
	# $1 refers to the number of the item in the list:
	# grep "^    version = \"" < $OPENRA_NIXPKG_PATH/mods.nix 
	# we're interested in
	if ( ! [[ -n "$1" ]] ) || [[ "$1" == "1" ]]; then
		grep "^    version = \"" < $OPENRA_NIXPKG_PATH/mods.nix | head -n 1 | cut -d '"' -f 2
	else
		grep "^    version = \"" < $OPENRA_NIXPKG_PATH/mods.nix | head -n "$1" | tail -n 1 | cut -d '"' -f 2
	fi
}

alias verpres=presently_packaged_mod_versions

# Presently packaged commit
function presently_packaged_commit_hashes {
	if ( ! [[ -n "$1" ]] ) || [[ "$1" == "1" ]]; then
		grep "^      rev = \"" < $OPENRA_NIXPKG_PATH/mods.nix | head -n 1 | cut -d '"' -f 2
	else
		grep "^      rev = \"" < $OPENRA_NIXPKG_PATH/mods.nix | head -n "$1" | tail -n 1 | cut -d '"' -f 2
	fi
}

alias compres=presently_packaged_commit_hashes

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