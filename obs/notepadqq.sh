function notepadqqup {
    pkgver=$(wget -q https://github.com/notepadqq/notepadqq/releases -O - | grep "tar\.gz" | head -n 1 | cut -d '/' -f 5 | cut -d '"' -f 1 | sed 's/v//g' | sed 's/\.tar\.gz//g')
    pkgpver=$(vere notepadqq)

    if [[ $pkgver == $pkgpver ]]; then
         printf "Seems to be up-to-date mate.\n"
    else
         sed -i -e "s/$pkgpver/$pkgver/g" $OBSH/notepadqq/notepadqq.spec
         cdobsh notepadqq
         osc ci -m "Bumping $pkgpver->$pkgver"
    fi
}

alias nqqup=notepadqqup
