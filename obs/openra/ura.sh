function uRAup {
    cdgo uRA || exit
    git pull origin master -q
    # OpenRA latest engine version
    enlv=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
    # OpenRA engine version in spec file
    enpv=$(grep "define engine\_version" < "$HOME"/OBS/home:fusion809/openra-ura/openra-ura.spec | cut -d ' ' -f 3)
    mastn=$(git rev-list --branches master --count)
    specn=$(grep "Version\:" < "$HOME"/OBS/home:fusion809/openra-ura/openra-ura.spec | sed 's/Version:\s*//g')
    comm=$(git log | head -n 1 | cut -d ' ' -f 2)
    specm=$(grep "define commit" < "$HOME"/OBS/home:fusion809/openra-ura/openra-ura.spec | cut -d ' ' -f 3)

    if [[ "$specn" == "$mastn" ]]; then
         printf "%s\n" "OpenRA Red Alert Unplugged mod is up to date\!"
    else
         sed -i -e "s/$specn/$mastn/g" "$HOME"/OBS/home:fusion809/openra-ura/{openra-ura.spec,PKGBUILD}
         sed -i -e "s/$specm/$comm/g" "$HOME"/OBS/home:fusion809/openra-ura/{openra-ura.spec,PKGBUILD}
         if ! [[ $enpv == $enlv ]]; then
              sed -i -e "s/$enpv/$enlv/g" "$HOME"/OBS/home:fusion809/openra-ura/{openra-ura.spec,PKGBUILD}
              make
              tar czvf "$HOME"/OBS/home:fusion809/openra-ura/engine-"${enlv}".tar.gz engine
              cdobsh openra-ura || exit
              osc rm engine-"${enpv}".tar.gz
              osc add engine-"${enlv}".tar.gz
              cd - || exit
         fi
         cdobsh openra-ura || exit
         if ! [[ $enpv == $enlv ]]; then
              osc ci -m "Bumping $specn->$mastn; engine $enpv->$enlv"
         else
              osc ci -m "Bumping $specn->$mastn; engine version is unchanged."
         fi
    fi
}

alias uraup=uRAup

