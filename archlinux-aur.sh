## AUR packages
aurcmd="bash aur.sh -si --noconfirm"

function archlinux_aur_install() {
	CDIR=`pwd`

	#$aurcmd laptop-mode-tools
	#sudo systemctl enable laptop-mode
	#sudo systemctl restart laptop-mode

	## Google hangout
	#pacman -S --noconfirm libpng12
	#$aurcmd google-talkplugin

	## Android
	#$aurcmd repo
	#$aurcmd gradle
	#$aurcmd android-studio
	#$aurcmd android-sdk
	#aurcmd android-ndk

	## Printing
	#$aurcmd hplip-plugin

	## Emacs Python IDE
	#$aurcmd python-sexpdata
	#$aurcmd python-epc
	## Install jedi jedi-direx in Emacs

	## Teamviewer
	#$aurcmd teamviewer

	## Google fonts
	#pacman -Rn ttf-droid
	#$aurcmd  ttf-google-fonts-git

	## Browser
	#$aurcmd google-chrome

	## Oracle JDK 
	#$aurcmd jdk

	## nodejs utils
	#$aurcmd nodejs-npm2arch
	#$aurcmd nodejs-bower

	## Cordova
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

#archlinux_aur_install 2>&1 | tee archlinux-aur.log

# Update existing aur packages
pacman -Qqm | xargs bash <(curl aur.sh) -si --noconfirm -si --needed
