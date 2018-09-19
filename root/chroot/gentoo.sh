function groot {
    if ! [[ -f /gentoo/bin/bash ]]; then
         mount /dev/sda4 /gentoo
    fi

    if ! [[ -d /gentoo/home/fusion809/Programs ]]; then
         mount /dev/sdb1 /gentoo/home/fusion809
    fi
    
    genroot /gentoo
}
