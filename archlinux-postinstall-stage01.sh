#!/bin/bash

MY_HOSTNAME=arpc
INSTALL_TARGET_DISK=/dev/sda

hwclock --localtime -w
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc 
hwclock --adjust

echo "LANG=\"en_US.UTF8\"" > /etc/locale.conf
echo "LC_ALL=\"en_US.UTF8\"" > /etc/locale.conf
echo "LC_MESSAGES=\"C\"" >> /etc/locale.conf

cp /etc/locale.gen /etc/locale.gen.orig
awk '{gsub(/#en_US ISO-8859-1/, "en_US ISO-8859-1"); gsub(/#en_US.UTF-8 UTF-8/, "en_US.UTF-8 UTF-8"); gsub(/#en_IN UTF-8/, "en_IN UTF-8"); print}' /etc/locale.gen.orig > /etc/locale.gen
locale-gen 

## Moved to install script
#cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.orig
#awk '{gsub(/MODULES=\"\"/, "MODULES=\"ahci ext4 intel-agp i915\""); gsub(/HOOKS=\"base udev autodetect modconf block filesystems keyboard fsck\"/, "HOOKS=\"base udev autodetect modconf block encrypt lvm2 filesystems keyboard fsck\""); print}' mkinitcpio.conf.orig > mkinitcpio.conf
mkinitcpio -p linux

echo $MY_HOSTNAME > /etc/hostname
vim /etc/hostname
vim /etc/hosts 

echo "#cryptdevice=/dev/LUKS_PART:VG root=/dev/mapper/VG-root" > /boot/grub/grub.cfg
grub-mkconfig >> /boot/grub/grub.cfg
vim /boot/grub/grub.cfg
grub-install $INSTALL_TARGET_DISK

## setup package repository
echo "Server=file:///home/public/archlinux-repos/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist 
mv /etc/pacman.conf /etc/pacman.conf.orig
awk '{gsub(/#\[multilib\]/, "\[multilib\]\nInclude = /etc/pacman.d/mirrorlist"); print}' /etc/pacman.conf.orig > /etc/pacman.conf

echo "Exit and reboot. On rebooted system run : bash archlinux-postinstall-stage02.sh"
