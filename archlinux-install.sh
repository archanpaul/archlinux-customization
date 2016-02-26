#!/bin/bash


INSTALL_SRC="http://192.168.168.101"
#INSTALL_SRC="file://run/archiso/img_dev/"

# In bootup console

## setup system time
hwclock --localtime -w
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime 
hwclock --hctosys
hwclock --adjust

## setup package repository
echo "Server=$INSTALL_SRC/public/archlinux-repos/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist 
cat > /etc/pacman.conf << "EOF"
[options]
Architecture = x86_64
CheckSpace
SigLevel    = Required DatabaseOptional
[core]
Include = /etc/pacman.d/mirrorlist
[extra]
Include = /etc/pacman.d/mirrorlist
[community]
Include = /etc/pacman.d/mirrorlist
[multilib]
Include = /etc/pacman.d/mirrorlist
EOF
pacman -Sy

## disk partitioning, formatting, mounting
HDD=/dev/sda
SWAP_PART=$HDD"2"
ROOT_PART=$HDD"3"
HOME_PART=$HDD"4"
INSTALL_TARGET="/mnt"

partprobe
cgdisk $HDD
partprobe 

mkswap -L swap $SWAP_PART
swapon $SWAP_PART

mkfs.ext4 -m 1 -L root $ROOT_PART
tune2fs -c 20 $ROOT_PART
fsck.ext4 -a $ROOT_PART
mount $ROOT_PART $INSTALL_TARGET

pacstrap $INSTALL_TARGET/ base grub linux vim net-tools wget rsync

mkfs.ext4 -m 0 -L home $HOME_PART
tune2fs -c 20 $HOME_PART
fsck.ext4 -a $HOME_PART
mount $HOME_PART $INSTALL_TARGET/home/

genfstab -p -U $INSTALL_TARGET >> /mnt/etc/fstab

cp $INSTALL_SRC/public/archlinux-repos/scripts/archlinux-postinstall-stage01.sh $INSTALL_TARGET/root/
wget $INSTALL_SRC/public/archlinux-repos/scripts/archlinux-postinstall-stage01.sh -O $INSTALL_TARGET/root/archlinux-postinstall-stage01.sh
wget $INSTALL_SRC/public/archlinux-repos/scripts/archlinux-postinstall-stage02.sh -O $INSTALL_TARGET/root/archlinux-postinstall-stage02.sh

echo "Run : bash /root/archlinux-postinstall-stage01.sh inside chroot"
arch-chroot $INSTALL_TARGET/

rm $INSTALL_TARGET/root/archlinux-postinstall-stage01.sh
umount $INSTALL_TARGET/home
umount $INSTALL_TARGET

