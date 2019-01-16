for i in $HOME/Shell/common-scripts/obs/openra/nix/*.sh
do
	. "$i"
done

function update-openra-nixpkg {
	# Mods
	canup ; d2nup ; drnup ; gennup ; kkndnup ; mwnup ; ra2nup ; racnup ; rvnup ; spnup ; ssnup ; uranup ; yrnup

	# Engines
	engine_update
}
