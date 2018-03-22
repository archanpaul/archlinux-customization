#!/bin/bash

HOSTNAME=arpo
LVMNAME=lvm_$HOSTNAME
VGNAME=vg_$HOSTNAME
#INSTALL_SRC="http://192.168.168.101"
INSTALL_SRC="file:///home/"

# In bootup console

## setup system time
ntpd -qg &
sleep 10
#hwclock --localtime -w
#ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime 
#hwclock --hctosys
#hwclock --adjust
#timedatectl set-local-rtc 1
timedatectl set-timezone Asia/Kolkata

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

## disk partitioning, LVM
HDD=/dev/sda
EFI_PART=$HDD"1"
CRYPT_PART=$HDD"2"
####BOOT_PART=$HDD"2"
LVM_SWAP_SIZE=8G
LVM_ROOT_SIZE=240G

cgdisk $HDD

# Don't format EFI_PATH
#mkfs.fat -F32 $EFI_PART

modprobe dm_crypt
cryptsetup luksFormat $CRYPT_PART
cryptsetup luksOpen $CRYPT_PART $LVMNAME

modprobe dm_mod
lvmdiskscan
pvcreate /dev/mapper/$LVMNAME
pvdisplay

vgcreate $VGNAME /dev/mapper/$LVMNAME
lvcreate -L $LVM_SWAP_SIZE $VGNAME -n swap
lvcreate -L $LVM_ROOT_SIZE $VGNAME -n root
lvcreate -l +100%FREE $VGNAME -n home
lvdisplay

vgscan
vgchange -ay

## formatting, mounting
SWAP_PART=/dev/$VGNAME/swap
ROOT_PART=/dev/$VGNAME/root
HOME_PART=/dev/$VGNAME/home

INSTALL_TARGET="/mnt"

mkswap -L swap $SWAP_PART
swapon $SWAP_PART

mkfs.ext4 -m 1 -L root $ROOT_PART
tune2fs -c 20 $ROOT_PART
fsck.ext4 -a $ROOT_PART
mount $ROOT_PART $INSTALL_TARGET

#mkdir $INSTALL_TARGET/boot/
#mkfs.ext4 -m 0 -L boot $BOOT_PART
#mount $BOOT_PART $INSTALL_TARGET/boot/

pacstrap $INSTALL_TARGET/ base grub linux cryptsetup lvm2 vim net-tools wget rsync efibootmgr

mkfs.ext4 -m 0 -L home $HOME_PART
tune2fs -c 20 $HOME_PART
fsck.ext4 -a $HOME_PART
mount $HOME_PART $INSTALL_TARGET/home/

genfstab -p -U $INSTALL_TARGET >> $INSTALL_TARGET/etc/fstab

curl $INSTALL_SRC/public/archlinux-repos/scripts/archlinux-postinstall-stage01-lvm_crypt.sh > $INSTALL_TARGET/root/archlinux-postinstall-stage01-lvm_crypt.sh
curl $INSTALL_SRC/public/archlinux-repos/scripts/archlinux-postinstall-stage02.sh > $INSTALL_TARGET/root/archlinux-postinstall-stage02.sh

echo "Run : bash /root/archlinux-postinstall-stage01-lvm_crypt.sh inside chroot"
arch-chroot $INSTALL_TARGET/

rm $INSTALL_TARGET/root/archlinux-postinstall-stage01-lvm_crypt.sh
umount $INSTALL_TARGET/home
#umount $INSTALL_TARGET/boot
umount $INSTALL_TARGET

