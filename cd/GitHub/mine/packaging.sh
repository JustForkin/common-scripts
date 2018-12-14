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
	if [[ -d $NIXPKGS/pkgs/games/$1 ]]; then
    		cd "$NIXPKGS/pkgs/games/$1"
	elif [[ -d $NIXPKGS/pkgs/applications/editors/$1 ]]; then
		cd "$NIXPKGS/pkgs/editors/$1"
	elif [[ -d $NIXPKGS/$1 ]]; then
		cd "$NIXPKGS/$1"
	elif [[ -d $NIXPKGS/pkgs/$1 ]]; then
		cd "$NIXPKGS/pkgs/$1"
	elif [[ -d $NIXPKGS/pkgs/applications/$1 ]]; then
		cd "$NIXPKGS/pkgs/applications/$1"
	elif [[ -d $NIXPKGS/pkgs/applications/*/$1 ]]; then
		cd "$NIXPKGS/pkgs/applications/"*"/$1"
	elif [[ -d $NIXPKGS/pkgs/science/math/$1 ]]; then
		cd "$NIXPKGS/pkgs/science/math/$1"
	elif [[ -d $NIXPKGS/pkgs/science/*/$1 ]]; then
		cd "$NIXPKGS/pkgs/science/*/$1"
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
