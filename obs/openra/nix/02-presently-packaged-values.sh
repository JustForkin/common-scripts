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

# Packaged engine version hash
function enpres {
	if ( ! [[ -n "$1" ]] ) || [[ "$1" == "1" ]]; then
		grep "^      version = \"" < $NIXPATH/mods.nix | head -n 1 | cut -d '"' -f 2
	else
		grep "^      version = \"" < $NIXPATH/mods.nix | head -n ${1} | tail -n 1 | cut -d '"' -f 2
	fi
}