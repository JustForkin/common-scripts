function cdpa {
    if [[ -d $HOME/Programs/AppImage ]]; then
         cd $HOME/Programs/AppImage
    elif [[ -d $HOME/Programs/AppImages ]]; then
         cd $HOME/Programs/AppImages
    else
         read -p "No AppImage directory found at ~/Programs/AppImage, or ~/Programs/AppImages. Would you like you edit the file in which this function was defined?\n" yn
         case $yn in
              [Yy]* ) vim $HOME/Shell/common-scripts/cd.sh
         esac
    fi
}
