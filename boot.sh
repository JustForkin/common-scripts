function newld {
	if [[ -n $3 ]]; then
		EFI="$3"
	elif [[ "$2" == "freebsd" ]]; then
		EFI=BOOTx64.efi
	else
		EFI=grubx64.efi
	fi

	sudo efibootmgr --create --disk /dev/sda --part 1 --label "$1" --loader "/EFI/$2/$EFI"
}

alias efinld=newld
alias newloader=newld

function gri {
	if [[ -d /boot/grub2 ]]; then
		sudo grub2-install --target=x86_64-efi --efi-directory=/boot/efi /dev/sda
	else
		sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi /dev/sda
	fi
}
