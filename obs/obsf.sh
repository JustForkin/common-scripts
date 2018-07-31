function obsfup {
    cdobsh obs-service-format_spec_file
    pkgverf=$(curl -sL http://download.opensuse.org/source/tumbleweed/repo/oss/src | grep "obs-service-format_spec_file" | cut -d '"' -f 4 | cut -d '_' -f 3 | sed 's/file-//g' | sed 's/\.src\.rpm*//g')
    pkgverl=$(echo $pkgverf | cut -d '-' -f 1)
    _pkgverl=$(echo $pkgverf | cut -d '-' -f 2)
    pkgverp=$(cat PKGBUILD | grep "^pkgver=" | cut -d '=' -f 2)
    _pkgverp=$(cat PKGBUILD | grep "^_pkgver=" | cut -d '=' -f 2)

    sed -i -e "s|$pkgverp|$pkgverl|g" \
           -e "s|${_pkgverp}|${_pkgverl}|g" PKGBUILD

    osc ci -m "Bumping to $pkgverf"
}
