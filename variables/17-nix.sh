if [[ -d ~/.nix-profile/lib/locale ]]; then
	export LOCALE_ARCHIVE="$(readlink ~/.nix-profile/lib/locale)/locale-archive"
elif [[ -d /run/current-system/sw/lib/locale ]]; then
	export LOCALE_ARCHIVE="$(readlink /run/current-system/sw/lib/locale)/locale-archive"
fi

export OPENRA_NIXPKG_PATH="$PKG/nixpkgs/pkgs/games/openra"
