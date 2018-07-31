function obsvup {
    cdobsh obs-service-source_validator
    pkgverf=$(curl -sL http://download.opensuse.org/source/tumbleweed/repo/oss/src | grep "obs-service-source_validator" | cut -d '"' -f 4 | cut -d '_' -f 2 | sed 's/validator-//g' | sed 's/\.src\.rpm*//g')
    pkgverl=$(echo $pkgverf | cut -d '-' -f 1)
    _pkgverl=$(echo $pkgverf | cut -d '-' -f 2)
    pkgverp=$(cat PKGBUILD | grep "^pkgver=" | cut -d '=' -f 2)
    _pkgverp=$(cat PKGBUILD | grep "^_pkgrel=" | cut -d '=' -f 2)

    if ! [[ $pkgverl == $pkgverp ]] || ! [[ $_pkgverl == $_pkgverp ]] ; then
         sed -i -e "s|$pkgverp|$pkgverl|g" \
                -e "s|^_pkgrel=${_pkgverp}|^_pkgrel=${_pkgverl}|g" PKGBUILD

         osc ci -m "Bumping to $pkgverf"
    fi
}
