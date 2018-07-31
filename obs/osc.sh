function oscup {
    pkgver=$(verg openSUSE osc)
    pkgpver=$(verpe osc)

    if [[ $pkgpver == $pkgver ]]; then
         printf "Seems to be up-to-date mate.\n"
    else
         sed -i -e "s/$pkgpver/$pkgver/g" $OBSH/osc/PKGBUILD
         cdobsh osc
         osc ci -m "Bumping $pkgpver->$pkgver"
    fi
}
