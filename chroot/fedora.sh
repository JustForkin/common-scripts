function froot {
    printf "Warning! You are doing a Fedora chroot here mate... \nFedora uses SELinux so you should run touch /fedora/root/.autorelabel after you're finished in the chroot!\n"
    genroot /fedora
}

function rroot {
    printf "Warning! You are doing a Fedora chroot here mate... \nFedora uses SELinux so you should run touch /fedora/root/.autorelabel after you're finished in the chroot!\n"
    genroot /rawhide
}

alias frroot=rroot
