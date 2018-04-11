export NIX_PATH=nixpkgs=/nix/var/nix/profiles/per-user/fusion809/channels/nixos/nixpkgs
export NIX_SSL_CERT_FILE=/etc/ssl/ca-bundle.pem

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
    nix-env -i "$@"
}

# Install from Nix file
function nixif {
    nix-env -if "$@"
}
