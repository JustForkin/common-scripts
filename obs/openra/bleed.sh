function openrabup {
    cdgo OpenRA
    git checkout bleed -q
    git pull origin bleed -q
    mastn=$(comno)
    specn=$(vere openra-bleed)
    comm=$(loge)
    specm=$(come openra-bleed)

    if [[ $specn == $mastn ]]; then
         printf "%s\n" "OpenRA Bleed is up to date!"
    else
         printf "%s\n" "Updating OBS repo openra-bleed from $specn, $specm to $mastn, $comm."
         sed -i -e "s/$specn/$mastn/g" "$OBSH"/openra-bleed/{openra-bleed.spec,PKGBUILD}
         sed -i -e "s/$specm/$comm/g" "$OBSH"/openra-bleed/{openra-bleed.spec,PKGBUILD}
         cdobsh openra-bleed
         osc ci -m "Bumping $specn->$mastn"
         /usr/local/bin/openra-build-cli
    fi
}
