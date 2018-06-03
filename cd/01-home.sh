function cda {
    cd $HOME/AUR/$1
}

# Chem
. $(dirname "$0")/home/chem.sh

# 
function cddo {
    cd $HOME/Downloads/$1
}

function cdm {
    cd $HOME/Music/$1
}

# cd to Shell
function cdsh {
    cd $HOME/Shell/$1
}

# cd to Textbooks
function cdt {
    cd "$HOME/Textbooks/$1"
}
