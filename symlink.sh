function symlink {
	if [[ -n "$1" ]]; then	
		sudo ln -sf $SCR/common-scripts/usr/local/bin/"$@" /usr/local/bin/
	else
		sudo ln -sf $SCR/common-scripts/usr/local/bin/* /usr/local/bin/
	fi
}

export ID=$(cat /etc/os-release | grep "^ID=" | cut -d "=" -f 2)

if ! ls -ld $HOME/Shell | grep -i "$ID" > /dev/null 2>&1 ; then
	printf "%s$ID\n" '$ID is '
	ln -sf $SCR/$ID-scripts/{.bashrc,.zshrc,Shell} $HOME/
	sudo ln -sf $SCR/$ID-scripts/root/{.bashrc,.zshrc,Shell} /root/
fi
