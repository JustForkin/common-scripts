function jupup {
    cdgo jupyterlab
    git pull origin master -q
    mastn=$(latest_commit_number)
    pkgn=$(grep "^pkgver=" < /data/GitHub/mine/packaging/jupyterlab-archpkg/PKGBUILD | cut -d '=' -f 2)
    comm=$(git log | head -n 1 | cut -d ' ' -f 2)
    pkgm=$(grep "^_commit=" < /data/GitHub/mine/packaging/jupyterlab-archpkg/PKGBUILD | cut -d '=' -f 2)

    if [[ $pkgn == $mastn ]]; then
         printf "JupyterLab is up to date!\n"
    else
	 cdpk jupyterlab-archpkg
         sed -i -e "s/$pkgn/$mastn/g" \
		-e "s/$pkgm/$comm/g"  PKGBUILD
	 if command -v updpkgsums > /dev/null 2>&1 ; then
		updpkgsums
		rm *.gz
		push ":arrow_up: $mastn"
	 fi
	 if grep -i "Arch Linux" < /etc/os-release > /dev/null 2>&1 ; then
 		cdpk jupyterlab-git
		makepkg -sifC --noconfirm
		rm *.xz
		push ":arrow_up: $mastn"
	 fi

    fi
}

alias jupyterup=jupup
alias jlabup=jupup
