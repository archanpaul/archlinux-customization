#!/bin/bash

MY_HOSTNAME=arp
#INSTALL_SRC="http://192.168.168.101"
INSTALL_SRC="file:///home"
INSTALL_TARGET_DISK=/dev/sda
EFI_PART=$INSTALL_TARGET_DISK"1"

# Set systemtime
ntpd -qg
sleep 10
#timedatectl set-local-rtc 1
timedatectl set-timezone Asia/Kolkata

echo "LANG=\"en_US\"" > /etc/locale.conf
echo "LC_ALL=\"en_US\"" >> /etc/locale.conf
echo "LC_MESSAGES=\"C\"" >> /etc/locale.conf

cp /etc/locale.gen /etc/locale.gen.orig
awk '{gsub(/#en_US ISO-8859-1/, "en_US ISO-8859-1"); gsub(/#en_US.UTF-8 UTF-8/, "en_US.UTF-8 UTF-8"); gsub(/#en_IN UTF-8/, "en_IN UTF-8"); print}' /etc/locale.gen.orig > /etc/locale.gen
locale-gen 

## Moved to install script
cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.orig
awk '{gsub("FILES=\\(", "FILES=\(/etc/crypto_keyfile.bin"); gsub("MODULES=\\(", "MODULES=\(ahci ext4 intel-agp i915\)"); gsub("HOOKS=\\(base udev autodetect modconf block filesystems keyboard fsck\\)", "HOOKS=\(base udev autodetect modconf block encrypt lvm2 filesystems keyboard fsck\)"); print}' /etc/mkinitcpio.conf.orig > /etc/mkinitcpio.conf
mkinitcpio -p linux

echo $MY_HOSTNAME > /etc/hostname
vim /etc/hostname
vim /etc/hosts 

echo "#cryptdevice=/dev/LUKS_PART:VG root=/dev/mapper/VG-root" > /boot/grub/grub.cfg
grub-mkconfig > /boot/grub/grub.cfg
vim /boot/grub/grub.cfg
#Non EFI install
#grub-install $INSTALL_TARGET_DISK
#EFI install
mkdir /boot/efi
mount $EFI_PART /boot/efi
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchLinux

## setup package repository
echo "Server=$INSTALL_SRC/public/archlinux-repos/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist 
mv /etc/pacman.conf /etc/pacman.conf.orig
awk '{gsub(/#\[multilib\]/, "\[multilib\]\nInclude = /etc/pacman.d/mirrorlist"); print}' /etc/pacman.conf.orig > /etc/pacman.conf

# Edit fstab for additional swap partition
vim /etc/fstab


umount /boot/efi

echo "Exit and reboot. On rebooted system run : bash archlinux-postinstall-stage02.sh"
