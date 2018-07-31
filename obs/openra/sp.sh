function spup {
    cdgo Shattered-Paradise
    splver=$(git log | head -n 1 | cut -d ' ' -f 2)
    sppver=$(cat /data/OBS/home:fusion809/openra-sp/openra-sp.spec | grep 'sp_commit' | sed 's/%define sp_commit //g')

    cd ../SP-OpenRAModSDK
    sdklver=$(git log | head -n 1 | cut -d ' ' -f 2)
    sdklc=$(git rev-list --brarnches master --count)
    sdkpver=$(cat /data/OBS/home:fusion809/openra-sp/openra-sp.spec | grep "commit" | sed 's/%define commit //g')
    sdkpc=$(cat /data/OBS/home:fusion809/openra-sp/openra-sp.spec | grep "Version:" | sed 's/Version:\s*//g')

    if [[ $sdklc == $sdkpc ]]; then
         printf "SDK is up-to-date!\n"
    else
         cdobsh openra-sp
         sed -i -e "s|$sdkpc|$sdklc|g" openra-sp.spec
         sed -i -e "s|$sdkpver|$sdklver|g" openra-sp.spec
    fi

    if [[ $splver == $sppver ]]; then
         printf "Latest Shattered Paradise commit is packaged!\n"
    else
         cdobsh openra-sp
         sed -i -e "s|$sppver|$splver|g" openra-sp.spec
    fi

    if ! [[ $sdkpver == $sdkpver ]] || ! [[ $splver == $sppver ]]; then
         cdobsh openra-sp
         osc ci -m "Bumping to SDK: $sdklc ($sdklver); SP: $splver"
    fi
}
