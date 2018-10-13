function symlink {
	if [[ -n "$1" ]]; then	
		sudo ln -sf $SCR/common-scripts/usr/local/bin/"$@" /usr/local/bin/
	else
		sudo ln -sf $SCR/common-scripts/usr/local/bin/* /usr/local/bin/
	fi
}
