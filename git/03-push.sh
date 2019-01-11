function git-branch {
	if ! [[ -n "$1" ]]; then
		git rev-parse --abbrev-ref HEAD
	else
		git -C "$1" rev-parse --abbrev-ref HEAD
	fi
}

function comno {
	if ! [[ -n "$1" ]]; then
		git rev-list --branches "$(git-branch)" --count
	else
		git -C "$1" rev-list --branches "$(git-branch "$1")" --count
	fi
}

function pushop {
	if [[ -n "$1" ]]; then
		git push origin "$(git-branch)" "$1"
	else
		git push origin "$(git-branch)"
	fi
}

## Minimal version
function pushm {
	git add --all										# Add all files to git
	git commit -m "$1"								   # Commit with message = argument 1
	pushop										 # Push to the current branch
}

function pushme {
	git add --all
	git commit --edit
	pushop "$1"
}

function pushmf {
	git add --all
	git commit -m "$1"
	git push origin $(git-branch) -f
}

function pusht {
	git add --all
	git commit -m "$1"
	if [[ -n $2 ]]; then
		 git tag "$2"
		 git push origin "$2"
	else
		 git tag "$(comno)"
		 git push origin "$(comno)"
	fi
	git push origin "$(git-branch)"
}

## Update common-scripts
function cssubup {
	if [[ "$1" = common ]] && ! echo ""$PWD"" | grep "$SCR/common-scripts" > /dev/null 2>&1 && [[ -d "$SCR/$1-scripts" ]] ; then
		 printf "%s\n" "Updating common-scripts repository."
		 pushd "$SCR/$1-scripts" || return
	elif ! [[ "$1" == common ]]; then
		 pushd "$SCR/$1-scripts"/Shell/common-scripts || return
	fi

	git pull origin master

	if ! [[ $1 = common ]]; then
		 pushd .. || return
		 pushm "Updating common-scripts submodule"
		 popd || return
	fi

	popd || return
}

function update-common {
	printf "Updating common-scripts submodules and main repo.\n"
	cssubup arch
	cssubup centos
	cssubup common
	cssubup debian
	cssubup fedora
	cssubup gentoo
	cssubup mageia
	cssubup nixos
	cssubup opensuse
	cssubup pclinuxos
	cssubup pisi
	cssubup sabayon
	cssubup slackware
	cssubup solus
	cssubup void
}

# Complete push	
function push {
	if git log > /dev/null 2>&1; then
		if printf "$PWD" | grep 'AUR' > /dev/null 2>&1 ; then
			 mksrcinfo
		fi

		if echo "$PWD" | grep opendesktop > /dev/null 2>&1 ; then
			 commc=$(git rev-list --branches master --count)
			 commn=$(octe "$commc+1")
			 sed -i -e "s/PKGVER=[0-9]*/PKGVER=${commn}/g" "$PK"/opendesktop-app/pkg/appimage/appimagebuild
			 pushm "$1"
		else
			 pushm "$1"
		fi
	
		if echo "$PWD" | grep "$HOME/Shell" > /dev/null 2>&1 ; then
			 szsh
		elif echo "$PWD" | grep "$FS" > /dev/null 2>&1 && grep -i Fedora < /etc/os-release > /dev/null 2>&1 ; then
			 szsh
		elif echo "$PWD" | grep "$ARS" > /dev/null 2>&1 && grep -i Arch < /etc/os-release  > /dev/null 2>&1 ; then
			 szsh
		elif echo "$PWD" | grep "$GS" > /dev/null 2>&1 && grep -i Gentoo < /etc/os-release > /dev/null 2>&1; then
			 szsh
		elif echo "$PWD" | grep "$DS" > /dev/null 2>&1 && grep -i "Debian\|Ubuntu" < /etc/os-release > /dev/null 2>&1; then
			 szsh
		elif echo "$PWD" | grep "$VS" > /dev/null 2>&1 && grep -i Void < /etc/os-release > /dev/null 2>&1; then
			 szsh
		elif echo "$PWD" | grep "$OSS" > /dev/null 2>&1 && grep -i openSUSE < /etc/os-release > /dev/null 2>&1; then
			 szsh
		elif echo "$PWD" | grep "$NS" > /dev/null 2>&1 && grep -i NixOS < /etc/os-release > /dev/null 2>&1; then
			 szsh
		elif echo "$PWD" | grep "$PLS" > /dev/null 2>&1 && grep -i PCLinuxOS < /etc/os-release > /dev/null 2>&1; then
			 szsh
		elif echo "$PWD" | grep "$CS" > /dev/null 2>&1 && grep -i CentOS < /etc/os-release > /dev/null 2>&1; then
			 szsh
		fi

		# Update common-scripts dirs
		if echo "$PWD" | grep "$HOME/Shell/common-scripts" > /dev/null 2>&1; then
			 if ! echo "$SHELL" | grep zsh > /dev/null 2>&1; then
				  read -p "Do you want to update common-scripts submodules and the main common-scripts repo (if not already up-to-date) now? [y/n] " yn
			 else
				  read "yn?Do you want to update common-scripts submodules and the main common-scripts repo (if not already up-to-date) now? [y/n] "
			 fi
	
			 case $yn in
				  [Yy]* ) update-common;;
				  [Nn]* ) printf "%s\n" "OK, it's your funeral. Run update-common if you change your mind." ;; 
				  * ) printf "%s\n" "Please answer y or n." ; ...
			 esac
		fi
	elif [[ -d .osc ]]; then
		osc ci -m "$@"
	fi
}

# Complete push, but with potentially more detailed commit message
function pushe {
	if printf "$PWD" | grep 'AUR' > /dev/null 2>&1 ; then
		 mksrcinfo
	fi

	if echo "$PWD" | grep opendesktop > /dev/null 2>&1 ; then
		 commc=$(git rev-list --branches master --count)
		 commn=$(octe "$commc+1")
		 sed -i -e "s/PKGVER=[0-9]*/PKGVER=${commn}/g" "$PK"/opendesktop-app/pkg/appimage/appimagebuild
		 pushme "$1"
	elif echo "$PWD" | grep OpenRA > /dev/null 2>&1 ; then
		 commc=$(git rev-list --branches bleed --count)
		 commn=$(octe "$commc+1")
		 sed -i -e "s/COMNO=[0-9]*/COMNO=${commn}/g" "$PK"/OpenRA/packaging/linux/buildpackage.sh
		 pushme "$1"
	else
		 pushme "$1"
	fi

	if echo "$PWD" | grep "$HOME/Shell" > /dev/null 2>&1 ; then
		 szsh
	elif echo "$PWD" | grep "$FS" > /dev/null 2>&1 && grep -i Fedora < /etc/os-release > /dev/null 2>&1 ; then
		 szsh
	elif echo "$PWD" | grep "$ARS" > /dev/null 2>&1 && grep -i Arch < /etc/os-release  > /dev/null 2>&1 ; then
		 szsh
	elif echo "$PWD" | grep "$GS" > /dev/null 2>&1 && grep -i Gentoo < /etc/os-release > /dev/null 2>&1; then
		 szsh
	elif echo "$PWD" | grep "$DS" > /dev/null 2>&1 && grep -i "Debian\|Ubuntu" < /etc/os-release > /dev/null 2>&1; then
		 szsh
	elif echo "$PWD" | grep "$VS" > /dev/null 2>&1 && grep -i Void < /etc/os-release > /dev/null 2>&1; then
		 szsh
	elif echo "$PWD" | grep "$OSS" > /dev/null 2>&1 && grep -i openSUSE < /etc/os-release > /dev/null 2>&1; then
		 szsh
	elif echo "$PWD" | grep "$NS" > /dev/null 2>&1 && grep -i NixOS < /etc/os-release > /dev/null 2>&1; then
		 szsh
	elif echo "$PWD" | grep "$PLS" > /dev/null 2>&1 && grep -i PCLinuxOS < /etc/os-release > /dev/null 2>&1; then
		 szsh
	elif echo "$PWD" | grep "$CS" > /dev/null 2>&1 && grep -i CentOS < /etc/os-release > /dev/null 2>&1; then
		 szsh
	fi

	# Update common-scripts dirs
	if echo "$PWD" | grep "$HOME/Shell/common-scripts" > /dev/null 2>&1; then
		 if ! echo "$SHELL" | grep zsh > /dev/null 2>&1; then
			  read -p "Do you want to update common-scripts submodules and the main common-scripts repo (if not already up-to-date) now? [y/n] " yn
		 else
			  read "yn?Do you want to update common-scripts submodules and the main common-scripts repo (if not already up-to-date) now? [y/n] "
		 fi

		 case $yn in
			  [Yy]* ) update-common;;
			  [Nn]* ) printf "%s\n" "OK, it's your funeral. Run update-common if you change your mind." ;; 
			  * ) printf "%s\n" "Please answer y or n." ; ...
		 esac
	fi
}

# Estimate the size of the current repo
# Taken from http://stackoverflow.com/a/16163608/1876983
function gitsize {
	git gc
	git count-objects -vH
}

# Git shrink
# Taken from http://stackoverflow.com/a/2116892/1876983
function gitsh {
	git reflog expire --all --expire=now
	git gc --prune=now --aggressive
}

function pushss {
	push "$1" && gitsh && gitsize
}

# Complete push 
function pushf {
	if printf "$PWD" | grep 'AUR' > /dev/null 2>&1 ; then
		mksrcinfo
	fi

	if echo "$PWD" | grep opendesktop > /dev/null 2>&1 ; then
		commc=$(git rev-list --branches master --count)
		commn=$(octe "$commc+1")
		sed -i -e "s/PKGVER=[0-9]*/PKGVER=${commn}/g" "$PK"/opendesktop-app/pkg/appimage/appimagebuild
		pushmf "$1"
	elif echo "$PWD" | grep OpenRA > /dev/null 2>&1 ; then
		commc=$(git rev-list --branches bleed --count)
		commn=$(octe "$commc+1")
		sed -i -e "s/COMNO=[0-9]*/COMNO=${commn}/g" "$PK"/OpenRA/packaging/linux/buildpackage.sh
		pushmf "$1"
	else
		pushmf "$1"
	fi

	if echo "$PWD" | grep "$HOME/Shell" > /dev/null 2>&1 ; then
		szsh
	elif echo "$PWD" | grep "$FS" > /dev/null 2>&1 && grep -i Fedora < /etc/os-release > /dev/null 2>&1 ; then
		szsh
	elif echo "$PWD" | grep "$ARS" > /dev/null 2>&1 && grep -i Arch < /etc/os-release  > /dev/null 2>&1 ; then
		szsh
	elif echo "$PWD" | grep "$GS" > /dev/null 2>&1 && grep -i Gentoo < /etc/os-release > /dev/null 2>&1; then
		szsh
	elif echo "$PWD" | grep "$DS" > /dev/null 2>&1 && grep -i "Debian\|Ubuntu" < /etc/os-release > /dev/null 2>&1; then
		szsh
	elif echo "$PWD" | grep "$VS" > /dev/null 2>&1 && grep -i Void < /etc/os-release > /dev/null 2>&1; then
		szsh
	elif echo "$PWD" | grep "$OSS" > /dev/null 2>&1 && grep -i openSUSE < /etc/os-release > /dev/null 2>&1; then
		szsh
	elif echo "$PWD" | grep "$NS" > /dev/null 2>&1 && grep -i NixOS < /etc/os-release > /dev/null 2>&1; then
		szsh
	elif echo "$PWD" | grep "$PLS" > /dev/null 2>&1 && grep -i PCLinuxOS < /etc/os-release > /dev/null 2>&1; then
		szsh
	elif echo "$PWD" | grep "$CS" > /dev/null 2>&1 && grep -i CentOS < /etc/os-release > /dev/null 2>&1; then
		szsh
	fi

	# Update common-scripts dirs
	if echo "$PWD" | grep "$HOME/Shell/common-scripts" > /dev/null 2>&1; then
		if ! echo "$SHELL" | grep zsh > /dev/null 2>&1; then
			read -p "Do you want to update common-scripts submodules and the main common-scripts repo (if not already up-to-date) now? [y/n] " yn
		else
			read "yn?Do you want to update common-scripts submodules and the main common-scripts repo (if not already up-to-date) now? [y/n] "
		fi

		case $yn in
			[Yy]* ) update-common;;
			[Nn]* ) printf "%s\n" "OK, it's your funeral. Run update-common if you change your mind." ;; 
			* ) printf "%s\n" "Please answer y or n." ; ...
		esac
	fi
}
