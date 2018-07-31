function yrup {
        cdgo yr || exit
        hub pull origin master -q
        enlv=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2) 
        enpv=$(grep "define engine\_version" < "$HOME"/OBS/home:fusion809/openra-yr/openra-yr.spec | cut -d ' ' -f 3) 
        mastn=$(comno) 
        specn=$(vere openra-yr) 
        comm=$(loge) 
        specm=$(come openra-yr) 
        if [[ "$specn" == "$mastn" ]]
        then
                printf "OpenRA Yuri's Revenge is up to date!\n"
        else
                sed -i -e "s/$specn/$mastn/g" "$OBSH"/openra-yr/{openra-yr.spec,PKGBUILD}
                sed -i -e "s/$specm/$comm/g" "$OBSH"/openra-yr/{openra-yr.spec,PKGBUILD}
                if ! [[ "$enpv" == "$enlv" ]]
                then
                        sed -i -e "s/$enpv/$enlv/g" "$HOME"/OBS/home:fusion809/openra-yr/{openra-yr.spec,PKGBUILD}
                        make clean
                        make
                        tar czvf "$HOME"/OBS/home:fusion809/openra-yr/engine-"${enlv}".tar.gz engine
                        cdobsh openra-yr || exit
                        osc rm engine-"${enpv}".tar.gz
                        osc add engine-"${enlv}".tar.gz
                        cd - || exit
                fi
                cdobsh openra-yr || exit
                osc ci -m "Bumping $specn->$mastn"
        fi
}

