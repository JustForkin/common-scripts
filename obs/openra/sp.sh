function spup {
    cdgo Shattered-Paradise || exit
    splver=$(git log | head -n 1 | cut -d ' ' -f 2)
    sppver=$(grep 'sp_commit' < /data/OBS/home:fusion809/openra-sp/openra-sp.spec | sed 's/%define sp_commit //g')

    cd ../SP-OpenRAModSDK || exit
    sdklver=$(git log | head -n 1 | cut -d ' ' -f 2)
    sdklc=$(git rev-list --brarnches master --count)
    sdkpver=$(grep "commit" < cat /data/OBS/home:fusion809/openra-sp/openra-sp.spec | sed 's/%define commit //g')
    sdkpc=$(grep "Version:" < /data/OBS/home:fusion809/openra-sp/openra-sp.spec | sed 's/Version:\s*//g')

    # If OpenRAModSDK is outdated sed update it
    if [[ "$sdklc" == "$sdkpc" ]]; then
         printf "%s\n" "SDK is up-to-date!"
    else
         cdobsh openra-sp || exit
         sed -i -e "s|$sdkpc|$sdklc|g" openra-sp.spec
         sed -i -e "s|$sdkpver|$sdklver|g" openra-sp.spec
    fi

    # If Shattered Paradise is outdated sed update it
    if [[ "$splver" == "$sppver" ]]; then
         printf "%s\n" "Latest Shattered Paradise commit is packaged!"
    else
         cdobsh openra-sp || exit
         sed -i -e "s|$sppver|$splver|g" openra-sp.spec
    fi

    # If OpenRAModSDK or Shattered Paradise repo is outdated commit updtae to repo
    if ! [[ "$sdkpver" == "$sdkpver" ]] || ! [[ "$splver" == "$sppver" ]]; then
         cdobsh openra-sp || exit
         osc ci -m "Bumping to SDK: $sdklc ($sdklver); SP: $splver"
    fi
}
