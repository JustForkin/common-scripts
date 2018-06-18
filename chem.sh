function opticp {
    if `echo $1 | grep png`; then
         optipng -o7 "$1"
    fi
    cp "$1" .
}

function charcp {
    find /data/Chem -name "*$(echo $PWD | cut -d '-' -f 2)*" -exec opticp '{}' \;
}
