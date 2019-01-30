# Nix
#if [[ -d $HOME/.nix-profile/share ]]; then
#    export XDG_DATA_DIRS=$HOME/.nix-profile/share:/usr/share:/usr/share/glib-2.0/schemas:$HOME/.local/share
#fi

export XDG_DATA_DIRS=/usr/share:/usr/share/glib-2.0/schemas:$HOME/.local/share:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share
