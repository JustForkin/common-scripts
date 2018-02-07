export EDITOR=vim
# GUI Editor - used by the `e` command
export GUIEDITOR=gvim

if [[ -d $HOME/.nix-profile/share ]]; then
    export XDG_DATA_DIRS=$XDG_DATA_DIRS:$HOME/.nix-profile/share
fi
