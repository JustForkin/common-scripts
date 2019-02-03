function zshup {
    pkgver=$(curl -sL https://github.com/zsh-users/zsh/releases | grep "[a-z]*-.*\.tar\.gz" | head -n 1 | cut -d "/" -f 5 | cut -d '-' -f 2 | sed 's/\.tar.*//g')
    pkgpver=$(vere zsh)

    if [[ $pkgver == $pkgpver ]]; then
         printf "Seems to be up-to-date mate.\n"
    else
         sed -i -e "s/$pkgpver/$pkgver/g" $OBSH/zsh/zsh.spec
         cdobsh zsh
         osc ci -m "Bumping $pkgpver->$pkgver"
    fi
}
