function vroot {
    if ! [[ -f /void/bin/bash ]] ; then
	sudo mount /dev/sda8 /void
	sudo mount /dev/sdb1 /void/data
    fi
    genbasic /void
}
