# RA Classic update
# Last commit with OBS version is d69ef4c3eb12f8a4324d7322d592223ad71f68ea
function racup {
	# A larger racup func was used in commit eb723d4af07bf2a72038a938525f18cd98df2699 and earlier
	mod-build raclassic
	cdgo raclassic
	commit=$(loge)
	number=$(comno)
	engine_version=$(grep "^ENGINE_VERSION" < mod.config | cut -d '"' -f 2)
	sed -i -e "25s/\".*\"/\"$commit\"/" \
		   -e "13s/\".*\"/\"$number\"/" \
		   -e "14s/\".*\"/\"$engine_version\"/" "$PK"/nixpkgs/pkgs/games/openra-raclassic/default.nix
	printf "%s\n" "You should run nix-env -f $PK/nixpkgs -iA openra-raclassic,"
	printf "%s\n" "and update the sha256 field in default.nix accordingly,"
	printf "%s\n" "then commit the changes."
	cdpk nixpkgs/pkgs/games/openra-raclassic || return
	printf "%s\n" "You are now in the $PK/nixpkgs/pkgs/games/openra-raclassic directory."
}
