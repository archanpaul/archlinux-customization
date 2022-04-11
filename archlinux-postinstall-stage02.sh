#!/bin/bash

# It should get reflected in Stage-01 but it does not.
timedatectl set-timezone Asia/Kolkata

#PACMAN="pacman -S --noconfirm --needed --downloadonly "
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
	$PACMAN e2fsprogs ntfsprogs gptfdisk ecryptfs-utils wipe mtpfs 
	$PACMAN dosfstools
	$PACMAN acpi acpid powertop
	$PACMAN hdparm smartmontools
	$PACMAN htop bash-completion
	$PACMAN bc sudo mc links
	$PACMAN ntp 
	$PACMAN minicom screen
	$PACMAN zip unzip p7zip bzip2 unrar lxsplit
	$PACMAN pwgen
	$PACMAN dmidecode
	$PACMAN man-db man-pages
}

## Network tools
function network_tools() {
	$PACMAN nmap ufw whois dnsutils
	$PACMAN lftp rsync wget traceroute
	$PACMAN usb_modeswitch wvdial
	$PACMAN ethtool bridge-utils
	$PACMAN net-tools netctl
	$PACMAN iwd wireless_tools wpa_supplicant
	$PACMAN bluez bluez-utils
	$PACMAN networkmanager 
	$PACMAN wireshark-cli
}

## Xorg
function xorg() {
	$PACMAN xorg-server 
	$PACMAN xorg-server-xwayland
	$PACMAN xorg-server-xephyr
	$PACMAN mesa-libgl
	$PACMAN xf86-video-intel libva-intel-driver 
	$PACMAN xf86-input-evdev xf86-input-synaptics 
	$PACMAN xf86-video-ati 
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
	$PACMAN egl-wayland
	$PACMAN qt5-wayland
	$PACMAN glfw-wayland
	$PACMAN xorg-server-xwayland
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
	#go install golang.org/x/mobile/cmd/gobind
	#go get -v github.com/boltdb/bolt
	#go get -v github.com/google/gopacket
	#go get -v gopkg.in/mgo.v2
	#go get -c golang.org/x/crypto/blowfish
	#go get -v golang.org/x/crypto/bcrypt
	#go get -v github.com/gorilla/context
	#go get github.com/dgraph-io/badger/...
	#go get -u -t gonum.org/v1/gonum/...
	#go get -u github.com/gin-gonic/gin
	#go get -u github.com/gin-gonic/contrib/static
	#go get -u github.com/gin-contrib/gzip

	##vs-code/go dependencies
	#go get -u -v github.com/ramya-rao-a/go-outline
	#go get -u -v github.com/acroca/go-symbols
	#go get -u -v github.com/mdempsky/gocode
	#go get -u -v github.com/rogpeppe/godef
	#go get -u -v golang.org/x/tools/cmd/godoc
	#go get -u -v github.com/zmb3/gogetdoc
	#go get -u -v github.com/golang/lint/golint
	#go get -u -v github.com/fatih/gomodifytags
	#go get -u -v golang.org/x/tools/cmd/gorename
	#go get -u -v sourcegraph.com/sqs/goreturns
	#go get -u -v golang.org/x/tools/cmd/goimports
	#go get -u -v github.com/cweill/gotests/...
	#go get -u -v golang.org/x/tools/cmd/guru
	#go get -u -v github.com/josharian/impl
	#go get -u -v github.com/haya14busa/goplay/cmd/goplay
	#go get -u -v github.com/uudashr/gopkgs/cmd/gopkgs
	#go get -u -v github.com/davidrjenni/reftools/cmd/fillstruct
	#go get -u -v github.com/alecthomas/gometalinter
	#gometalinter --install
	#go get -u github.com/derekparker/delve/cmd/dlv

	#go get -u all
	#go build -a ./...
	#go install -a ./...
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
	#pub global activate webdev
}

## Java dev-tools
function java_dev_tools() {
	$PACMAN jdk-openjdk
	#$PACMAN icedtea-web
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

## Office suite
function office_suite() {
	$PACMAN libreoffice-fresh
	$PACMAN hunspell hunspell-en_US
	$PACMAN simple-scan
}

## Editors
function editors() {
	$PACMAN aspell aspell-en
	$PACMAN vi vim
	# $PACMAN emacs emacs-python-mode
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
	#$PACMAN mongodb mongodb-tools
	#$PACMAN couchdb
}

## Servers
function servers() {
	$PACMAN openssh sshpass openssl openvpn 
	$PACMAN openvpn 
	$PACMAN apache 
	$PACMAN docker docker-compose
}

## Browsers
function browsers() {
	$PACMAN chromium
	$PACMAN firefox
	$PACMAN thunderbird
	$PACMAN youtube-dl
}

## Fonts
function fonts() {
	$PACMAN ttf-liberation 
	$PACMAN ttf-indic-otf 
	$PACMAN ttf-hanazono
	$PACMAN ttf-roboto
	$PACMAN ttf-roboto-mono
}

## Virtualization
function virtualization() {
	$PACMAN qemu 
	# $PACMAN virtualbox virtualbox-host-modules-arch
}

## GNOME desktop
function gnome_desktop() {
	$PACMAN gnome
	$PACMAN gnome-tweaks
	#$PACMAN gnome-extra
	$PACMAN evolution
	$PACMAN gnome-sound-recorder celluloid
	$PACMAN media-player-info rhythmbox
	$PACMAN vinagre
	$PACMAN transmission-gtk
	$PACMAN giggle foliate
	$PACMAN dconf-editor

	#GnomeSoftware support for ArchLinux
	$PACMAN gnome-software-packagekit-plugin

	systemctl enable gdm
}

## KDE desktop
function kde_desktop() {
	$PACMAN phonon-qt5-gstreamer

	$PACMAN plasma-wayland-session plasma-meta
	# dbus-run-session startplasma-wayland
	$PACMAN kwayland kwayland-integration

	# $PACMAN kde-accessibility-meta
	# $PACMAN kde-applications-meta
	# $PACMAN kde-education-meta
	# $PACMAN kde-games-meta
	$PACMAN kde-graphics-meta
	$PACMAN kde-multimedia-meta
	$PACMAN kde-network-meta
	# $PACMAN kde-pim-meta
	# $PACMAN kde-sdk-meta
	$PACMAN kde-system-meta
	$PACMAN kde-utilities-meta
	$PACMAN kdevelop-meta
	$PACMAN plasma-meta
	$PACMAN telepathy-kde-meta 
	# $PACMAN kde-development-environment-meta

	$PACMAN ktorrent
	$PACMAN calibre

	$PACMAN breeze-gtk kde-gtk-config

	# systemctl enable sddm
}

## ScientificComputing
function scientific_computing() {
        # $PACMAN octave
    
    	## Python machine-learing
	$PACMAN python-numpy
	$PACMAN python-scipy
	$PACMAN python-pandas
	$PACMAN python-matplotlib
	$PACMAN python-tensorflow
	$PACMAN python-opencv
}

## systemd services
function systemd_services() {
	systemctl enable acpid
	systemctl enable cronie
	#systemctl enable bluetooth
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
	gnome_desktop
	# kde_desktop
	scm
	printing
	dev_tools
	java_dev_tools
	android_dev_tools
	arm_dev_tools
	dart_dev_tools
	js_dev_tools
	python_dev_tools
	archlinux_dev_tools
	multimedia
	office_suite
	editors
	graphic_utils
	databases
	servers
	browsers
	fonts
	virtualization
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

