function openraup {
    cdobsh openra || exit
    pkgverl=$(curl -sL https://github.com/OpenRA/OpenRA/releases | grep "[a-z]*-.*\.tar\.gz" | head -n 1 | cut -d "/" -f 5 | cut -d '-' -f 2 | sed 's/\.tar.*//g')
    pkgverp=$(grep "Version:" < cat /data/OBS/home:fusion809/openra/openra.spec | sed 's/Version:\s*//g')

    if ! [[ $pkgverl == $pkgverp ]]; then
         sed -i -e "s|$pkgverp|$pkgverl|g" openra.spec
         osc ci -m "Bumping to $pkgverl"
    fi
}
