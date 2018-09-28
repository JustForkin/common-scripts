if ! command -v octave > /dev/null 2>&1; then
	if [[ -f /usr/bin/flatpak ]] && flatpak list | grep -i octave; then
		printf "Warning, the push function for the opendesktop-app repository will NOT work with Flatpaks...\n"
		function octave {
    flatpak run org.octave.Octave
}
    else
        printf "%s\n" "You may wish to install GNU Octave mate, as several functions defined in $HOME/Shell/common-scripts will not work without it."
	fi
fi
 
function octcli {
    if ! command -v octave-cli > /dev/null 2>&1; then
         if command -v octave > /dev/null 2>&1; then
              octave --no-gui "$@"
         fi
    else
         octave-cli "$@"
    fi
}

function octe {
    if  command -v octave; then
         octave --eval "$1" | sed "s/ans =\s*//g"
    elif [[ -f $HOME/.nix-profile/bin/octave-cli ]]; then
         octave-cli --eval "$1" | sed "s/ans =\s*//g"
    fi
} 

for i in $HOME/Shell/common-scripts/octave/*.sh
do
    . "$i"
done
