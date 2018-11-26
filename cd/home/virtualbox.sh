function cdvbm {
	cd $HOME/"VirtualBox VMs"/$1
} 

function cdvi {
	cdvbm "iso/$1"
}

function cdvib {
	cdvi "BSDs/$1"
}

function cdvil {
	cdvi "Linux/$1"
}

function cdvia {
	cdvil "Arch Linux/$1"
}

function cdvid {
	cdvil "Debian/$1"
}

function cdviu {
	cdvid "Ubuntu/$1"
}

function cdvig {
	cdvil "Gentoo/$1"
}

function cdvili {
	cdvil "Independent distros/$1"
}

function cdvir {
	cdvil "RPM distros/$1"
}

function cdvif {
	cdvir "RPM/Fedora/$1"
}

function cdvirr {
	cdvir "RHEL/$1"
}

function cdvio {
	cdvi "Other OS/$1"
}

function cdvbim {
	cdvbm "img/$1"
}
