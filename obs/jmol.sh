function jmolup {
    pkgver=$(curl -sL https://sourceforge.net/projects/jmol/files | grep "binary.zip" | cut -d '-' -f 3 | tail -n 1)
    pkgpver=$(cat $OBSH/jmol/jmol.spec | grep "Version:" | cut -d ':' -f 2 | sed 's/\s*//g')

    if [[ $pkgver == $pkgpver ]]; then
         printf "Seems to be up-to-date mate.\n"
    else
         sed -i -e "s/$pkgpver/$pkgver/g" $OBSH/jmol/jmol.spec
         cdobsh jmol
         osc ci -m "Bumping $pkgpver->$pkgver"
    fi
}
