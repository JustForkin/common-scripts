function pymolup {
    cdobsh pymol
    pkgver=$(curl -sL http://sourceforge.net/projects/pymol | grep "\.tar\.bz2" | cut -d '"' -f 4 | cut -d ' ' -f 2 | sed 's/pymol\-v//g' | sed 's/\.tar\.bz2//g')
    pkgpver=$(cat pymol.spec | grep "Version:" | cut -d ':' -f 2 | sed 's/\s*//g' | sed 's/\.svn[0-9]*//g')

    if [[ $pkgver == $pkgpver ]]; then
         printf "PyMOL is up-to-date.\n"
    else
         sed -i -e "s|$pkgpver|$pkgver|g" pymol.spec
         osc ci -m "Bumping to $pkgver"
    fi
}
