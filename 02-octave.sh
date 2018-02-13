function octcli {
    octave --no-gui
}

function octe {
    octave --eval $@
}

for i in $HOME/Shell/common-scripts/octave/*.sh
do
    . "$i"
done
