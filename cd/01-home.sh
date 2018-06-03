function cda {
    cd $HOME/AUR/$1
}

# Chem
. $(dirname "$0")/home/chem.sh

# Docs
. $(dirname "$0")/home/documents.sh

# Downloads
function cddo {
    cd $HOME/Downloads/$1
}

# Music
function cdm {
    cd $HOME/Music/$1
}

# OBS
. $(dirname "$0")/home/obs.sh

# Pictures
. $(dirname "$0")/home/pictures.sh

# Programs
. $(dirname "$0")/home/programs.sh

# cd to Shell
function cdsh {
    cd $HOME/Shell/$1
}

# cd to Textbooks
function cdt {
    cd "$HOME/Textbooks/$1"
}

# Videos
. $(dirname "$0")/home/videos.sh

# VirtualBox VMs
. $(dirname "$0")/home/virtualbox.sh
