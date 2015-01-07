## AUR packages
AURGET="aurget --deps -Sy --nodiscard --noedit --noconfirm"

function archlinux_aur_install() {
	CDIR=`pwd`

	## Aurget
	cd $CDIR && wget -c http://aur.archlinux.org/packages/au/aurget/aurget.tar.gz
	cd $CDIR && tar zxfv aurget.tar.gz
	cd $CDIR/aurget/ && makepkg -s -f
	sudo pacman --noconfirm -U $CDIR/aurget/aurget-*-any.pkg.tar.xz
	cd $CDIR

	## Bitbake, OE
	#pacman -S --noconfirm python2-progressbar
	#$AURGET bitbake
	#pacman -S --noconfirm diffstat texi2html chrpath cpio

	$AURGET systemd-vgaswitcheroo-units
	systemctl enable vgaswitcheroo
	systemctl restart vgaswitcheroo

	$AURGET laptop-mode-tools
	systemctl enable laptop-mode
	systemctl restart laptop-mode

	## Google hangout
	#pacman -S --noconfirm libpng12
	#$AURGET google-talkplugin

	## Android
	#$AURGET repo
	#$AURGET android-sdk
	#$AURGET android-ndk

	## Printing
	#$AURGET hplip-plugin

	## CAD
	#$AURGET sweethome3d

	## Emacs Python IDE
	#$AURGET python-epc
	## Install jedi jedi-direx in Emacs

	## DART lang
	#$AURGET libgcrypt15
	#$AURGET dart-editor
	## Install dart-mode in Emacs

	## KDE 
	#$AURGET akonadi-googledata

	## Teamviewer
	#$AURGET teamviewer

	## ARM cross toolchain
	#$AURGET arm-linux-gnueabi-linux-api-headers
	#$AURGET arm-linux-gnueabi-gcc

	## Google fonts
	#$AURGET  ttf-google-fonts-git

	## Browser
	#$AURGET google-chrome

	## Oracle JDK 
	#$AURGET jdk

	## nodejs utils
	#$AURGET nodejs-npm2arch
	#mkdir $CDIR/cordova
	#cd $CDIR/cordova/ && npm2PKGBUILD cordova > PKGBUILD
	#cd $CDIR/cordova/ && makepkg
	#cd $CDIR/cordova/ && pacman --noconfirm -U nodejs-cordova-*.pkg.tar.xz
	#cd $CDIR

	## debootstrap
	#$AURGET debootstrap
	#$AURGET debian-archive-keyring
	#$AURGET gnupg1
	
}

archlinux_aur_install 2>&1 | tee archlinux-aur.log

aurget --deps -Syu --nodiscard --noedit --noconfirm 

