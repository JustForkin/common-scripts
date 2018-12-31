function rofiup {
    pkgver=$(wget -q https://github.com/DaveDavenport/rofi/releases -O - | grep "tar\.gz" | head -n 1 | cut -d '/' -f 6 | cut -d '"' -f 1 | sed 's/v//g' | sed 's/\.tar\.gz//g')
    pkgpver=$(vere rofi)

    if [[ $pkgver == $pkgpver ]]; then
         printf "Seems to be up-to-date mate.\n"
    else
         sed -i -e "s/$pkgpver/$pkgver/g" $OBSH/rofi/rofi.spec $PKG/fedora-copr-rofi/rofi.spec
         cdobsh rofi
         osc ci -m "Bumping $pkgpver->$pkgver"
	 cdpk fedora-copr-rofi
	 sed -i -e "s|Release:        [0-9]*|Release:        1|g" rofi.spec
	 datestamp=$(date +"%a %b %d %Y")
	 sed -i -e "s/%changelog$/%changelog\n*${datestamp} Brenton Horne <brentonhorne77@gmail.com> - $pkgver-1\n- New upstream version ${pkgver}\./g" rofi.spec
	 push "Bumping $pkgpver->$pkgver"
    fi
}

alias nqqup=rofiup
