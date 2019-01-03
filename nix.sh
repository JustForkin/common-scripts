#if [[ -d $NIXPKGS ]]; then
#	export NIX_PATH="my-fork=$NIXPKGS:nixos-unstable=/nix/var/nix/profiles/per-user/root/channels/nixos-unstable:nixos-config=/etc/nixos/configuration.nix"
if ! [[ -d /run/current-system/sw/bin ]]; then
	export NIX_PATH=nixpkgs=/nix/var/nix/profiles/per-user/$USER/channels/nixpkgs
elif [[ -d /nix/var/nix/profiles/per-user/root/channels/nixos ]]; then
	export NIX_PATH=nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos:nixos-config=/etc/nixos/configuration.nix:/nix/var/nix/profiles/per-user/root/channels
elif [[ -d /nix/var/nix/profiles/per-user/root/channels/nixos-unstable ]]; then
	export NIX_PATH=nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos-unstable:nixos-config=/etc/nixos/configuration.nix:/nix/var/nix/profiles/per-user/root/channels
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
#	nix-channel --update && nix-env --upgrade
	cdnp
	# Update local fork
	git fetch upstream ; git merge upstream/master ; git push origin $(git-branch)
	# Update user-installed packages
	nix-env -f $NIXPKGS --upgrade
}

function nixr {
	nix-env --uninstall "$@"
}

function nixs {
	nix search "$@"
}

function nixi {
	if ( [[ -d /etc/nixos ]] && ( nix-channel --list | grep my-fork &> /dev/null ) ); then
		nix-env -f '<my-fork>' -iA "$@"
	elif [[ -d $NIXPKGS ]] ; then
		nix-env -f $NIXPKGS -iA "$@"
	elif ( [[ -d /etc/nixos ]] && ( nix-channel --list | grep nixos-unstable &> /dev/null ) ); then
		nix-env -f '<nixos-unstable>' -iA "$@"
	elif ( [[ -d /etc/nixos ]] && ( nix-channel --list | grep nixos &> /dev/null ) ); then
		nix-env -f '<nixos>' -iA "$@"
	elif ( [[ -d /etc/nixos ]] && ( nix-channel --list | grep "[0-9a-zA-Z]" &> /dev/null ) ); then
		nix-env -iA "$@"
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
	#sudo nixos-rebuild switch
	sudo su -c "nixos-rebuild boot"
	sudo nix-collect-garbage -d
}

function nixif {
	nix-env -if "$@"
}

function nixb {
	if [[ -n $1 ]]; then
		nix-env -f $NIXPKGS -iA "$@"
	elif [[ "${PWD##*/}" == "vim" ]] && ( grep -i "NixOS" < /etc/os-release &> /dev/null ); then
		nix-env -f $NIXPKGS -iA vimHugeX
	else		
		nix-env -f $NIXPKGS -iA ${PWD##*/}
	fi
}

function sedsha {
	if [[ "${1}" == "--help" ]]; then
		printf "First argument is the line number in which sha256 is to be replaced; second argument is the checksum value.\n"
	fi
	if [[ -f common.nix ]]; then
		FILE="common"
	else
		FILE="default"
	fi
	sed -i -e "${1}s/sha256 = \".*\"/sha256 = \"${2}\"/" $FILE.nix
}
