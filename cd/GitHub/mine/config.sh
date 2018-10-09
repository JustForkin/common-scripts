function cdcf {
    cdgm config/$1
}

function cdci3 {
    cdcf i3-configs/$1
}

function cdnc {
	cdcf "NixOS-configs/$1"
}
