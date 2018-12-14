function vcl {
	if ls | grep "hange" > /dev/null 2>&1; then
		vim ./*hange*
	else
		printf "No *hang* file is found.\n"
	fi
}

alias vch=vcl
alias vchl=vcl
alias vcg=vcl

function vnix {
	if [[ -f common.nix ]]; then
		vim common.nix
	elif [[ -f default.nix ]]; then
		vim default.nix
	elif ls * | grep "\.nix" > /dev/null 2&>1 ; then
		vim *.nix
	elif [[ -n "$1" ]]; then
		vim "$1".nix
	else
		vim default.nix
	fi
}

alias vnx=vnix

function vds {
	vim *.dsc
}

alias vdsc=vds
alias vsc=vds

function vrl {
	vim *rules
}

function ved {
	vim "${PWD/*\//}-*.ebuild"
}

function vsl {
	vim "$HOME/SlackBuilds"
}

function vsp {
	specl=$(ls *\.spec)
	specln=$(echo $specl | wc -l)
	if [[ $specln > 1 ]] && [[ -f $(basename $PWD).spec ]]; then
		vim "$(basename $PWD).spec"
	elif [[ $specl > 1 ]]; then
		vim "$(echo $specl | head -n 1)" 
	elif [[ $specl == 1 ]]; then
		vim *.spec
	else
		vim "$(basename $PWD).spec"
	fi
}

function vyl {
	if ls .*.yml > /dev/null 2>&1; then
		 vim .*.yml
	elif ls *.yml > /dev/null 2>&1; then
		 vim *.yml
	fi
}

alias vyml=vyl

function vtyl {
	vim .travis.yml
}

function vdsk {
	vim *.desktop
}

alias vdk=vdsk

function vtp {
	vim template
}
