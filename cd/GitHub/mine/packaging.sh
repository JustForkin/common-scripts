# Packaging
function cdpk {
    cdgm "packaging/$1"
}

alias cdpck=cdpk

function cdaim {
    cdpk "AppImages/$1"
}

function cddae {
    cdpk "docker-atom-editor/$1"
}

function cdfo {
    cdpk "fusion809-overlay/$1"
}

function cdnp {
	if [[ -n "$1" ]]; then
		if [[ -d $NIXPKGS/pkgs/games/$1 ]]; then
    		cd "$NIXPKGS/pkgs/games/$1"
		elif [[ -d $NIXPKGS/pkgs/applications/editors/$1 ]]; then
			cd "$NIXPKGS/pkgs/applications/editors/$1"
		elif [[ -d $NIXPKGS/$1 ]]; then
			cd "$NIXPKGS/$1"
		elif [[ -d $NIXPKGS/pkgs/$1 ]]; then
			cd "$NIXPKGS/pkgs/$1"
		elif [[ -d $NIXPKGS/pkgs/applications/$1 ]]; then
			cd "$NIXPKGS/pkgs/applications/$1"
		elif [[ -d $NIXPKGS/pkgs/applications/*/$1 ]]; then
			cd $NIXPKGS/pkgs/applications/*/$1
		elif [[ -d $NIXPKGS/pkgs/applications/science/math/$1 ]]; then
			cd "$NIXPKGS/pkgs/applications/science/math/$1"
		elif [[ -d $NIXPKGS/pkgs/applications/science/chemistry/$1 ]]; then
			cd "$NIXPKGS/pkgs/applications/science/chemistry/$1"
		elif [[ -d $NIXPKGS/pkgs/applications/science/*/$1 ]]; then
			cd $NIXPKGS/pkgs/applications/science/*/$1
		elif [[ -d $NIXPKGS/pkgs/development/compilers/$1 ]]; then
			cd $NIXPKGS/pkgs/development/compilers/$1
		elif [[ -d $NIXPKGS/pkgs/development/interpreters/$1 ]]; then
			cd $NIXPKGS/pkgs/development/interpreters/$1
		elif [[ "$1" == "googleearth" ]]; then
			cd $PK/nixpkgs.googleearth-pr/pkgs/applications/misc/$1
		else
			printf "Target directory not found.\n" && return
		fi
	else
		cd $NIXPKGS
	fi
}

# cd to my OpenRA repository
function cdora {
    cdpk "OpenRA/$1"
}

alias cdopenra=cdora
alias cdopra=cdora

function cdvp {
    cdpk "void-packages/$1"
}

function cdvps {
    cdvp "srcpkgs/$1"
}
