function jupup {
    cdgo jupyterlab
    git pull origin master -q
    mastn=$(comno)
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
		 if grep -i "Arch Linux" < /etc/os-release > /dev/null 2>&1 ; then
			 makepkg -sifC --noconfirm
		 fi
		 push ":arrow_up: $mastn"
	 fi
    fi
}

alias jupyterup=jupup
alias jlabup=jupup
