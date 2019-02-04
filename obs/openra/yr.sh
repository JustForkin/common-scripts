# Yuri's Revenge update
# Last latest_commit_hashit with OBS version is b76be97a97f499f1b1b716418c36f95f8483d17a
function yrup {
        cdgo yr || return
        hub pull origin master -q
        latest_engine_version=$(grep '^ENGINE\_VERSION' < mod.config | cut -d '"' -f 2) 
        packaged_engine_version=$(grep "define engine\_version" < "$OBSH"/openra-yr/openra-yr.spec | cut -d ' ' -f 3) 
        latest_commit_no=$(latest_commit_number) 
        packaged_commit_number=$(vere openra-yr) 
        latest_commit_hash=$(latest_commit_on_branch) 
        packaged_commit_hash=$(come openra-yr) 

        if [[ "$packaged_commit_number" == "$latest_commit_no" ]]
        then
                printf "e[1;32m%-0se[m\n" "OpenRA Yuri's Revenge is up-to-date\!"
        else
                sed -i -e "s/$packaged_commit_hash/$latest_commit_hash/g" \
 		       -e "s/$packaged_commit_number/$latest_commit_no/g" "$OBSH"/openra-yr/{openra-yr.spec,PKGBUILD}
                if ! [[ "$packaged_engine_version" == "$latest_engine_version" ]]
                then
                        sed -i -e "s/$packaged_engine_version/$latest_engine_version/g" "$OBSH"/openra-yr/{openra-yr.spec,PKGBUILD}
                        make clean || return
                        make || ( printf "Running make failed" && return )
                        tar czvf "$OBSH"/openra-yr/engine-"${latest_engine_version}".tar.gz engine
                        cdobsh openra-yr || return
                        osc rm engine-"${packaged_engine_version}".tar.gz
                        osc add engine-"${latest_engine_version}".tar.gz
                        cd - || return
                fi
                cdobsh openra-yr || return
                osc ci -m "Bumping $packaged_commit_number->$latest_commit_no"
        fi

	# A larger func was used before eb723d4af07bf2a72038a938525f18cd98df2699
	openra_mod_appimage_build yr
        yrnup "${1}"
}
