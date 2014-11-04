## AUR packages

function archlinux_aur_install() {
	CDIR=`pwd`

	## Aurget
	cd $CDIR && wget -c http://aur.archlinux.org/packages/au/aurget/aurget.tar.gz
	cd $CDIR && tar zxfv aurget.tar.gz
	cd $CDIR/aurget/ && makepkg -s -f --asroot
	pacman --noconfirm -U $CDIR/aurget/aurget-*-any.pkg.tar.xz
	cd $CDIR

	## Bitbake, OE
	#pacman -S --noconfirm python2-progressbar
	#aurget --deps -Sy --nodiscard --noedit --noconfirm --asroot bitbake
	#pacman -S --noconfirm diffstat texi2html chrpath cpio

	aurget --deps -Sy --nodiscard --noedit --noconfirm --asroot systemd-vgaswitcheroo-units
	systemctl enable vgaswitcheroo
	systemctl restart vgaswitcheroo

	aurget --deps -Sy --nodiscard --noedit --noconfirm --asroot laptop-mode-tools
	systemctl enable laptop-mode
	systemctl restart laptop-mode

	## Google hangout
	pacman -S --noconfirm libpng12
	aurget --deps -Sy --nodiscard --noedit --noconfirm --asroot google-talkplugin

	## Android
	aurget --deps -Sy --nodiscard --noedit --noconfirm --asroot repo
	aurget --deps -Sy --nodiscard --noedit --noconfirm --asroot android-sdk
	#aurget --deps -Sy --nodiscard --noedit --noconfirm --asroot android-ndk

	## Printing
	aurget --deps -Sy --nodiscard --noedit --noconfirm --asroot hplip-plugin

	## CAD
	#aurget --deps -Sy --nodiscard --noedit --noconfirm --asroot sweethome3d

	## Emacs Python IDE
	aurget --deps -Sy --nodiscard --noedit --noconfirm --asroot python-epc
	## Install jedi jedi-direx in Emacs

	## DART lang
	aurget --deps -Sy --nodiscard --noedit --noconfirm --asroot libgcrypt15
	aurget --deps -Sy --nodiscard --noedit --noconfirm --asroot dart-editor
	## Install dart-mode in Emacs

	## KDE 
	#aurget --deps -Sy --nodiscard --noedit --noconfirm --asroot akonadi-googledata

	## Teamviewer
	#aurget --deps -Sy --nodiscard --noedit --noconfirm --asroot teamviewer

	## ARM cross toolchain
	#aurget --deps -Sy --nodiscard --noedit --noconfirm --asroot arm-linux-gnueabi-linux-api-headers
	#aurget --deps -Sy --nodiscard --noedit --noconfirm --asroot arm-linux-gnueabi-gcc

	## Google fonts
	#aurget --deps -Sy --nodiscard --noedit --noconfirm --asroot  ttf-google-fonts-git

	## Browser
	#aurget --deps -Sy --nodiscard --noedit --noconfirm --asroot google-chrome

	## nodejs utils
	#aurget --deps -Sy --nodiscard --noedit --noconfirm --asroot nodejs-npm2arch
	#mkdir $CDIR/cordova
	#cd $CDIR/cordova/ && npm2PKGBUILD cordova > PKGBUILD
	#cd $CDIR/cordova/ && makepkg --asroot
	#cd $CDIR/cordova/ && pacman --noconfirm -U nodejs-cordova-*.pkg.tar.xz
	#cd $CDIR
}

archlinux_aur_install 2>&1 | tee archlinux-aur.log

aurget --deps -Syu --nodiscard --noedit --noconfirm --asroot

