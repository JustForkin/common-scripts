for i in "`dirname \"$0\"`"/nix/*.sh
do
	. "$i"
done

function update_openra_nixpkg {
	# Mods
	canup ; d2nup ; drnup ; gennup ; kkndnup ; mwnup ; ra2nup ; racnup ; rvnup ; spnup ; ssnup ; uranup ; yrnup

	# Engines
	engine_update
}
