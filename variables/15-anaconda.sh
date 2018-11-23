if [[ -d $HOME/anaconda3 ]]; then
	source $HOME/anaconda3/etc/profile.d/conda.sh
	export PATH=$HOME/anaconda3/bin:$PATH
	export XDG_DATA_DIRS=$HOME/anaconda3/share:$XDG_DATA_DIRS
fi
