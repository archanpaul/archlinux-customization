#!/bin/bash

MY_HOSTNAME=arp
#INSTALL_SRC="http://192.168.168.101"
INSTALL_SRC="file:///home"
INSTALL_TARGET_DISK=/dev/sda
EFI_PART=$INSTALL_TARGET_DISK"1"
CRYPT_PART=$INSTALL_TARGET_DISK"2"

hwclock --localtime -w
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc 
hwclock --adjust

echo "LANG=\"en_US.UTF-8\"" > /etc/locale.conf
echo "LC_ALL=\"en_US.UTF-8\"" >> /etc/locale.conf
echo "LC_MESSAGES=\"C\"" >> /etc/locale.conf

cp /etc/locale.gen /etc/locale.gen.orig
awk '{gsub(/#en_US ISO-8859-1/, "en_US ISO-8859-1"); gsub(/#en_US.UTF-8 UTF-8/, "en_US.UTF-8 UTF-8"); gsub(/#en_IN UTF-8/, "en_IN UTF-8"); print}' /etc/locale.gen.orig > /etc/locale.gen
locale-gen 

## Create crypto_keyfile for disk decrypt
# dd bs=512 count=4 if=/dev/urandom of=/etc/crypto_keyfile.bin
echo -n $(
    (
        cat /sys/class/net/*/address
        grep 'MemTotal' /proc/meminfo
        grep -vE '(MHz|bogomips)' /proc/cpuinfo
        grep -v sr0 /proc/partitions
    ) | sha512sum ) > /etc/crypto_keyfile.bin
cryptsetup luksAddKey $CRYPT_PART /etc/crypto_keyfile.bin
# cryptsetup luksChangeKey $CRYPT_PART /etc/crypto_keyfile.bin
chmod 000 /etc/crypto_keyfile.bin

## Moved to install script
cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.orig
awk '{gsub("FILES=\\(", "FILES=\(/etc/crypto_keyfile.bin"); gsub("MODULES=\\(", "MODULES=\(ahci ext4 intel-agp i915\)"); gsub("HOOKS=\\(base udev autodetect modconf block filesystems keyboard fsck\\)", "HOOKS=\(base udev autodetect modconf block encrypt lvm2 filesystems keyboard fsck\)"); print}' /etc/mkinitcpio.conf.orig > /etc/mkinitcpio.conf
mkinitcpio -p linux

echo $MY_HOSTNAME > /etc/hostname
vim /etc/hostname
vim /etc/hosts 

mkdir /boot/efi
mount $EFI_PART /boot/efi
awk '{gsub("GRUB_CMDLINE_LINUX=\"\"", "GRUB_CMDLINE_LINUX=\"cryptdevice='$CRYPT_PART':lvm\""); print}' /etc/default/grub.orig > /etc/default/grub
echo "GRUB_ENABLE_CRYPTODISK=y" >> /etc/default/grub
grub-mkconfig > /boot/grub/grub.cfg
#grub-install $INSTALL_TARGET_DISK
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub

## setup package repository
echo "Server=$INSTALL_SRC/public/archlinux-repos/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist 
mv /etc/pacman.conf /etc/pacman.conf.orig
awk '{gsub(/#\[multilib\]/, "\[multilib\]\nInclude = /etc/pacman.d/mirrorlist"); print}' /etc/pacman.conf.orig > /etc/pacman.conf

# Securing boot
# chmod -R g-rwx,o-rwx /boot

vim /etc/fstab

umount $EFI_PART
echo "Exit and reboot. On rebooted system run : bash archlinux-postinstall-stage02.sh"
echo "#cryptdevice=/dev/LUKS_PART:VG root=/dev/mapper/VG-root" > /boot/grub/grub.cfg
