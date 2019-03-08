function froot {
	sudo mount /dev/sda5 /fedora
	sudo mount /dev/sdb1 /fedora/data
	genbasic /fedora
}

function rroot {
	genbasic /rawhide
}

alias frroot=rroot
