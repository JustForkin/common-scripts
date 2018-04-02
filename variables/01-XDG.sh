# Nix
if [[ -d $HOME/.nix-profile/share ]]; then
    export XDG_DATA_DIRS=$HOME/.nix-profile/share
fi
