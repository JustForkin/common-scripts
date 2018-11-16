# Julia
if ! command -v julia > /dev/null 2>&1 ; then
	export PATH=$HOME/Programs/targz/julia-1.0.2/bin:$PATH
	export XDG_DATA_DIRS=$HOME/Programs/targz/julia-1.0.2/share:$XDG_DATA_DIRS
fi
