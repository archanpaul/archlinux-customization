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

    gpg --keyserver pgp.mit.edu --recv-keys 702353E0F7E48EDB
    $AURGET_CMD ncurses5-compat-libs
    $AURGET_CMD android-ndk
}

function printing_packages() {
    $AURGET_CMD hplip-plugin
}

function browser_packages() {
    $AURGET_CMD google-chrome
    $AURGET_CMD google-talkplugin
    $AURGET_CMD chrome-remote-desktop 
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

function swift_packages() {
    $AURGET_CMD libkqueue
    $AURGET_CMD icu55
    gpg --recv-keys --keyserver hkp://pgp.mit.edu 63BC1CFE91D306C6
    $AURGET_CMD swift-bin
}

function javascript_packages() {
    $AURGET_CMD nodejs-npm2arch
    $AURGET_CMD nodejs-tern
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
    $AURGET_CMD atom-editor-bin
    echo "apm install linter git-plus rest-client atom-beautify file-icons dartlang atom-toolbar synced-sidebar go-plus hyperclick go-debug go-signature-statusbar oceanic-next nomnoml-preview"
    echo "go get golang.org/x/tools/cmd/cover"
}

function network_pacakges() {
    $AURGET_CMD tcptrack
}

function util_pacakges() {
    $AURGET_CMD ms-sys
}

function arm_packages() {
    $AURGET_CMD gnuarmeclipse-qemu-bin
    sudo pacman -S ninja

    pacman -Rn arm-none-eabi-binutils arm-none-eabi-gcc
    $AURGET_CMD gcc-arm-none-eabi-bin
}

function remote_desktop_pacakges() {
    sudo pacman -S multilib-devel   
    $AURGET_CMD libpng12 lib32-libpng12
    $AURGET_CMD lib32-libjpeg6-turbo
    $AURGET_CMD teamviewer
}

function install_modules() {
    power_management_packages
    android_packages
    printing_packages
    font_packages
    #java_packages
    #swift_packages
    javascript_packages
    go_packages
    #server_packages
    #browser_packages
    #debian_packages
    network_pacakges
    #util_pacakges
    ide_pacakges
    arm_packages
    #remote_desktop_pacakges
}

aurget_install
install_modules 2>&1 | tee archlinux-aur.log
$AURGET_UPGRADE_CMD 2>&1 | tee archlinux-aur_upgrade.log

