function update_openra_obs_package {
    cdobsh openra || return
    latest_openra_version=$(curl -sL https://github.com/OpenRA/OpenRA/releases | grep "[a-z]*-.*\.tar\.gz" | head -n 1 | cut -d "/" -f 5 | cut -d '-' -f 2 | sed 's/\.tar.*//g')
    packaged_openra_version=$(grep "Version:" < /home/fusion809/OBS/home:fusion809/openra/openra.spec | sed 's/Version:\s*//g')
    # release_type is either playtest or release
    release_type=$(curl -sL https://github.com/OpenRA/OpenRA/releases | grep "[a-z]*-.*\.tar\.gz" | head -n 1 | cut -d '/' -f 5 | cut -d '-' -f 1)

    if ! [[ $latest_openra_version == $packaged_openra_version ]]; then
         sed -i -e "s|$packaged_openra_version|$latest_openra_version|g" \
                -e "25s/release\|playtest/$release_type/" \
                -e "92s/release\|playtest/$release_type/" \
                -e "95s/release\|playtest/$release_type/" openra.spec
         osc ci -m "Bumping to $latest_openra_version"
    fi
}
