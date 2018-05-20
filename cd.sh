function cdpa {
    if [[ -d $HOME/Programs/AppImage ]]; then
         cd $HOME/Programs/AppImage/$1
    elif [[ -d $HOME/Programs/AppImages ]]; then
         cd $HOME/Programs/AppImages/$1
    else
         read -p "No AppImage directory found at ~/Programs/AppImage, or ~/Programs/AppImages. Would you like you edit the file in which this function was defined?\n" yn
         case $yn in
              [Yy]* ) vim $HOME/Shell/common-scripts/cd.sh
         esac
    fi
}

function cdart {
    if [[ -d $HOME/Pictures/Artwork ]]; then
         cd $HOME/Pictures/Artwork/$1
    else
         read -p "No ~/Pictures/Artwork directory found. Would you like to edit the file in which this function was defined?\n" yn
         case $yn in
              [Yy]* ) vim $HOME/Shell/common-scripts/cd.sh
         esac
    fi
}
