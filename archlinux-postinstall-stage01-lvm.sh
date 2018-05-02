#!/bin/bash

HOSTNAME=arp
INSTALL_SRC="file:///home"
INSTALL_TARGET_DISK=/dev/sda

IS_EFI_INSTALL="yes"

# disk partitions
EFI_PART=$INSTALL_TARGET_DISK"1"
LVM_PART=$INSTALL_TARGET_DISK"2"

# Set systemtime
ntpd -qg
sleep 10
#timedatectl set-local-rtc 1
timedatectl set-timezone Asia/Kolkata


echo "LANG=\"en_US.UTF-8\"" > /etc/locale.conf
echo "LC_ALL=\"en_US.UTF-8\"" >> /etc/locale.conf
echo "LC_MESSAGES=\"C\"" >> /etc/locale.conf

cp /etc/locale.gen /etc/locale.gen.orig
awk '{gsub(/#en_US ISO-8859-1/, "en_US ISO-8859-1"); gsub(/#en_US.UTF-8 UTF-8/, "en_US.UTF-8 UTF-8"); gsub(/#en_IN UTF-8/, "en_IN UTF-8"); print}' /etc/locale.gen.orig > /etc/locale.gen
locale-gen 

## Moved to install script
cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.orig
awk '{gsub("MODULES=\\(", "MODULES=\(ahci ext4 intel-agp i915"); gsub("HOOKS=\\(base udev autodetect modconf block filesystems keyboard fsck\\)", "HOOKS=\(base udev autodetect modconf block encrypt lvm2 filesystems keyboard fsck\)"); print}' /etc/mkinitcpio.conf.orig > /etc/mkinitcpio.conf
mkinitcpio -p linux

# Set Hostname
echo $HOSTNAME > /etc/hostname
echo "127.0.0.1 localhost.localdomain localhost" >> /etc/hosts

# Setup GRUB 
cp /etc/default/grub /etc/default/grub.orig
awk '{gsub("GRUB_CMDLINE_LINUX=\"\"", "GRUB_CMDLINE_LINUX=\"\""); gsub("GRUB_PRELOAD_MODULES=\"\"", "GRUB_PRELOAD_MODULES=\"lvm\""); print}' /etc/default/grub.orig > /etc/default/grub
grub-mkconfig > /boot/grub/grub.cfg
if [ "$IS_EFI_INSTALL" == "yes" ]
then
    mkdir /boot/efi
    mount $EFI_PART /boot/efi
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchLinux-$HOSTNAME
    umount $EFI_PART
else
    grub-install $INSTALL_TARGET_DISK
fi

## setup package repository
echo "Server=$INSTALL_SRC/public/archlinux-repos/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist 
mv /etc/pacman.conf /etc/pacman.conf.orig
awk '{gsub(/#\[multilib\]/, "\[multilib\]\nInclude = /etc/pacman.d/mirrorlist"); print}' /etc/pacman.conf.orig > /etc/pacman.conf

# Securing boot
# chmod -R g-rwx,o-rwx /boot

vim /etc/fstab

echo "Exit and reboot. On rebooted system run : bash archlinux-postinstall-stage02.sh"
echo "#cryptdevice=/dev/LUKS_PART:VG root=/dev/mapper/VG-root" > /boot/grub/grub.cfg
