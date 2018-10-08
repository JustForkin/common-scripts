#############################################################
# The following script was taken from
# http://stackoverflow.com/a/18915067/1876983
#############################################################
# Sign in with SSH at startup
# Makes contributing to GitHub projects a lot simpler.
#if grep -i "Void\|Gentoo" < /etc/os-release > /dev/null 2>&1 ; then
#    eval `keychain -q --eval aur` | tee -a /tmp/aur.log
#    eval `keychain -q --eval id_rsa` | tee -a /tmp/id_rsa.log
	if ! [[ -f /tmp/aur.log ]] ; then
	eval ssh-agent $SHELL
	ssh-add ~/.ssh/aur | tee -a /tmp/aur.log
	ssh-add ~/.ssh/id_rsa | tee -a /tmp/id_rsa.log
	fi
#else
#    if [[ -a "$HOME/.ssh/environment" ]]; then
#       	SSH_ENV="$HOME/.ssh/environment"
#    elif [[ "$USER" == fusion809 ]] && ! [[ -f "$HOME/.ssh/id_rsa.pub" ]]; then
#	ssh-keygen -t rsa -b 4096 -C "brentonhorne77@gmail.com"
#	SSH_ENV="$HOME/.ssh/environment"
#	git config --global user.name "fusion809"
#	git config --global user.email "brentonhorne77@gmail.com"
#    elif [[ -n $EMAIL ]] && ! [[ -f "$HOME/.ssh/id_rsa.pub" ]]; then
#	ssh-keygen -t rsa -b 4096 -C "$EMAIL"
#	SSH_ENV="$HOME/.ssh/environment"
#	git config --global user.name "$USER"
#	git config --global user.email "$EMAIL"
#    fi

#    if ! which keychain > /dev/null 2>&1; then
#         if grep -i openSUSE < /etc/os-release > /dev/null 2>&1; then
#              sudo zypper in -y keychain
#         elif grep -i Fedora < /etc/os-release > /dev/null 2>&1; then
#              sudo dnf install -y keychain
#         elif grep -i "Debian\|Ubuntu\|deepin" < /etc/os-release > /dev/null 2>&1; then
#              sudo apt install -y keychain
#         elif grep -i "CentOS" < /etc/os-release > /dev/null 2>&1; then
#              sudo yum install -y keychain
#         elif grep -i "Arch" < /etc/os-release > /dev/null 2>&1; then
#              sudo pacman -S keychain --noconfirm
#         elif grep -i "Gentoo" < /etc/os-release > /dev/null 2>&1; then
#              sudo emerge net-misc/keychain
 #        elif grep -i "Void" < /etc/os-release > /dev/null 2>&1; then
 #             sudo xbps-install -y keychain
#         elif grep -i "NixOS" < /etc/os-release > /dev/null 2>&1; then
  #            nix-env -i keychain
 #        fi
#    fi

 #       if ! grep Mageia > /dev/null 2>&1; then
#	      eval keychain -q --eval id_rsa
 #       fi


# AUR
#    if [[ $USER == "fusion809" ]] || [[ $AUR == "true" ]]; then
#	if ! [[ -f "$HOME"/.ssh/config ]]; then
#		echo "Host aur.archlinux.org\n  IdentityFile ~/.ssh/aur\n  User aur" > "$HOME"/.ssh/config
#	fi
#
#	if ! [[ -f "$HOME"/.ssh/aur.pub ]]; then
#		ssh-keygen -f "$HOME"/.ssh/aur
#	fi

	# start the ssh-agent
	# Remember, for this to work you need your SSH keys setup
	# https://help.github.com/articles/generating-ssh-keys/
 #       if ! grep Mageia > /dev/null 2>&1; then
#	      eval keychain -q --eval aur
 #       fi
 #   else
#	printf "%s\n" "Add an AUR=true line to your $HOME/.gitconfig.sh file in order to set up SSH to authenticate AUR commits."
#    fi
#fi
#############################################################
