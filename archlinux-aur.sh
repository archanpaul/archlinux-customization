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
    $AURGET_CMD repo
    $AURGET_CMD android-sdk
    $AURGET_CMD android-studio
    $AURGET_CMD android-ndk
}

function printing_packages() {
    $AURGET_CMD hplip-plugin
}

function browser_packages() {
    $AURGET_CMD google-chrome
    $AURGET_CMD google-talkplugin
}

function font_packages() {
    $PACMAN_UNINSTALL_CMD ttf-droid
    $PACMAN_UNINSTALL_CMD ttf-oxygen
    $AURGET_CMD ttf-google-fonts-git
}

function java_packages() {
    # Oracle jdk
    $AURGET_CMD jdk
    sudo archlinux-java set java-8-jdk
}

function javascript_packages() {
    $AURGET_CMD nodejs-npm2arch
    $AURGET_CMD nodejs-bower
}

function go_packages() {
    $AURGET_CMD gocode-git
}

function cordova_packages() {
    mkdir $CDIR/cordova
    cd $CDIR/cordova/ && npm2PKGBUILD cordova > PKGBUILD
    cd $CDIR/cordova/ && makepkg
    cd $CDIR/cordova/ && pacman --noconfirm -U nodejs-cordova-*.pkg.tar.xz
    cd $CDIR
}

function debian_packages() {
    # debootstrap
    $AURGET_CMD debootstrap
    $AURGET_CMD debian-archive-keyring
    $AURGET_CMD ubuntu-keyring
    $AURGET_CMD $aurcmd gnupg1
}

function ide_pacakges() {
    $AURGET atom-editor-bin
}

function install_modules() {
    power_management_packages
    android_packages
    printing_packages
    font_packages
    #java_packages
    javascript_packages
    go_packages
    ide_packages
    #browser_packages
    #coredova_packages
    #debian_packages
}

#aurget_install
$AURGET_UPGRADE_CMD 2>&1 | tee archlinux-aur.log
#install_modules 2>&1 | tee archlinux-aur.log

