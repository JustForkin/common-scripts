function mwup {
    cd $HOME/GitHub/others/Medieval-Warfare
    git pull origin Next -q
    # OpenRA latest engine version
    enlv=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2)
    # OpenRA engine version in spec file
    enpv=$(grep "define engine\_version" < $HOME/OBS/home:fusion809/openra-mw/openra-mw.spec | cut -d ' ' -f 3)
    mastn=$(git rev-list --branches Next --count)
    specn=$(cat $HOME/OBS/home:fusion809/openra-mw/openra-mw.spec | grep "Version\:" | sed 's/Version:\s*//g')
    comm=$(git log | head -n 1 | cut -d ' ' -f 2)
    specm=$(cat $HOME/OBS/home:fusion809/openra-mw/openra-mw.spec | grep "define commit" | cut -d ' ' -f 3)

    if [[ $specn == $mastn ]]; then
         printf "OpenRA Medieval Warfare mod is up to date\!\n"
    else
         sed -i -e "s/$specn/$mastn/g" $HOME/OBS/home:fusion809/openra-mw/{openra-mw.spec,PKGBUILD}
         sed -i -e "s/$specm/$comm/g" $HOME/OBS/home:fusion809/openra-mw/{openra-mw.spec,PKGBUILD}
         if ! [[ $enpv == $enlv ]]; then
              sed -i -e "s/$enpv/$enlv/g" $HOME/OBS/home:fusion809/openra-mw/{openra-mw.spec,PKGBUILD}
              make
              tar czvf $HOME/OBS/home:fusion809/openra-mw/engine-${enlv}.tar.gz engine
              cdobsh openra-mw
              osc rm engine-${enpv}.tar.gz
              osc add engine-${enlv}.tar.gz
              cd -
         fi
         cd $HOME/OBS/home:fusion809/openra-mw
         if ! [[ $enpv == $enlv ]]; then
              osc ci -m "Bumping $specn->$mastn; engine $enpv->$enlv"
         else
              osc ci -m "Bumping $specn->$mastn; engine version is unchanged."
         fi
    fi
}
