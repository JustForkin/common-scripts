function genbasic {
	if [[ -f /proc/config.gz ]]; then
		if ! [[ -f $1/proc/config.gz ]]; then
			sudo mount -t proc /proc $1/proc
		fi
	elif [[ -f /proc/cgroups ]]; then
		if ! [[ -f $1/proc/cgroups ]]; then
			sudo mount -t proc /proc $1/proc
		fi
	elif [[ -f /proc/devices ]]; then
		if ! [[ -f $1/proc/devices ]]; then
			sudo mount -t proc /proc $1/proc
		fi
	fi
	if ! [[ -e $1/dev/sda ]];then 
		sudo mount --rbind /dev $1/dev
		sudo mount --make-rslave $1/dev
	fi
	if ! [[ -d $1/sys/kernel ]]; then
		sudo mount --rbind /sys $1/sys
		sudo mount --make-rslave $1/sys
	fi
	if ! [[ -f $1/etc/resolv.conf ]]; then	
		sudo cp -L /etc/resolv.conf $1/etc
	fi
	if ! [[ -d $1/data/Documents ]]; then
		sudo mount /dev/sdb1 $1/data
	fi
	if [[ -f $1/usr/local/bin/su-fusion809 ]] ; then
		shell="/usr/local/bin/su-fusion809"
	elif [[ -f $1/bin/zsh ]]; then
		shell="/bin/zsh"
	elif [[ -f $1/usr/bin/zsh ]]; then
		shell="/usr/bin/zsh"
	elif [[ -f $1/bin/bash ]]; then
		shell="/bin/bash"
	elif [[ -f $1/usr/bin/bash ]]; then
		shell="/usr/bin/bash"
	elif [[ -f $1/bin/sh ]]; then
		shell="/bin/sh"
	elif [[ -f $1/usr/bin/sh ]]; then
		shell="/usr/bin/sh"
	fi
	sudo chroot $1 $shell
}
