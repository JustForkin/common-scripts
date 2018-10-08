function cdvbm {
	cd $HOME/"VirtualBox VMs"/$1
} 

function cdvi {
	cdvbm "iso/$1"
}

function cdvil {
	cdvi "Linux/$1"
}

function cdvid {
	cdvil "Debian/$1"
}
 
function cdviu {
	cdvil "Ubuntu/$1"
}

function cdvbim {
	cdvbm "img/$1"
}
