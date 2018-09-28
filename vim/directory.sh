function gvd {
    pushd $1 || exit
    gvim
    popd || exit
}

function vd {
    pushd $1 || exit
    vim
    popd || exit
}
