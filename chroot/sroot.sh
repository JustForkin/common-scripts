function sroot {
    function sbroot {
         if [[ -f /sabayon/bin/bash ]]; then
              if ! [[ -d /sabayon/home/fusion809/Programs ]]; then
                   sudo mount /dev/sdb1 /sabayon/home/fusion809
              fi
              genbasic /sabayon
         fi
    }

    if ! [[ -f /slackware/bin/bash ]]; then
         sudo mount /dev/sda16 /slackware
    fi

    if ! [[ -d /slackware/home/fusion809/Programs ]]; then
         sudo mount /dev/sdb1 /slackware/home/fusion809
    fi

    genbasic /slackware || sbroot || genbasic /scientific
}

function slroot {
    genbasic /scientific
}


