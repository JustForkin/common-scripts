function jmolup {
if `which curl > /dev/null 2>&1`; then
    MAJOR=$(curl -sL https://sourceforge.net/projects/jmol/files/Jmol/ | grep "Version%20[0-9]" | head -n 1 | cut -d '/' -f 6 | sed 's/Version%20//g')
    pkgver=$(wget -cqO- "https://sourceforge.net/projects/jmol/files/Jmol/Version%20${MAJOR}" | grep "Jmol%20${MAJOR}" | head -n 1 | cut -d '/' -f 7 | sed 's/Jmol%20//g')
elif `which wget > /dev/null 2>&1`; then
    MAJOR=$(wget -cqO- https://sourceforge.net/projects/jmol/files/Jmol/ | | grep "Version%20[0-9]" | head -n 1 | cut -d '/' -f 6 | sed 's/Version%20//g')
    pkgver=$(wget -cqO- "https://sourceforge.net/projects/jmol/files/Jmol/Version%20${MAJOR}" | grep "Jmol%20${MAJOR}" | head -  n 1 | cut -d '/' -f 7 | sed 's/Jmol%20//g')
else
    printf "Neither cURL nor wget have been detected, please install them or, if already installed, add them to the system PATH.\n"
fi
    pkgpver=$(vere jmol)

    if [[ $pkgver == $pkgpver ]]; then
         printf "Seems to be up-to-date mate.\n"
    else
         sed -i -e "s/$pkgpver/$pkgver/g" $OBSH/jmol/jmol.spec
         sed -i -e "s/$pkgpver/$pkgver/g" $OBSH/jmol/_service
         sed -i -e "s/${pkgpver%.*}/${pkgver%.*}/g" $OBSH/jmol/_service
         cdobsh jmol
         osc ci -m "Bumping $pkgpver->$pkgver"
    fi
}
