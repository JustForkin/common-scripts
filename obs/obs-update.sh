function obsdup {
    if ! `ls /tmp | grep src > /dev/null 2>&1`; then
         curl -sL http://download.opensuse.org/source/tumbleweed/repo/oss/src &> /tmp/src-$(date | sed 's/ /_/g' | sed 's/:[0-9]*_/_/g').html
    fi

    pkgver=$(curl -sL https://github.com/openSUSE/obs-service-download_files/releases | grep "\.tar\.gz" | head -n 1 | cut -d '"' -f 2 | cut -d '/' -f 5 | sed 's/\.tar\.gz//g')
    pkgpver=$(sed -n 's/pkgver=//p' $OBSH/obs-service-download_files/PKGBUILD)

    if [[ $pkgpver == $pkgver ]]; then
         printf "Seems to be up-to-date mate.\n"
    else
         sed -i -e "s/$pkgpver/$pkgver/g" $OBSH/obs-service-download_files/PKGBUILD
         cdobsh obs-service-download_files
         osc ci -m "Bumping $pkgpver->$pkgver"
    fi
}

function oscup {
    pkgver=$(curl -sL https://github.com/openSUSE/osc/releases | grep "\.tar\.gz" | head -n 1 | cut -d '"' -f 2 | cut -d '/' -f 5 | sed 's/\.tar\.gz//g')
    pkgpver=$(sed -n 's/pkgver=//p' $OBSH/osc/PKGBUILD)

    if [[ $pkgpver == $pkgver ]]; then
         printf "Seems to be up-to-date mate.\n"
    else
         sed -i -e "s/$pkgpver/$pkgver/g" $OBSH/osc/PKGBUILD
         cdobsh osc
         osc ci -m "Bumping $pkgpver->$pkgver"
    fi
} 

