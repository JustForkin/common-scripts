function cdd {
    cd $HOME/Documents/$1
}

alias cddc=cdd

function cdcfe {
    cdd "CodeLite/CPP-Math-Projects/$1"
}

function cddman {
    cdd "Manpages/$1"
}

function cdtx {
	if [[ -d $HOME/Documents/"Text-files" ]]; then
		cdd "Text-files/$1"
	elif [[ -d $HOME/Documents/"Text files" ]]; then
		cdd "Text files/$1"
	else
		mkdir -p "$HOME/Documents/Text-files"
		cdd "Text-filese/$1"
	fi
}

function cdmd {
	cdd "Markdown/$1"
}
