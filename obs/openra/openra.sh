function openraup {
    cdobsh openra || return
    pkgverl=$(curl -sL https://github.com/OpenRA/OpenRA/releases | grep "[a-z]*-.*\.tar\.gz" | head -n 1 | cut -d "/" -f 5 | cut -d '-' -f 2 | sed 's/\.tar.*//g')
    pkgverp=$(grep "Version:" < /home/fusion809/OBS/home:fusion809/openra/openra.spec | sed 's/Version:\s*//g')
    type=$(curl -sL https://github.com/OpenRA/OpenRA/releases | grep "[a-z]*-.*\.tar\.gz" | head -n 1 | cut -d '/' -f 5 | cut -d '-' -f 1)

    if ! [[ $pkgverl == $pkgverp ]]; then
         sed -i -e "s|$pkgverp|$pkgverl|g" \
                -e "25s/release\|playtest/$type/" \
                -e "92s/release\|playtest/$type/" \
                -e "95s/release\|playtest/$type/" openra.spec
         osc ci -m "Bumping to $pkgverl"
    fi
}
