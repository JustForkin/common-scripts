function symlink {
	if [[ -n "$1" ]]; then	
		sudo ln -sf $SCR/common-scripts/usr/local/bin/"$@" /usr/local/bin/
	else
		sudo ln -sf $SCR/common-scripts/usr/local/bin/* /usr/local/bin/
	fi
}

export ID=$(cat /etc/os-release | grep "^ID=" | cut -d "=" -f 2)
if [[ $ID == "deepin" ]] || [[ $ID == "ubuntu" ]] || [[ $ID == "mint" ]] || cat /etc/os-release | grep -i "debian\|ubuntu" > /dev/null 2>&1; then
	export ID=debian
elif [[ $ID == "manjaro" ]] || [[ $ID == "antergos" ]] || cat /etc/os-release | grep -i arch > /dev/null 2>&1; then
	export ID=arch
elif [[ -f /usr/bin/zypper ]] || cat /etc/os-release | grep -i opensuse > /dev/null 2>&1; then
	export ID=opensuse
elif grep -i funtoo < /etc/os-release > /dev/null 2>&1 ; then
	export ID=funtoo
elif [[ -f /usr/bin/emerge ]]; then
	export ID=gentoo
elif [[ -f /usr/bin/eopkg ]]; then
	export ID=solus
elif [[ -f /usr/bin/installpkg ]] || cat /etc/os-release | grep -i slackware > /dev/null 2>&1 ; then
	export ID=slackware
elif [[ -f /usr/bin/yum ]]; then
	export ID=centos
fi

if ! ls -ld $HOME/Shell | grep -i "$ID" > /dev/null 2>&1 ; then
	printf "%s$ID\n" '$ID is '
	ln -sf $SCR/$ID-scripts/{.bashrc,.zshrc,Shell} $HOME/
	sudo ln -sf $SCR/$ID-scripts/root/{.bashrc,.zshrc,Shell} /root/
fi
