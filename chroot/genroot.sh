function genroot {
    if ! [[ -d "$1" ]]; then
	 sudo mkdir -p "$1"
    fi
    distro=$(echo $1 | cut -d '/' -f 2)
    lvmroot=$(ls /dev/mapper | grep -i "$distro" | grep -v "osprober")
    if (! cat /etc/mtab | grep "$1" > /dev/null 2>&1) && (ls /dev/mapper | grep -i "$distro" | grep -v "osprober" > /dev/null 2>&1); then
         sudo mount /dev/mapper/${lvmroot} /$distro
    elif ( ! cat /etc/mtab | grep "$1" > /dev/null 2>&1 ) && (ls -ld /dev/disk/by-label/* | grep -i $distro > /dev/null 2>&1); then
         sudo mount /dev/$(ls -ld /dev/disk/by-label/* | grep -i $distro | cut -d '/' -f 7) /$distro
    elif ( ! cat /etc/mtab | grep "$1" > /dev/null 2>&1 ); then
	printf "Sorry mate, I cannot seem to find a partition with a file system named $distro\n"
    fi

    # Check where the root filesystem is
    if [[ -d $1/root/dev ]]; then
         root="$1/root"
    elif [[ -d $1/@/dev ]]; then
         root="$1/@"
    else
         root="$1"
    fi

    # Make sure the data partition is mounted
    if [[ -d $root/data ]] && ! `cat /etc/mtab | grep $root/data > /dev/null 2>&1`; then
         sudo mount /dev/sdb1 $root/data
    fi

    # Mount up ESP
    if [[ -d $root/boot/efi ]] && ! `cat /etc/mtab | grep $root/boot/efi > /dev/null 2>&1`; then
	# Commented out command mounts up sdb2, instead of sda1
         #sudo mount /dev/$(ls -ld /dev/disk/by-label/* | grep -i EFI | cut -d '/' -f 7) $root/boot/efi
	sudo mount /dev/$(parted /dev/sda print | grep EFI | cut -d ' ' -f 2) $root/boot/efi
    fi
    # Check if the appropriate mount points are set up for the chroot to work
    if ! [[ -f "$root/proc/cgroups" ]]; then
         sudo mount -t proc /proc "$root/proc"
         sudo mount --rbind /dev "$root/dev"
         sudo mount --make-rslave "$root/dev"
         sudo mount --rbind /sys "$root/sys"
         sudo mount --make-rslave "$root/sys"
         sudo rm "$root/etc/resolv.conf"
         sudo cp -L /etc/resolv.conf "$root/etc"
    fi

    if [[ -f $root/bin/env ]]; then
         ENV=/bin/env
    elif [[ -f $root/usr/bin/env ]]; then
         ENV=/usr/bin/env
    fi
    
    if [[ -f $root/usr/local/bin/su-fusion809 ]]; then
         sudo chroot "$root" /usr/local/bin/su-fusion809
    elif [[ -f $root/bin/zsh ]]; then
         #sudo chroot "$root" $ENV -i     \
         #      HOME="/root"              \
         #      PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin \
         #      /bin/zsh --login +h
         sudo chroot "$root" /bin/zsh
    elif [[ -f $root/bin/bash ]]; then
         sudo chroot "$root" $ENV -i     \
               HOME="/root"              \
               PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin \
               /bin/bash --login +h
    elif `cat $root/etc/os-release | grep -i NixOS > /dev/null 2>&1`; then
         INIT=$(sudo find $root/nix/store -type f -path '*nixos*/init' -print -quit)
         BASH=$(sudo find $root/nix/store -type f -path '*/bin/bash' -print -quit)
         BASH=$(echo $BASH | sed "s|/nixos||g")
         ENV=$(sudo find $root/nix/store -type f -path '*/bin/env' -print -quit)
         sudo sed -i "s,exec systemd,exec /$BASH," $INIT

         INIT=$(echo $INIT | sed "s|/nixos||g")

         sudo chroot $root ./$INIT --login +h

    elif [[ -f $root/bin/sh ]] || [[ -L $root/bin/sh ]]; then
         sudo chroot "$root" /bin/sh
    else
         printf "I'm missing a shell, mate!"
    fi

    if [[ -f $root/usr/bin/dnf ]]; then
         sudo touch "$root/.autorelabel"
    fi
}
