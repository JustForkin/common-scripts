function froot {
	sudo mount /dev/mapper/fedora-root /fedora
	genbasic /fedora
}

function rroot {
	genbasic /rawhide
}

alias frroot=rroot
