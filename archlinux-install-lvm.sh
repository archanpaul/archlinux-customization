#!/bin/bash


INSTALL_SRC="/run/archiso/img_dev/"

# In bootup console

## setup system time
hwclock --localtime -w
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime 
hwclock --hctosys
hwclock --adjust

## setup package repository
#echo "Server=http://ftp.iitm.ac.in/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist 
echo "Server=file://$INSTALL_SRC/public/archlinux-repos/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist 
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
BOOT_PART=$HDD"1"
LVM_PART=$HDD"2"
LVM_SWAP_SIZE=2G
LVM_ROOT_SIZE=80G

partprobe
cgdisk $HDD
partprobe 

modprobe dm_mod
lvmdiskscan
pvcreate LVM_PART
pvdisplay

vgcreate vg LVM_PART
lvcreate -L $LVM_SWAP_SIZE vg -n lvswap
lvcreate -L $LVM_ROOT_SIZE vg -n lvroot
lvcreate -l +100%FREE vg -n lvhome
lvdisplay

vgscan
vgchange -ay

## formatting, mounting
SWAP_PART=/dev/mapper/vg-lvswap
ROOT_PART=/dev/mapper/vg-lvroot
HOME=PART=/dev/mapper/vg-lvhome

INSTALL_TARGET="/mnt"

mkswap -L swap $SWAP_PART
swapon $SWAP_PART

mkfs.ext4 -m 1 -L root $ROOT_PART
tune2fs -c 20 $ROOT_PART
fsck.ext4 -a $ROOT_PART
mount $ROOT_PART $INSTALL_TARGET
mount $BOOT_PART $INSTALL_TARGET/boot/

pacstrap $INSTALL_TARGET/ base grub rsync vim net-tools linux lvm2

mkfs.ext4 -m 0 -L home $HOME_PART
tune2fs -c 20 $HOME_PART
fsck.ext4 -a $HOME_PART
mount $HOME_PART $INSTALL_TARGET/home/

genfstab -p -U $INSTALL_TARGET >> $INSTALL_TARGET/etc/fstab

cp $INSTALL_TARGET/etc/mkinitcpio.conf $INSTALL_TARGET/etc/mkinitcpio.conf.orig
awk '{gsub(/MODULES=\"\"/, "MODULES=\"ahci ext4 intel-agp i915\""); gsub(/HOOKS=\"base udev autodetect modconf block filesystems keyboard fsck\"/, "HOOKS=\"base udev autodetect modconf block encrypt lvm2 filesystems keyboard fsck\""); print}' $INSTALL_TARGET/etc/mkinitcpio.conf.orig > $INSTALL_TARGET/etc/mkinitcpio.conf
chroot $INSTALL_TARGET /bin/bash -c "mkinitcpio -p linux"

cp $INSTALL_SRC/public/archlinux-repos/scripts/archlinux-postinstall-stage01.sh $INSTALL_TARGET/root/
echo "Run : bash /root/archlinux-postinstall-stage01.sh inside chroot"
arch-chroot $INSTALL_TARGET/

rm $INSTALL_TARGET/root/archlinux-postinstall-stage01.sh
umount $INSTALL_TARGET/home
umount $INSTALL_TARGET/boot
umount $INSTALL_TARGET

