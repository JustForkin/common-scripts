function cda {
    cd $HOME/AUR/$1
}

function cdch {
    cd $HOME/Chem/$1
}

function cd2d {
    cdch "2D/$1"
}

function cd3d {
    cdch "3D/$1"
}

function cdd {
    cd $HOME/Documents/$1
}

function cdcfe {
    cdd "CodeLite/CPP-Math-Projects/$1"
}

function cdtx {
    cdd "Text files/$1"
}

function cddo {
    cd $HOME/Downloads/$1
}

function cdm {
    cd $HOME/Music/$1
}

function cdg {
    cd $HOME/GitHub/$1
}

function cdgm {
    cdg mine/$1
}

function cdgo {
    cdgo others/$1
}

function cdobs {
    cd $HOME/OBS/$1
}

function cdobsh {
    cdobs home:fusion809/$1
}

function cdp {
    cd $HOME/Programs/$1
}

function cdpa {
    if [[ -d $HOME/Programs/AppImage ]]; then
         cdp AppImage/$1
    elif [[ -d $HOME/Programs/AppImages ]]; then
         cdp AppImages/$1
    else
         read -p "No AppImage directory found at ~/Programs/AppImage, or ~/Programs/AppImages. Would you like you edit the file in which this function was defined?\n" yn
         case $yn in
              [Yy]* ) vim $HOME/Shell/common-scripts/cd.sh
         esac
    fi
}

function cdpd {
    cdp Deb/$1
}

function cdpe {
    cdp "exe/$1"
}

function cdpr {
    cdp rpm/$1
}

function cdpz {
    cdp zip/$1
}

function cdpi {
    cd $HOME/Pictures/$1
}

function cdart {
    if [[ -d $HOME/Pictures/Artwork ]]; then
         cdpi Artwork/$1
    else
         read -p "No ~/Pictures/Artwork directory found. Would you like to edit the file in which this function was defined?\n" yn
         case $yn in
              [Yy]* ) vim $HOME/Shell/common-scripts/cd.sh
         esac
    fi
}

function cdps {
    cdpi Screenshots/$1
}

# cd to Shell
function cdsh {
    cd $HOME/Shell/$1
}

function cdv {
    cd $HOME/Videos/$1
}

function cdvs {
    cd $HOME/Videos/SO
}

function cdvy {
    cdv "YouTube/$1"
}

function cdvm {
    cd $HOME/"VirtualBox VMs"/$1
} 

function cdvi {
    cdvm "ISOs/$1"
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
