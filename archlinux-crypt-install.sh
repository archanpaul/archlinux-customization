#!/bin/bash

####configuration section########

TARGET_ARCH="x86_64"
INSTALL_SRC="/run/archiso/img_dev/public/"
INSTALL_TARGET=/mnt

TIMEZONE="/usr/share/zoneinfo/Asia/Kolkata"

# HDD configuration
HDD="/dev/sda"
BOOT_PART=$HDD"2"
CRYPT_PART=$HDD"3"
LVM_VG="vg"
LVM_SWAP="swap"
LVM_SWAP_SIZE="2G"
LVM_ROOT="root"
LVM_ROOT_SIZE="60G"
LVM_HOME="home"
LVM_HOME_SIZE="+100%FREE"

#################################

read -p "This is experimental. Do you want to continue? (yes/no) : "
if [ "$REPLY" != "yes" ]; then
   exit
fi

# In bootup console

## setup system time
hwclock --localtime -w
ln -sf $TIMEZONE /etc/localtime 
hwclock --hctosys
hwclock --adjust

## setup package repository
#echo "Server=http://ftp.iitm.ac.in/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist 
echo "Server=file://$INSTALL_SRC/archlinux-repos/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist 
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
SWAP_PART=/dev/mapper/$LVM_VG-$LVM_SWAP
ROOT_PART=/dev/mapper/$LVM_VG-$LVM_ROOT
HOME_PART=/dev/mapper/$LVM_VG-$LVM_HOME

mkdir -p $INSTALL_TARGET

partprobe
cgdisk $HDD
partprobe 

# prepare LUKS partition
cryptsetup luksFormat $CRYPT_PART
cryptsetup open --type luks $CRYPT_PART lvm

# prepare LVM
pvcreate /dev/mapper/lvm
vgcreate $LVM_VG /dev/mapper/lvm
lvcreate -L $LVM_SWAP_SIZE $LVM_VG -n $LVM_SWAP
lvcreate -L $LVM_ROOT_SIZE $LVM_VG -n $LVM_ROOT
lvcreate -l $LVM_HOME_SIZE $LVM_VG -n LVM_HOME

# preparing boot partition
mkfs.ext4 -m 1 -L root $BOOT_PART
tune2fs -c 20 $BOOT_PART
fsck.ext4 -a $BOOT_PART
mkdir -p $INSTALL_TARGET/boot
mount $BOOT_PART $INSTALL_TARGET/boot

# preparing swap partition
mkswap -L swap $SWAP_PART
swapon $SWAP_PART

# preparing root partition
mkfs.ext4 -m 1 -L root $ROOT_PART
tune2fs -c 20 $ROOT_PART
fsck.ext4 -a $ROOT_PART
mount $ROOT_PART $INSTALL_TARGET

# preparing home partition
mkfs.ext4 -m 0 -L home $HOME_PART
tune2fs -c 20 $HOME_PART
fsck.ext4 -a $HOME_PART
mount $HOME_PART $INSTALL_TARGET/home/

# install base
pacstrap $INSTALL_TARGET/ base grub rsync vim net-tools linux-lts cryptsetup lvm2

genfstab -p -U $INSTALL_TARGET >> /mnt/etc/fstab 
cat >> /etc/fstab << "EOF"
/dev/mapper/tmp         /tmp    tmpfs           defaults        0       0
EOF

cat > /etc/crypttab << "EOF"
swap	/dev/lvm/swap	/dev/urandom	swap,cipher=aes-xts-plain64,size=256
tmp	/dev/lvm/tmp	/dev/urandom	tmp,cipher=aes-xts-plain64,size=256
EOF

cp $INSTALL_SRC/archlinux-repos/scripts/archlinux-postinstall-stage01.sh $INSTALL_TARGET/root/
echo "Run : bash /root/archlinux-postinstall-stage01.sh inside chroot"
arch-chroot $INSTALL_TARGET/

rm $INSTALL_TARGET/root/archlinux-postinstall-stage01.sh
umount $INSTALL_TARGET/home
umount $INSTALL_TARGET

