function yrup {
        cdgo yr || exit
        hub pull origin master -q
        enlv=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2) 
        enpv=$(grep "define engine\_version" < "$OBSH"/openra-yr/openra-yr.spec | cut -d ' ' -f 3) 
        mastn=$(comno) 
        specn=$(vere openra-yr) 
        comm=$(loge) 
        specm=$(come openra-yr) 
        if [[ "$specn" == "$mastn" ]]
        then
                printf "OpenRA Yuri's Revenge is up-to-date!\n"
        else
                sed -i -e "2s/$specn/$mastn/" "$OBSH"/openra-yr/PKGBUILD
		sed -i -e "20s/$specn/$mastn/" "$OBSH"/openra-yr/openra-yr.spec
                sed -i -e "3s/$specm/$comm/" "$OBSH"/openra-yr/PKGBUILD
		sed -i -e "21s/$specm/$comm/" "$OBSH"/openra-yr/openra-yr.spec
		ra2commit=$(git -C $GHUBO/ra2 log | head -n 1 | cut -d ' ' -f 2)
		ra2sp=$(grep "define ra2commit" < "$OBSH"/openra-yr/openra-yr.spec | cut -d ' ' -f 3)
		sed -i -e "24s/$ra2sp/$ra2commit/" "$OBSH"/openra-yr/openra-yr.spec
                if ! [[ "$enpv" == "$enlv" ]]
                then
                        sed -i -e "s/$enpv/$enlv/g" "$OBSH"/openra-yr/{openra-yr.spec,PKGBUILD}
                        make clean || exit
                        make || exit
                        tar czvf "$OBSH"/openra-yr/engine-"${enlv}".tar.gz engine
                        cdobsh openra-yr || exit
                        osc rm engine-"${enpv}".tar.gz
                        osc add engine-"${enlv}".tar.gz
                        cd - || exit
                fi
                cdobsh openra-yr || exit
		if [[ "$ra2sp" == "$ra2commit" ]]; then
                	osc ci -m "Bumping $specn->$mastn"
		else
			osc ci -m "Bumping $specn->$mastn; ra: $ra2sp->$ra2commit"
		fi
        fi
}

