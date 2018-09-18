function groot {
    if ! [[ -f /gentoo/bin/bash ]]; then
         sudo mount /dev/sda5 /gentoo
    fi

    genroot /gentoo
}
