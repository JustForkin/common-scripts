# Combined Arms update
# Last commit with OBS version is b76be97a97f499f1b1b716418c36f95f8483d17a
function caup {
	# An expanded caup func was used in commit eb723d4af07bf2a72038a938525f18cd98df2699 and earlier
	mod-build CAmod
	commit=$(loge)
	number=$(comno)
	engine_version=$(grep "^ENGINE_VERSION" < mod.config | cut -d '"' -f 2)
	sed -i -e "25s/\".*\"/\"$commit\"/" \
		   -e "13s/\".*\"/\"$number\"/" \
		   -e "14s/\".*\"/\"$engine_version\"/" "$PK"/nixpkgs/pkgs/games/openra-ca/default.nix
	printf "%s\n" "You should run nix-env -f $PK/nixpkgs -iA openra-ca,"
	printf "%s\n" "and update the sha256 field in default.nix accordingly,"
	printf "%s\n" "then commit the changes."
	cdpk nixpkgs/pkgs/games/openra-ca || return
	printf "%s\n" "You are now in the $PK/nixpkgs/pkgs/games/openra-ca directory."
}

