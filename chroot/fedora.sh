function froot {
	sudo mount /dev/mapper/fedora-root /fedora
	sudo mount /dev/sda10 /fedora/boot
	genbasic /fedora
}

function rroot {
	genbasic /rawhide
}

alias frroot=rroot
