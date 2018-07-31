function sroot {
    function sbroot {
         if [[ -f /sabayon/bin/bash ]]; then
              if ! [[ -d /sabayon/data/Programs ]]; then
                   mount /dev/sdb1 /sabayon/data
              fi
              genroot /sabayon
         fi
    }

    if ! [[ -f /slackware/bin/bash ]]; then
         mount /dev/sda16 /slackware
    fi

    if ! [[ -d /slackware/data/Programs ]]; then
         mount /dev/sdb1 /slackware/data
    fi

    genroot /slackware || sbroot || genroot /scientific
}

function slroot {
    if grep -i scientific < /etc/os-release > /dev/null 2>&1 ; then
         genroot /scientific
    elif grep -i slackware < /etc/os-release > /dev/null 2>&1 ; then
         genroot /slackware
    fi
}


