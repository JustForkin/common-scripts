if [[ -d $HOME/OBS ]]; then
    export OBS=$HOME/OBS
elif [[ -d /home/fusion809/OBS ]]; then
    export OBS=/home/fusion809/OBS
fi

export OBSH=$OBS/home:fusion809
