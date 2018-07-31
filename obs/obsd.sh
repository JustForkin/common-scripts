function obsfup {
    cdobsh obs-service-download_files
    pkgverl=$(curl -sL https://github.com/openSUSE/obs-service-download_files/releases | grep "\.tar\.gz" | head -n 1 | cut -d '"' -f 2 | cut -d '/' -f 5 | sed 's/\.tar\.gz//g')
    pkgverp=$(cat PKGBUILD | grep "^pkgver=" | cut -d '=' -f 2)
    sed -i -e "s|$pkgverp|$pkgverl|g" PKGBUILD
    osc ci -m "Bumping to $pkgverl"
}
