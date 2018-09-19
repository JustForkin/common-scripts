function genbasic {
	sudo mount -t proc /proc $1/proc
	sudo mount --rbind /dev $1/dev
	sudo mount --make-rslave $1/dev
	sudo mount --rbind /sys $1/sys
	sudo mount --make-rslave $1/sys
	sudo cp -L /etc/resolv.conf $1/etc
	sudo chroot $1 /bin/zsh
}
