function groot {
    if ! [[ -f /gentoo/bin/bash ]]; then
#         sudo mount /dev/sda5 /gentoo
    fi
	if ! [[ -f /gentoo/data/Documents ]]; then
	sudo mount /dev/sdb1 /data/gentoo/data
	fi

    genbasic /data/gentoo
}
