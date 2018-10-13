function lroot {
    if [[ -d /linuxmint ]]; then
         genbasic /linuxmint
    elif [[ -d /mint ]]; then
         genbasic /mint
    fi
}
