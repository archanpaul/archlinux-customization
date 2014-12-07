#!/bin/bash

## Base
function base() {
	pacman -S --noconfirm base grub lsb-release
	pacman -S --noconfirm dbus systemd systemd-sysvcompat syslog-ng cronie
	pacman -S --noconfirm linux linux-headers linux-api-headers linux-firmware acpi_call
	pacman -S --noconfirm linux-lts linux-lts-headers acpi_call-lts
}

## Console tools
function console_tools() {
	pacman -S --noconfirm e2fsprogs extundelete ntfsprogs gptfdisk ecryptfs-utils wipe mtpfs 
	pacman -S --noconfirm dosfstools
	pacman -S --noconfirm acpi acpid pm-utils powertop
	pacman -S --noconfirm hdparm smartmontools
	pacman -S --noconfirm bc sudo mc links
	pacman -S --noconfirm ntp 
	pacman -S --noconfirm minicom
	pacman -S --noconfirm dvd+rw-tools 
	pacman -S --noconfirm zip unzip p7zip bzip2 unrar lxsplit
}

## Network tools
function network_tools() {
	pacman -S --noconfirm nmap ufw whois dnsutils
	pacman -S --noconfirm lftp rsync wget 
	pacman -S --noconfirm usb_modeswitch wvdial
	pacman -S --noconfirm ethtool bridge-utils
	pacman -S --noconfirm net-tools netctl
	pacman -S --noconfirm rfkill wireless_tools wpa_supplicant wpa_actiond
	pacman -S --noconfirm bluez bluez-firmware bluez-utils
	pacman -S --noconfirm networkmanager 
}

## Xorg
function xorg() {
	pacman -S --noconfirm xorg-server 
	pacman -S --noconfirm xf86-video-intel intel-dri libva-intel-driver 
	pacman -S --noconfirm xf86-input-evdev xf86-input-synaptics 
	pacman -S --noconfirm xf86-video-ati ati-dri
	pacman -S --noconfirm xterm xorg-xkill xorg-xhost
	pacman -S --noconfirm xorg-xdm
	pacman -S --noconfirm xcursor-simpleandsoft
}

## SCM
function scm() {
	pacman -S --noconfirm git cgit
	pacman -S --noconfirm subversion bzr mercurial
}

## Printing
function printing() {
	pacman -S --noconfirm cups ghostscript gsfonts gutenprint foomatic-db foomatic-db-engine foomatic-db-nonfree foomatic-filters cups-pdf hplip splix
	pacman -S --noconfirm sane 
}

## Dev tools
function dev_tools() {
	pacman -S --noconfirm base-devel 
	pacman -S --noconfirm binutils gcc gcc-libs libtool
	#pacman -S --noconfirm multilib-devel 
	#pacman -S --noconfirm binutils-multilib gcc-multilib gcc-libs-multilib libtool-multilib
	pacman -S --noconfirm make cmake scons automake autoconf libtool m4 patch pkg-config
	pacman -S --noconfirm flex bison gperf 
	pacman -S --noconfirm gdb valgrind
	pacman -S --noconfirm cppunit gtest
	pacman -S --noconfirm doxygen
	pacman -S --noconfirm zlib boost 
	pacman -S --noconfirm openmpi opencv
}

## Android dev-tools
function android_dev_tools() {
	pacman -S --noconfirm android-udev
	pacman -S --noconfirm android-tools
	#For compiling Android build
	#pacman -S --noconfirm gcc-multilib
	pacman -S --noconfirm lib32-zlib lib32-ncurses lib32-readline
	pacman -S --noconfirm uboot-tools
}

## Dart dev-tools
function dart_dev_tools() {
	pacman -S --noconfirm dart
}

## Java dev-tools
function java_dev_tools() {
	pacman -S --noconfirm jre8-openjdk
	pacman -S --noconfirm jdk8-openjdk
	pacman -S --noconfirm icedtea-web
}

## Python dev-tools
function python_dev_tools() {
	pacman -S --noconfirm python python-docs
	pacman -S --noconfirm python-django
	pacman -S --noconfirm python-south
	pacman -S --noconfirm python-pillow
	pacman -S --noconfirm python-psycopg2 python-pymongo
	pacman -S --noconfirm python-pip python-virtualenv python-setuptools 
	pacman -S --noconfirm python-six
	pacman -S --noconfirm python-docutils
	pacman -S --noconfirm pep8-python3
	pacman -S --noconfirm python-mccabe python-pyflakes flake8
	pacman -S --noconfirm python-jedi
}

## Archlinux dev-tools
function archlinux_dev_tools() {
	pacman -S --noconfirm devtools
	pacman -S --noconfirm abs
}

## Multimedia
function multimedia() {
	pacman -S --noconfirm gst-plugins-base gst-plugins-good gst-plugins-bad	gst-plugins-ugly
	pacman -S --noconfirm gstreamer0.10 gstreamer0.10-base-plugins gstreamer0.10-good-plugins gstreamer0.10-bad-plugins gstreamer0.10-ugly-plugins
	pacman -S --noconfirm pulseaudio pulseaudio-alsa 
	pacman -S --noconfirm webrtc-audio-processing
	pacman -S --noconfirm flac faad2 xvidcore speex x264 opencore-amr ffmpeg
	pacman -S --noconfirm lame id3
	pacman -S --noconfirm vlc
	pacman -S --noconfirm cdrkit
}

## Ebooks tools
function ebook_tools() {
	pacman -S --noconfirm calibre 
}

## Office suite
function office_suite() {
	pacman -S --noconfirm libreoffice-fresh
	#pacman -S --noconfirm libreoffice-en-US libreoffice-writer libreoffice-calc libreoffice-draw libreoffice-impress libreoffice-math libreoffice-base
	pacman -S --noconfirm hunspell hunspell-en 
	pacman -S --noconfirm simple-scan
}

## Editors
function editors() {
	pacman -S --noconfirm aspell aspell-en
	pacman -S --noconfirm vim
	pacman -S --noconfirm emacs emacs-python-mode
}

## Graphic utils
function graphic_utils() {
	pacman -S --noconfirm gimp
	pacman -S --noconfirm inkscape
}

## Databases
function databases() {
	pacman -S --noconfirm sqlite
	pacman -S --noconfirm mariadb libmariadbclient mariadb-clients
	pacman -S --noconfirm postgresql postgresql-docs postgresql-libs
	pacman -S --noconfirm mongodb
}

## Servers
function servers() {
	pacman -S --noconfirm openssh sshpass openssl openvpn 
	pacman -S --noconfirm openvpn 
	pacman -S --noconfirm apache 
	pacman -S --noconfirm mod_wsgi
	pacman -S --noconfirm nodejs
}

## Documentations 
function documentations() {
	pacman -S --noconfirm linux-manpages
}

## Browsers
function browsers() {
	pacman -S --noconfirm chromium
	pacman -S --noconfirm firefox
	pacman -S --noconfirm thunderbird
	pacman -S --noconfirm flashplugin 
}

## Fonts
function fonts() {
	pacman -S --noconfirm ttf-liberation 
	pacman -S --noconfirm ttf-indic-otf 
	pacman -S --noconfirm ttf-hanazono
	pacman -S --noconfirm ttf-droid
}

## Localized input-systems
function localized_input_systems() {
	pacman -S --noconfirm fcitx fcitx-m17n fcitx-mozc
	pacman -S --noconfirm fcitx-gtk2 fcitx-gtk3
}

## Virtualization
function virtualization() {
	pacman -S --noconfirm qemu libvirt 
}

## Generic gtk Themes
function generic_gtk_themes() {
	pacman -S --noconfirm qtcurve-gtk2
	pacman -S --noconfirm oxygen-gtk2 oxygen-gtk3 
}

## KDE desktop
function kde_desktop() {
	pacman -S --noconfirm kde-meta-kdeadmin kde-meta-kdebase kde-meta-kdegraphics kde-meta-kdemultimedia kde-meta-kdenetwork kde-meta-kdeutils
	pacman -S --noconfirm kdeplasma-applets-plasma-nm
	pacman -S --noconfirm kdeplasma-addons-applets-kimpanel
	pacman -S --noconfirm kwebkitpart
	pacman -S --noconfirm kdesdk-kate
	pacman -S --noconfirm bluedevil
	pacman -S --noconfirm kcm-touchpad
	pacman -S --noconfirm kcm-fcitx
	pacman -S --noconfirm phonon phonon-qt4-gstreamer phonon-qt5-gstreamer
	pacman -S --noconfirm ktorrent 
	pacman -S --noconfirm recorditnow
	pacman -S --noconfirm skanlite
	pacman -S --noconfirm avidemux-qt
	pacman -S --noconfirm k3b amarok 
	#pacman -S --noconfirm digikam
	pacman -S --noconfirm libreoffice-kde4
	#pacman -S --noconfirm calligra-meta
	pacman -S --noconfirm qtcurve-qt4 qtcurve-qt5 qtcurve-kde4 qtcurve-utils
	pacman -S --noconfirm kde-gtk-config
	pacman -S --noconfirm kdeedu-kmplot kdeedu-kalgebra
}

## KDE dev
function kde_dev() {
	pacman -S --noconfirm kdevelop kdevelop-python
}

## QT dev
function qt_dev() {
	pacman -S --noconfirm qt5 qtcreator
	pacman -S --noconfirm qgit
	pacman -S --noconfirm sqlitebrowser
}

## Lib32 apps
#function lib32_apps() {
#	pacman -S --noconfirm skype
#}

## systemd services
function systemd_services() {
	systemctl enable syslog-ng
	systemctl enable acpid
	systemctl enable cronie
	systemctl enable kdm
	systemctl enable NetworkManager
	#systemctl enable ufw
	#systemctl enable sshd
	#systemctl enable httpd
	#systemctl enable cupsd
}

function install_all_modules() {
	base
	console_tools
	network_tools
	xorg
	scm
	printing
	dev_tools
	android_dev_tools
	dart_dev_tools
	java_dev_tools
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
	localized_input_systems
	virtualization
	generic_gtk_themes
	kde_desktop
	qt_dev
	kde_dev
	#lib32_apps
	systemd_services
}

pacman -Syu
install_all_modules 2>&1 | tee archlinux-postinstall-stage02.log

##remove un-necessary packages (dependencies that are no longer needed)
#pacman -Rs $(pacman -Qqtd)


