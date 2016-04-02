#!/bin/bash

#PACMAN="pacman -S --noconfirm --needed -w "
PACMAN="pacman -S --noconfirm --needed "

## Base
function base() {
	$PACMAN base grub lsb-release
	$PACMAN dbus systemd systemd-sysvcompat syslog-ng cronie
	$PACMAN linux linux-headers linux-api-headers linux-firmware acpi_call
}

## Console tools
function console_tools() {
	$PACMAN e2fsprogs extundelete ntfsprogs gptfdisk ecryptfs-utils wipe mtpfs 
	$PACMAN dosfstools
	$PACMAN acpi acpid pm-utils powertop
	$PACMAN hdparm smartmontools
	$PACMAN bc sudo mc links
	$PACMAN ntp 
	$PACMAN minicom
	$PACMAN dvd+rw-tools 
	$PACMAN zip unzip p7zip bzip2 unrar lxsplit
}

## Network tools
function network_tools() {
	$PACMAN nmap ufw whois dnsutils
	$PACMAN lftp rsync wget 
	$PACMAN usb_modeswitch wvdial
	$PACMAN ethtool bridge-utils
	$PACMAN net-tools netctl
	$PACMAN rfkill wireless_tools wpa_supplicant wpa_actiond
	$PACMAN bluez bluez-firmware bluez-utils
	$PACMAN networkmanager 
	$PACMAN wireshark-cli
}

## Xorg
function xorg() {
	$PACMAN xorg-server 
	$PACMAN mesa-libgl
	$PACMAN xf86-video-intel intel-dri libva-intel-driver 
	$PACMAN xf86-input-evdev xf86-input-synaptics 
	$PACMAN xf86-video-ati ati-dri
	$PACMAN xterm xorg-xkill xorg-xhost
	$PACMAN xorg-xdm
	$PACMAN xorg-xinit
	$PACMAN xcursor-simpleandsoft
}

## SCM
function scm() {
	$PACMAN git cgit
	$PACMAN subversion bzr mercurial
}

## Printing
function printing() {
	$PACMAN cups ghostscript gsfonts gutenprint foomatic-db foomatic-db-engine foomatic-db-nonfree foomatic-filters cups-pdf hplip splix
	$PACMAN sane 
}

## Dev tools
function dev_tools() {
	$PACMAN base-devel 
	$PACMAN binutils gcc gcc-libs libtool
	#$PACMAN multilib-devel 
	#$PACMAN binutils-multilib gcc-multilib gcc-libs-multilib libtool-multilib
	#$PACMAN gcc-go
	#$PACMAN gcc-go-multilib
	$PACMAN go
	$PACMAN make cmake scons automake autoconf libtool m4 patch pkg-config
	$PACMAN flex bison gperf 
	$PACMAN gdb valgrind
	$PACMAN cppunit gtest
	$PACMAN doxygen
	$PACMAN zlib boost 
	$PACMAN openmpi opencv
}

## Android dev-tools
function android_dev_tools() {
	$PACMAN gradle gradle-doc
	$PACMAN android-udev
	$PACMAN android-tools
	#For compiling Android build
	#$PACMAN gcc-multilib
	$PACMAN lib32-zlib lib32-ncurses lib32-readline
	$PACMAN uboot-tools
}

## Dart dev-tools
function dart_dev_tools() {
	$PACMAN dart
}

## Java dev-tools
function java_dev_tools() {
	# temporary fix
	pacman -S java-environment
	$PACMAN jre8-openjdk
	$PACMAN jdk8-openjdk
	$PACMAN icedtea-web
}

## Python dev-tools
function python_dev_tools() {
	$PACMAN python python-docs
	$PACMAN python-django
	$PACMAN python-pillow
	$PACMAN python-psycopg2 python-pymongo
	$PACMAN python-pip python-virtualenv python-setuptools 
	$PACMAN python-six
	$PACMAN python-docutils
	$PACMAN pep8-python3
	$PACMAN python-mccabe python-pyflakes flake8
	$PACMAN python-jedi
}

## Archlinux dev-tools
function archlinux_dev_tools() {
	$PACMAN devtools
	$PACMAN abs
}

## Multimedia
function multimedia() {
	$PACMAN gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly
	$PACMAN gstreamer0.10 gstreamer0.10-base-plugins gstreamer0.10-good-plugins gstreamer0.10-bad-plugins gstreamer0.10-ugly-plugins
	$PACMAN pulseaudio pulseaudio-alsa 
	$PACMAN alsa-utils
	$PACMAN webrtc-audio-processing
	$PACMAN flac faad2 xvidcore speex x264 opencore-amr ffmpeg
	$PACMAN lame id3
	$PACMAN vlc
	$PACMAN cdrkit
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
	$PACMAN mariadb libmariadbclient mariadb-clients
	$PACMAN mongodb
	$PACMAN postgresql postgresql-docs postgresql-libs
}

## Servers
function servers() {
	$PACMAN openssh sshpass openssl openvpn 
	$PACMAN openvpn 
	$PACMAN apache 
	$PACMAN mod_wsgi
	$PACMAN nodejs
	$PACMAN docker
}

## Documentations 
function documentations() {
	$PACMAN linux-manpages
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

## Localized input-systems
function localized_input_systems() {
	$PACMAN fcitx fcitx-m17n fcitx-mozc
	$PACMAN fcitx-gtk2 fcitx-gtk3 fcitx-qt4 fcitx-qt5
}

## Virtualization
function virtualization() {
	$PACMAN qemu libvirt 
	$PACMAN virtualbox
}

## Generic gtk Themes
function generic_gtk_themes() {
	$PACMAN gtk-engine-murrine 
}

## KDE desktop
function kde_desktop() {
	## Dependency packages for auto selection
	$PACMAN phonon phonon-qt4-gstreamer phonon-qt5-gstreamer
	$PACMAN mesa-libgl libx264

	## If KDE4 installed
	#pacman -Rc kdebase-workspace
	#pacman -Rc kdebase-plasma kdeplasma-applets-plasma-nm kdeplasma-addons-applets-kimpanel

	## KDE5
	$PACMAN plasma-meta plasma-desktop plasma-workspace
	$PACMAN plasma-nm plasma-pa
	$PACMAN sddm sddm-kcm
	### temporary 
	#$PACMAN kde-meta-kdebase

	## KDE packages
	$PACMAN kde-meta-kdebase kde-meta-kdeadmin kde-meta-kdeutils
	$PACMAN kde-meta-kdegraphics kde-meta-kdenetwork
	#$PACMAN kde-meta-multimedia
	$PACMAN konsole kate kio-extras
	#$PACMAN kcm-fcitx
	$PACMAN ktorrent 
	$PACMAN recorditnow
	$PACMAN skanlite
	$PACMAN avidemux-qt
	$PACMAN cdrdao k3b 
	$PACMAN amarok 
	#$PACMAN digikam
	$PACMAN kde-gtk-config
	$PACMAN kmplot
	$PACMAN wireshark-qt
	$PACMAN kdenetwork-krdc freerdp
}

## KDE dev
function kde_dev() {
	$PACMAN kde-meta-kdesdk
}

## QT dev
function qt_dev() {
	$PACMAN qt5 qtcreator
	$PACMAN qgit
	$PACMAN sqlitebrowser
}

## Lib32 apps
function lib32_apps() {
	$PACMAN lib32-harfbuzz
	$PACMAN skype
	#dependency to show QT4 notification in plasma5
	$PACMAN lib32-sni-qt
}

## systemd services
function systemd_services() {
	systemctl enable syslog-ng
	systemctl enable acpid
	systemctl enable cronie
	systemctl enable sddm
	systemctl enable NetworkManager
	#systemctl enable ufw
	#systemctl enable sshd
	#systemctl enable httpd
	#systemctl enable org.cups.cupsd
}

## NodeJS
function nodejs_installs() {
	$PACMAN npm	
}

function install_all_modules() {
	base
	console_tools
	network_tools
	xorg
	scm
	printing
	dev_tools
	java_dev_tools
	android_dev_tools
	dart_dev_tools
	python_dev_tools
	archlinux_dev_tools
	multimedia
	ebook_tools
	office_suite
	editors
	graphic_utils
	databases
	servers
	documentations
	browsers
	fonts
	#localized_input_systems
	virtualization
	generic_gtk_themes
	kde_desktop
	#kde_dev
	qt_dev
	lib32_apps
	systemd_services
}

pacman -Syu
install_all_modules 2>&1 | tee archlinux-postinstall-stage02.log

##remove un-necessary packages (dependencies that are no longer needed)
#pacman -Rs $(pacman -Qqtd)


