function ostreeup {
	pkgver=$(wget -cqO- https://github.com/ostreedev/ostree/releases | grep "tar\.xz" | cut -d '/' -f 6 | sed "s|v||g" | head -n 1) 
	pkgpver=$(vere libostree) 
	if [[ $pkgver == $pkgpver ]]
	then
		printf "Seems to be up-to-date mate.\n"
	else
		sed -i -e "s/$pkgpver/$pkgver/g" $OBSH/libostree/libostree.spec
		cdobsh libostree
		osc ci -m "Bumping $pkgpver->$pkgver"
	fi
}

