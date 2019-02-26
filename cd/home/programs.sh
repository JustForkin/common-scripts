# Programs
function cdp {
    cd $HOME/Programs/$1
}

function cdpa {
	if [[ -d /data/Applications ]]; then
		cd /data/Applications
	else
		mkdir -p $HOME/Applications
		cd $HOME/Applications
	fi
}

alias cdAp=cdpa
alias cddap=cdpa
alias cdapi=cdpa

function cdpd {
    cdp Deb/$1
}

function cdpe {
    cdp "exe/$1"
}

function cdpj {
    cdp "jar/$1"
}

function cdpr {
    cdp rpm/$1
}

function cdpt {
	cdp targz/$1
}

alias cdpg=cdpt

function cdp2 {
	cdp tarbz2/$1
}

alias cdpz2=cdp2
alias cdpbz2=cdp2
alias cdpt2=cdp2
alias cdptz2=cdp2
alias cdptbz2=cdp2
alias cdpb2=cdp2

function cdpxz {
	cdp tarxz/$1
}

alias cdpx=cdpxz

function cdpz {
    cdp zip/$1
}

function cdpo {
	cdp "OpenRA mods"
}
