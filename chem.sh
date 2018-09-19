function charcp {
    find /home/fusion809/Chem -name "*$(echo $PWD | cut -d '-' -f 2)*" -exec cp '{}' . \;
}
