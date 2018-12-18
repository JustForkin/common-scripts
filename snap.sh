function snapi {
	sudo snap install "$@"
}

alias ssi=snapi

function snapr {
	sudo snap remove "$@"
}

alias ssr=snapr

function snapl {
	sudo snap list "$@"
}

alias ssl=snapl

function snaps {
	sudo snap find "$@"
}

alias ssf=snaps
