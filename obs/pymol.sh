function pymolup {
    cdobsh pymol
    pkgver=$(wget -cqO - https://pymol.org/2/ | grep "tar." | grep "Linux" | cut -d '-' -f 2 | cut -d '_' -f 1)
    pkgpver=$(cat pymol.spec | grep "Version:" | cut -d ':' -f 2 | sed 's/\s*//g' | sed 's/\.svn[0-9]*//g')

    if [[ $pkgver == $pkgpver ]]; then
         printf "PyMOL is up-to-date.\n"
    else
         sed -i -e "s|$pkgpver|$pkgver|g" pymol.spec
         osc ci -m "Bumping to $pkgver"
    fi
}
