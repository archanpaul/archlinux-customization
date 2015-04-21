## AUR packages
aurcmd="bash aur.sh -si --noconfirm"

function archlinux_aur_install() {
	CDIR=`pwd`

	## Bitbake, OE
	#pacman -S --noconfirm python2-progressbar
	#$aurcmd bitbake
	#pacman -S --noconfirm diffstat texi2html chrpath cpio

	#$aurcmd systemd-vgaswitcheroo-units
	#systemctl enable vgaswitcheroo
	#systemctl restart vgaswitcheroo

	#$aurcmd laptop-mode-tools
	#sudo systemctl enable laptop-mode
	#sudo systemctl restart laptop-mode

	## Google hangout
	#pacman -S --noconfirm libpng12
	#$aurcmd google-talkplugin

	## Pencil pencil.evolus.vn
	#$aurcmd pencil

	## Android
	#$aurcmd repo
	#$aurcmd gradle
	#$aurcmd android-studio
	#$aurcmd android-sdk
	#$aurcmd android-ndk

	## Printing
	#$aurcmd hplip-plugin

	## Emacs Python IDE
	#$aurcmd python-sexpdata
	#$aurcmd python-epc
	## Install jedi jedi-direx in Emacs

	## DART lang
	$aurcmd libgcrypt15
	$aurcmd libudev.so.0
	$aurcmd dart-editor
	## Install dart-mode in Emacs

	## KDE 
	#$aurcmd akonadi-googledata

	## Teamviewer
	#$aurcmd teamviewer

	## ARM cross toolchain
	#$aurcmd arm-linux-gnueabi-linux-api-headers
	#$aurcmd arm-linux-gnueabi-gcc

	## Google fonts
	#$aurcmd  ttf-google-fonts-git

	## Browser
	#$aurcmd google-chrome

	## Oracle JDK 
	#$aurcmd jdk

	## nodejs utils
	#$aurcmd nodejs-npm2arch
	#mkdir $CDIR/cordova
	#cd $CDIR/cordova/ && npm2PKGBUILD cordova > PKGBUILD
	#cd $CDIR/cordova/ && makepkg
	#cd $CDIR/cordova/ && pacman --noconfirm -U nodejs-cordova-*.pkg.tar.xz
	#cd $CDIR

	## debootstrap
	#$aurcmd debootstrap
	#$aurcmd debian-archive-keyring
	#$aurcmd gnupg1
	
}

archlinux_aur_install 2>&1 | tee archlinux-aur.log

