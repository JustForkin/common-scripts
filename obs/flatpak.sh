function flatpkup {
    pkgver=$(wget -cqO- https://github.com/flatpak/flatpak/releases | grep "tar\.gz" | cut -d '/' -f 5 | cut -d '"' -f 1 | sed 's/\.tar\.gz//g' | head -n 1)
    pkgpver=$(cat $OBSH/flatpak/flatpak.spec | grep "Version:" | cut -d ':' -f 2 | sed 's/\s*//g')

    if [[ $pkgver == $pkgpver ]]; then
         printf "Seems to be up-to-date mate.\n"
    else
         sed -i -e "s/$pkgpver/$pkgver/g" $OBSH/flatpak/flatpak.spec
         cdobsh flatpak
         osc ci -m "Bumping $pkgpver->$pkgver"
    fi
} 
