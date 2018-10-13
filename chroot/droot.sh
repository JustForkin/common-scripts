function droot {
    if [[ $DISTRO == "debian" ]]; then
         genbasic /deepin
    else
         genbasic /debian
    fi
}

function dproot {
    genbasic /deepin
}

function duroot {
    genbasic /debian-unstable
}
