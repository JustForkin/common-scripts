function pullob {
	git pull origin "$(git-branch)"
}

function gitup {
    cdgo
    for i in *
    do
         pushd $i || exit
         git stash -q
         git pull --all -q
         popd || exit
    done
}

function pullpush {
	pullop
	pushop
}

alias pull-push=pullpush
alias pullsh=pullpush
