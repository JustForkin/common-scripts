function gvd {
    pushd $1 || return
    gvim
    popd || return
}

function vd {
    pushd $1 || return
    vim
    popd || return
}
