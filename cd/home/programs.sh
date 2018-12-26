# Programs
function cdp {
    cd $HOME/Programs/$1
}

function cdpa {
	if [[ -d /data/Applications ]]; then
		cd /data/Applications
	else; then
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

function cdpz {
    cdp zip/$1
}

function cdpo {
	cdp "OpenRA mods"
}
