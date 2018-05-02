#!/bin/bash

HOSTNAME=arp
INSTALL_TARGET_DISK=/dev/sda
LVM_SWAP_SIZE=8G
LVM_ROOT_SIZE=240G

INSTALL_SRC="file:///home/"
INSTALL_TARGET="/mnt"

FORMAT_EFI_PART="no"
IS_LUKS_INSTALL="no"
CREATE_NEW_LVM="yes"
FORMAT_HOME="yes"

LVMNAME=lvm_$HOSTNAME
VGNAME=vg_$HOSTNAME

# In bootup console

## setup system time
ntpd -qg &
sleep 10
#timedatectl set-local-rtc 1
timedatectl set-timezone Asia/Kolkata

## setup package repository
echo "Server=$INSTALL_SRC/public/archlinux-repos/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist 
pacman -Sy

## disk partitioning, LVM
EFI_PART=$INSTALL_TARGET_DISK"1"
LVM_PART=$INSTALL_TARGET_DISK"2"

cgdisk $INSTALL_TARGET_DISK

# Format EFI_PATH
if [ "$FORMAT_EFI_PART" == "yes" ]
then
    mkfs.fat -F32 $EFI_PART
fi

# Create LUKS
if [ "$IS_LUKS_INSTALL" == "yes" ]
then
    modprobe dm_crypt
    cryptsetup luksFormat $LVM_PART
    cryptsetup luksOpen $LVM_PART $LVMNAME
fi

# Create LVM
modprobe dm_mod
lvmdiskscan

if [ "$CREATE_NEW_LVM" == "yes" ]
then
    if [ "$IS_LUKS_INSTALL" == "yes" ]
    then
	pvcreate /dev/mapper/$LVMNAME
	vgcreate $VGNAME /dev/mapper/$LVMNAME
    else
	pvcreate $LVM_PART
	vgcreate $VGNAME $LVM_PART
    fi
    lvcreate -L $LVM_SWAP_SIZE $VGNAME -n swap
    lvcreate -L $LVM_ROOT_SIZE $VGNAME -n root
    lvcreate -l +100%FREE $VGNAME -n home
fi

pvscan
pvdisplay
vgscan
vgchange -ay
vgdisplay
lvscan
lvdisplay

## formatting, mounting
SWAP_PART=/dev/$VGNAME/swap
ROOT_PART=/dev/$VGNAME/root
HOME_PART=/dev/$VGNAME/home

mkswap -L swap $SWAP_PART
swapon $SWAP_PART

mkfs.ext4 -m 1 -L root $ROOT_PART
tune2fs -c 20 $ROOT_PART
fsck.ext4 -a $ROOT_PART
mount $ROOT_PART $INSTALL_TARGET

pacstrap $INSTALL_TARGET/ base grub linux cryptsetup lvm2 vim net-tools wget rsync efibootmgr ntp

if [ "$FORMAT_HOME" == "yes" ]
then
    mkfs.ext4 -m 0 -L home $HOME_PART
    tune2fs -c 20 $HOME_PART
    fsck.ext4 -a $HOME_PART
fi
mount $HOME_PART $INSTALL_TARGET/home/

genfstab -p -U $INSTALL_TARGET >> $INSTALL_TARGET/etc/fstab

curl $INSTALL_SRC/public/archlinux-repos/scripts/archlinux-postinstall-stage01-lvm.sh > $INSTALL_TARGET/root/archlinux-postinstall-stage01-lvm.sh
curl $INSTALL_SRC/public/archlinux-repos/scripts/archlinux-postinstall-stage02.sh > $INSTALL_TARGET/root/archlinux-postinstall-stage02.sh

echo "Run : bash /root/archlinux-postinstall-stage01-lvm.sh inside chroot"
arch-chroot $INSTALL_TARGET/

rm $INSTALL_TARGET/root/archlinux-postinstall-stage01-lvm.sh
umount $INSTALL_TARGET/home
#umount $INSTALL_TARGET/boot
umount $INSTALL_TARGET

