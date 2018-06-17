#!/bin/bash

# It should get reflected in Stage-01 but it does not.
timedatectl set-timezone Asia/Kolkata

#PACMAN="pacman -S --noconfirm --needed -w "
PACMAN="pacman -S --noconfirm --needed "

## Base
function base() {
	$PACMAN base grub lsb-release
	$PACMAN util-linux dbus systemd systemd-sysvcompat syslog-ng cronie
	$PACMAN linux linux-headers linux-api-headers linux-firmware acpi_call
	$PACMAN intel-ucode
}

## Console tools
function console_tools() {
	$PACMAN e2fsprogs extundelete ntfsprogs gptfdisk ecryptfs-utils wipe mtpfs 
	$PACMAN dosfstools
	$PACMAN acpi acpid powertop
	$PACMAN hdparm smartmontools
	$PACMAN bc sudo mc links
	$PACMAN ntp 
	$PACMAN minicom screen
	$PACMAN zip unzip p7zip bzip2 unrar lxsplit
	$PACMAN pwgen
	$PACMAN dmidecode
}

## Network tools
function network_tools() {
	$PACMAN nmap ufw whois dnsutils
	$PACMAN lftp rsync wget 
	$PACMAN usb_modeswitch wvdial
	$PACMAN ethtool bridge-utils
	$PACMAN net-tools netctl
	$PACMAN wireless_tools wpa_supplicant wpa_actiond crda
	$PACMAN bluez bluez-firmware bluez-utils
	$PACMAN networkmanager 
	$PACMAN wireshark-cli
}

## Xorg
function xorg() {
	$PACMAN xorg-server 
	$PACMAN xorg-server-xwayland
	$PACMAN xorg-server-xephyr
	$PACMAN mesa-libgl
	$PACMAN xf86-video-intel intel-dri libva-intel-driver 
	$PACMAN xf86-input-evdev xf86-input-synaptics 
	$PACMAN xf86-video-ati ati-dri
	$PACMAN xterm xorg-xkill xorg-xhost
	$PACMAN xorg-xdm
	$PACMAN xorg-xinit
	$PACMAN xcursor-simpleandsoft

#echo "Section "Device"
#   Identifier  "Intel Graphics"
#   Driver      "intel"
#   Option      "AccelMethod"  "sna"
#   Option      "TearFree"    "true"
#EndSection" > /etc/X11/xorg.conf.d/20-intel.conf

}

## Wayland
function wayland() {
	$PACMAN wayland wayland-protocols
	$PACMAN xorg-server-xwayland 
	$PACMAN glew-wayland 
	$PACMAN weston
}

## SCM
function scm() {
	$PACMAN git cgit repo
	#$PACMAN subversion bzr mercurial
}

## Printing
function printing() {
	$PACMAN cups cups-pdf
	$PACMAN foomatic-db foomatic-db-ppds foomatic-db-engine foomatic-db-nonfree 
	$PACMAN ghostscript gsfonts gutenprint 
	$PACMAN hplip splix
	$PACMAN sane 
}

## Dev tools
function dev_tools() {
	$PACMAN base-devel 
	$PACMAN binutils gcc gcc-libs libtool
	$PACMAN lib32-gcc-libs
	#$PACMAN multilib-devel 
	$PACMAN gcc-fortran
	$PACMAN llvm llvm-libs lld lldb
	$PACMAN make cmake scons automake autoconf libtool m4 patch pkg-config
	$PACMAN ctags
	$PACMAN flex bison gperf 
	$PACMAN gdb valgrind
	#$PACMAN cppunit gtest
	$PACMAN doxygen
	$PACMAN zlib boost 
	$PACMAN openmpi opencv
	$PACMAN strace ltrace

	$PACMAN go go-tools
	#go get -u golang.org/x/tools/...
	#go get -v github.com/cespare/reflex
	#go get -v github.com/urfave/negroni
	#go get -v github.com/gorilla/mux
	#go get -v github.com/dgrijalva/jwt-go
	#go get -v golang.org/x/mobile/cmd/gomobile
	#go get -v github.com/boltdb/bolt
	#go get -v github.com/google/gopacket
	#go get -v github.com/lib/pq
	#go get -v gopkg.in/mgo.v2
	#go get -c golang.org/x/crypto/blowfish
	#go get -v golang.org/x/crypto/bcrypt
	#go get -v github.com/gorilla/context
	##vs-code/go dependencies
	#go get -v github.com/uudashr/gopkgs/cmd/gopkgs
	#go get -v github.com/rogpeppe/godef
	#go get -v github.com/ramya-rao-a/go-outline
	#go get -v sourcegraph.com/sqs/goreturns
	#go get -v github.com/nsf/gocode
	#go get -u -t gonum.org/v1/gonum/...
	#go get -u -t gonum.org/v1/plot/...
	#go get -u github.com/wcharczuk/go-chart

	#go get -v  github.com/acroca/go-symbols
	#go get -v github.com/golang/lint/golint
	#go get -v github.com/derekparker/delve/cmd/dlv
}

## ARM Dev tools
function arm_dev_tools() {
	# use gcc-arm-non-eabi-bin from AUR
	$PACMAN arm-none-eabi-binutils arm-none-eabi-gcc arm-none-eabi-gdb
}

## Android dev-tools
function android_dev_tools() {
	$PACMAN gradle
	$PACMAN android-udev
	$PACMAN android-tools
	#For compiling Android build
	#$PACMAN gcc-multilib
	#$PACMAN lib32-zlib lib32-ncurses lib32-readline
	#$PACMAN uboot-tools
}

## Dart dev-tools
function dart_dev_tools() {
	$PACMAN dart
	#pub global activate stagehand
}

## Java dev-tools
function java_dev_tools() {
	$PACMAN jdk10-openjdk
	$PACMAN icedtea-web
	#$PACMAN jre8-openjdk
}

## JS/NPM dev-tools
function js_dev_tools() {
	$PACMAN npm
}

## Python dev-tools
function python_dev_tools() {
	$PACMAN python python-docs
	$PACMAN python-pymongo
	$PACMAN python-pip python-virtualenv python-setuptools 
	$PACMAN python-mccabe python-pyflakes flake8
	$PACMAN python-jedi
	$PACMAN python-pylint
}

## Archlinux dev-tools
function archlinux_dev_tools() {
	$PACMAN devtools
	$PACMAN arch-install-scripts
}

## Multimedia
function multimedia() {
	$PACMAN gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav
	$PACMAN dvd+rw-tools
}

## Ebooks tools
function ebook_tools() {
	$PACMAN calibre 
}

## Office suite
function office_suite() {
	$PACMAN libreoffice-fresh
	$PACMAN hunspell hunspell-en 
	$PACMAN simple-scan
}

## Editors
function editors() {
	$PACMAN aspell aspell-en
	$PACMAN vim
	$PACMAN emacs emacs-python-mode
	$PACMAN markdown
}

## Graphic utils
function graphic_utils() {
	$PACMAN gimp
	$PACMAN inkscape
	$PACMAN graphviz
}

## Databases
function databases() {
	$PACMAN sqlite
	$PACMAN mongodb mongodb-tools
}

## Servers
function servers() {
	$PACMAN openssh sshpass openssl openvpn 
	$PACMAN openvpn 
	$PACMAN apache 
	$PACMAN mod_wsgi
	$PACMAN docker docker-compose
}

## Browsers
function browsers() {
	$PACMAN chromium
	$PACMAN firefox
	$PACMAN thunderbird
	$PACMAN flashplugin 
}

## Fonts
function fonts() {
	$PACMAN ttf-liberation 
	$PACMAN ttf-indic-otf 
	$PACMAN ttf-hanazono
}

## Virtualization
function virtualization() {
	$PACMAN qemu 
	#$PACMAN virtualbox
}

## GNOME desktop
function gnome_desktop() {
	$PACMAN gnome
	$PACMAN gnome-tweaks chrome-gnome-shell
	#$PACMAN gnome-extra
	$PACMAN evolution
	$PACMAN gnome-sound-recorder
	$PACMAN media-player-info rhythmbox
	$PACMAN vinagre
	$PACMAN transmission-gtk
	$PACMAN giggle
	$PACMAN wireshark-gtk

	#GnomeSoftware support for ArchLinux
	$PACMAN gnome-software-packagekit-plugin

	systemctl enable gdm
}

## KDE desktop
function kde_desktop() {
	$PACMAN phonon-qt5-gstreamer
	$PACMAN plasma-wayland-session plasma-meta
	#$PACMAN kde-applications-meta
	#$PACMAN kdeaccessibility-meta
	$PACMAN kdeadmin-meta
	$PACMAN kdebase-meta
	#$PACMAN kdeedu-meta
	#$PACMAN kdegames-meta
	$PACMAN kdegraphics-meta
	$PACMAN kdemultimedia-meta
	$PACMAN kdenetwork-meta
	#$PACMAN kdepim-meta
	#$PACMAN kdesdk-meta
	$PACMAN kdeutils-meta
	#$PACMAN kdewebdev-meta

	$PACMAN calibre

	systemctl enable sddm
}

## NodeJS
function nodejs_installs() {
	$PACMAN nodejs
	$PACMAN npm	
}

## ScientificComputing
function scientific_computing() {
        #$PACMAN octave
    
    	## Python machine-learing
	$PACMAN python-numpy
	$PACMAN python-scipy
	$PACMAN python-pandas
	$PACMAN python-matplotlib
	$PACMAN python-tensorflow

}

## systemd services
function systemd_services() {
	systemctl enable acpid
	systemctl enable cronie
	systemctl enable NetworkManager
	systemctl enable ufw
	systemctl enable sshd
	#systemctl enable httpd
	#systemctl enable org.cups.cupsd
}

function install_all_modules() {
	base
	console_tools
	network_tools
	wayland
	xorg
	scm
	printing
	dev_tools
	java_dev_tools
	android_dev_tools
	#arm_dev_tools
	dart_dev_tools
	js_dev_tools
	python_dev_tools
	archlinux_dev_tools
	multimedia
	#ebook_tools
	office_suite
	editors
	graphic_utils
	databases
	servers
	browsers
	fonts
	virtualization
	#gnome_desktop
	kde_desktop
	scientific_computing
	systemd_services
}

function install_modules_usb_install_media() {
	base
	console_tools
	network_tools
	xorg
	archlinux_dev_tools
}

pacman -Syu
install_all_modules 2>&1 | tee archlinux-postinstall-stage02.log

##remove un-necessary packages (dependencies that are no longer needed)
#pacman -Rs $(pacman -Qqtd)

