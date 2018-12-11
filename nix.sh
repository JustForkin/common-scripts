if ! [[ -d /run/current-system/sw/bin ]]; then
	export NIX_PATH=nixpkgs=/nix/var/nix/profiles/per-user/$USER/channels/nixpkgs
fi

if [[ -f /etc/ssl/ca-bundle.pem ]]; then
	export NIX_SSL_CERT_FILE=/etc/ssl/ca-bundle.pem
elif [[ -f /etc/ssl/certs/ca-certificates.crt ]]; then
	export NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
elif [[ -f /etc/ssl/certs/ca-bundle.crt ]]; then
	export NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt
fi

if ! [[ -f $HOME/.config/nixpkgs/config.nix ]]; then
	mkdir -p $HOME/.config/nixpkgs
	printf "{ allowUnfree = true; }" > $HOME/.config/nixpkgs/config.nix
fi

function nixup {
	nix-channel --update && nix-env --upgrade
}

function nixr {
	nix-env --uninstall "$@"
}

function nixs {
	nix search "$@"
}

function nixi {
	if [[ -d /etc/nixos ]]; then
		nix-env -f '<nixos-unstable>' -iA "$@"
	else
		nix-env -f '<nixpkgs>' -iA "$@"
	fi
}

# Install from Nix file
function nixca {
	sudo nix-channel --add https://nixos.org/channels/$1
}

function nixcr {
	nix-channel --remove "$@"
}

function nixrb {
	sudo nix-channel --update
	sudo nixos-rebuild switch
	sudo nix-collect-garbage -d
}

function nixif {
	nix-env -if "$@"
}

function nixb {
	if [[ -n $1 ]]; then
		nix-env -f $NIXPKGS -iA "$@"
	else		
		nix-env -f $NIXPKGS -iA ${PWD##*/}
	fi
}
