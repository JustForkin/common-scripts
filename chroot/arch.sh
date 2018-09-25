function aroot {
	if ! [[ -d /arch/bin ]]; then
		sudo mount /dev/sda6 /arch
	fi
	if ! [[ -d /arch/data/Documents ]]; then
		sudo mount /dev/sdb1 /arch/data
	fi
    	genbasic /arch
}
