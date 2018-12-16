function jupup {
    cdgo jupyterlab
    git pull origin master -q
    mastn=$(comno)
    pkgn=$(grep "^pkgver=" < /data/abs/jupyterlab/PKGBUILD | cut -d '=' -f 2)
    comm=$(git log | head -n 1 | cut -d ' ' -f 2)
    pkgm=$(grep "^_commit=" < /data/abs/jupyterlab/PKGBUILD | cut -d '=' -f 2)

    if [[ $pkgn == $mastn ]]; then
         printf "JupyterLab is up to date!\n"
    else
         sed -i -e "s/$pkgn/$mastn/g" \
		-e "s/$pkgm/$comm/g"  /data/abs/jupyterlab/PKGBUILD
	 if command -v updpkgsums > /dev/null 2>&1 ; then
		 updpkgsums
		 if grep -i "Arch Linux" < /etc/os-release > /dev/null 2>&1 ; then
			 makepkg -sifC --noconfirm
		 fi
	 fi
    fi
}

alias jupyterup=jupup
