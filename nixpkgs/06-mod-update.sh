# If you add anything to this, you must also add it to 01-nixpkgs-update.sh
function canup {
	update_openra_mod_nixpkg "$GHUBO/CAmod" "10" "17" "20" "26" "${1}"
}

function d2nup {
	update_openra_mod_nixpkg "$GHUBO/d2" "34" "41" "45" "51" "${1}"
}

function drnup {
	update_openra_mod_nixpkg "$GHUBO/DarkReign" "63" "70" "73" "79" "${1}"
}

function gennup {
	update_openra_mod_nixpkg "$GHUBO/Generals-Alpha" "87" "94" "98" "103" "${1}"
}

function kkndnup {
	update_openra_mod_nixpkg "$GHUBO/KKnD" "111" "118" "121" "127" "${1}"
}

function mwnup {
	update_openra_mod_nixpkg "$GHUBO/Medieval-Warfare" "135" "142" "145" "151" "${1}"
}

function ra2nup {
	update_openra_mod_nixpkg "$GHUBO/ra2" "159" "166" "170" "175" "${1}"
}

function racnup {
	update_openra_mod_nixpkg "$GHUBO/raclassic" "8" "187" "194" "198" "203" "${1}"
}

function rvnup {
	update_openra_mod_nixpkg "$GHUBO/Romanovs-Vengeance" "211" "218" "221" "228" "${1}"
}

function spnup {
	update_openra_mod_nixpkg "$GHUBO/SP-OpenRAModSDK" "240" "247" "250" "257" "${1}"
}

function ssnup {
	update_openra_mod_nixpkg "$GHUBO/sole-survivor" "265" "272" "275" "281" "${1}"
}

function uranup {
	update_openra_mod_nixpkg "$GHUBO/uRA" "289" "296" "300" "305" "${1}"
}

function yrnup {
	update_openra_mod_nixpkg "$GHUBO/yr" "313" "320" "324" "329" "${1}"
}