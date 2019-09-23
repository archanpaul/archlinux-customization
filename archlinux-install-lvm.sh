#!/bin/bash

HOSTNAME=arpo
INSTALL_TARGET_DISK=/dev/sda
LVM_SWAP_SIZE=32G
LVM_ROOT_SIZE=260G

INSTALL_SRC="file:///home"
INSTALL_TARGET="/tmp/mnt/"

FORMAT_EFI_PART="yes"
FORMAT_BOOT_PART="yes"
IS_LUKS_INSTALL="yes"
LUKS_FORMAT="yes"
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
echo "Server = http://mirrors.kernel.org/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
pacman -Sy

mkdir -p $INSTALL_TARGET

## disk partitioning, LVM
EFI_PART=$INSTALL_TARGET_DISK"1"
BOOT_PART=$INSTALL_TARGET_DISK"2"
LVM_PART=$INSTALL_TARGET_DISK"3"

gdisk $INSTALL_TARGET_DISK
cgdisk $INSTALL_TARGET_DISK

# Format EFI_PART
if [ "$FORMAT_EFI_PART" == "yes" ]
then
    mkfs.fat -F32 $EFI_PART
fi

# Create LUKS
if [ "$IS_LUKS_INSTALL" == "yes" ]
then
    modprobe dm_crypt
    if [ "$LUKS_FORMAT" == "yes" ]
    then
        cryptsetup luksFormat $LVM_PART
    fi
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

SWAP_PART=/dev/$VGNAME/swap
ROOT_PART=/dev/$VGNAME/root
HOME_PART=/dev/$VGNAME/home

## formatting, mounting

# swap
mkswap -L swap $SWAP_PART
swapon $SWAP_PART

# root
mkfs.ext4 -m 1 -L root $ROOT_PART
tune2fs -c 20 $ROOT_PART
fsck.ext4 -a $ROOT_PART
mount $ROOT_PART $INSTALL_TARGET

# boot
if [ "$FORMAT_BOOT_PART" == "yes" ]
then
    mkfs.ext4 -m 1 -L boot $BOOT_PART
fi
mount $BOOT_PART $INSTALL_TARGET/boot

pacman -S arch-install-scripts
pacstrap $INSTALL_TARGET/ base grub linux cryptsetup lvm2 vim net-tools wget rsync efibootmgr ntp wpa_supplicant

# home
if [ "$FORMAT_HOME" == "yes" ]
then
    mkfs.ext4 -m 0 -L home $HOME_PART
    tune2fs -c 20 $HOME_PART
    fsck.ext4 -a $HOME_PART
fi
mount $HOME_PART $INSTALL_TARGET/home/

genfstab -p -U $INSTALL_TARGET >> $INSTALL_TARGET/etc/fstab

cp -a $INSTALL_SRC/public/archlinux-repos/scripts $INSTALL_TARGET/root/

echo "Run : bash /root/archlinux-postinstall-stage01-lvm.sh inside chroot"
arch-chroot $INSTALL_TARGET/

rm $INSTALL_TARGET/root/archlinux-postinstall-stage01-lvm.sh
umount $INSTALL_TARGET/home
umount $INSTALL_TARGET/boot
umount $INSTALL_TARGET

