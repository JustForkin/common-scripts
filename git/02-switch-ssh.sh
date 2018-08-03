# Switch to SSH
function gitsw {
  # repo is the name of the repository
  repo=$(git remote -v | grep origin | sed 's/.*\///g' | sed 's/.git.*//g' | sed 's/ (fetch)//g' | head -n 1)
  git remote rm origin

  if [[ -n "$1" ]]; then
      git remote add origin git@github.com:fusion809/"${1}".git
  else
      git remote add origin git@github.com:fusion809/"${repo}".git
  fi
}

alias SSH=gitsw
alias gitssh=gitsw
alias gits=gitsw

function gtsa {
	for i in $GHUBM/*/*
	do
		pushd $i || exit
		gitsw
		popd || exit
	done
}
