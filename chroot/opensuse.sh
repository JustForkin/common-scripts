function otroot {
    # Determine root partition of Leap
    root=$(ls -ld /dev/disk/by-label/* | grep -i tumbleweed | cut -d '/' -f 7)
    printf "Chrootin' into openSUSE Tumbleweed on /dev/$root.\n"

    if ! cat /etc/mtab | grep -i tumbleweed > /dev/null 2>&1 ; then
         if [[ -d /tumbleweed ]]; then
              sudo mount /dev/$root /tumbleweed
              genbasic /tumbleweed
         elif [[ -d /opensuse-tumbleweed ]]; then
              sudo mount /dev/$root /opensuse-tumbleweed
              genbasic /opensuse-tumbleweed
         elif [[ -d /ot ]]; then
              sudo mount /dev/$root /ot
              genbasic /ot
         elif [[ -d /opensuse && ! -d /opensuse/bin ]]; then
              sudo mount /dev/$root /opensuse
              genbasic /opensuse
         else
              printf "Suitable mount point not found, so making /tumbleweed directory.\n"
              sudo mkdir /tumbleweed
              sudo mount /dev/$root /tumbleweed
              genbasic /tumbleweed
         fi
    else
         genbasic $(cat /etc/mtab | grep tumbleweed | head -n 1 | cut -d ' ' -f 2)
    fi
}

function olroot {
    # Determine root partition of Leap
    root=$(ls -ld /dev/disk/by-label/* | grep -i leap | cut -d '/' -f 7)
    printf "Chrootin' into openSUSE Leap on /dev/$root.\n"

    if ! cat /etc/mtab | grep -i leap > /dev/null 2>&1 ; then
         if [[ -d /leap ]]; then
              sudo mount /dev/$root /leap
              genbasic /leap
         elif [[ -d /opensuse-leap ]]; then
              sudo mount /dev/$root /opensuse-leap
              genbasic /opensuse-leap
         elif [[ -d /ol ]]; then
              sudo mount /dev/$root /ol
              genbasic /ol
         elif [[ -d /opensuse && ! -d /opensuse/bin ]]; then
              sudo mount /dev/$root /opensuse
              genbasic /opensuse
         else
              printf "Suitable mount point not found, so making /leap directory.\n"
              sudo mkdir /leap
              sudo mount /dev/$root /leap
              genbasic /leap
         fi
    else
         genbasic $(cat /etc/mtab | grep leap | head -n 1 | cut -d ' ' -f 2)
    fi
}

if ls -ld /dev/disk/by-label/* | grep -i tumbleweed > /dev/null 2>&1 ; then
    alias oroot=otroot
else
    alias oroot=olroot
fi
