function croot {
	BOOT_PART=$(ls -ld /dev/disk/by-label/* | grep CentOS_Boot | cut -d ' ' -f 11 | cut -d '/' -f 3)
	PART=$(ls -ld /dev/mapper/* | cut -d '/' -f 4 | cut -d ' ' -f 1 | grep -i centos)
	if ! [[ -d /centos ]]; then
		mkdir -p /centos
	fi
	sudo mount /dev/mapper/$PART /centos
	sudo mount /dev/$BOOT_PART /centos/boot
	genroot /centos
}
