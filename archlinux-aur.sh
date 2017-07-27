# AUR packages install

PACMAN_CMD="pacman -U --noconfirm --needed "
PACMAN_UNINSTALL_CMD="pacman -Rn --noconfirm "
AURGET_CMD="aurget -Sy --noedit --nodiscard --noconfirm "
AURGET_UPGRADE_CMD="aurget -Syu --noedit --nodiscard --noconfirm "

CDIR=`pwd`

function aurget_install() {
    rm -rf $CDIR/aurget*
    curl https://aur.archlinux.org/cgit/aur.git/snapshot/aurget.tar.gz | tar zxv
    cd $CDIR/aurget && makepkg
    cd $CDIR/aurget && sudo $PACMAN_CMD aurget-*.xz
    cd $CDIR
}

function power_management_packages() {
    $AURGET_CMD laptop-mode-tools
    sudo systemctl enable laptop-mode
    sudo systemctl restart laptop-mode
}

function android_packages() {
    #$AURGET_CMD android-sdk
    $AURGET_CMD android-studio
    $AURGET_CMD glxinfo

    gpg --keyserver pgp.mit.edu --recv-keys 702353E0F7E48EDB
    $AURGET_CMD ncurses5-compat-libs
    #$AURGET_CMD android-ndk
}

function printing_packages() {
    $AURGET_CMD hplip-plugin
}

function browser_packages() {
    $AURGET_CMD google-chrome
    #$AURGET_CMD google-talkplugin
    #$AURGET_CMD chrome-remote-desktop
}

function font_packages() {
    #$PACMAN_UNINSTALL_CMD ttf-droid
    #$PACMAN_UNINSTALL_CMD ttf-oxygen
    #$PACMAN_UNINSTALL_CMD noto-fonts
    $AURGET_CMD ttf-google-fonts-git
}

function java_packages() {
    # Oracle jdk
    $AURGET_CMD jdk
    sudo archlinux-java set java-8-jdk
}

function go_packages() {
    $AURGET_CMD gocode-git
    $AURGET_CMD go-gpm
}

function server_packages() {
    $AURGET_CMD nsq
}

function gtk_themes() {
    $AURGET_CMD gtk-theme-arc
}

function debian_packages() {
    # debootstrap
    ##$PACMAN_CMD debootstrap
    $AURGET_CMD debian-archive-keyring
    $AURGET_CMD ubuntu-keyring
    gpg --keyserver pgp.mit.edu --recv-keys 2071B08A33BD3F06
    $AURGET_CMD gnupg1
}

function ide_pacakges() {
    $AURGET_CMD global
    $AURGET_CMD rtags-git
    $AURGET_CMD atom-editor-bin
    #apm install autocomplete-clang build build-make linter linter-clang linter-gcc atomic-rtags file-icons synced-sidebar rest-client dartlang linter-flake8 go-debug go-signature-statusbar
    $AURGET_CMD visual-studio-code
}

function network_pacakges() {
    $AURGET_CMD tcptrack
}

function util_pacakges() {
    $AURGET_CMD ms-sys
}

function swift_packages() {
    $AURGET_CMD libblocksruntime
    $PACMAN_UNINSTALL_CMD lldb
    $AURGET_CMD swift
    $PACMAN_UNINSTALL_CMD swift-lldb
    $PACMAN_CMD lldb
}

function arm_packages() {
    $AURGET_CMD gnuarmeclipse-qemu-git
    $PACMAN_CMD ninja

    $PACMAN_CMD arm-none-eabi-binutils arm-none-eabi-gcc
    $AURGET_CMD gcc-arm-none-eabi-bin
}

function tor_packages() {
    gpg --keyserver pgp.mit.edu --recv-keys D1483FA6C3C07136
    $AURGET_CMD orion tor-browser
}

function uml_packages() {
	$PACMAN_CMD plantuml
}

function install_modules() {
    aurget_install
    power_management_packages
    android_packages
    printing_packages
    #font_packages
    #java_packages
    go_packages
    #server_packages
    #browser_packages
    debian_packages
    network_pacakges
    util_pacakges
    ide_pacakges
    arm_packages
    swift_packages
    tor_packages
    uml_packages
}

#aurget_install
#install_modules 2>&1 | tee archlinux-aur.log
$AURGET_UPGRADE_CMD 2>&1 | tee archlinux-aur_upgrade.log
