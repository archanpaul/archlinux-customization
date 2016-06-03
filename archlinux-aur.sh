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

    gpg --keyserver pgp.mit.edu --recv-keys F7E48EDB
    $AURGET_CMD ncurses5-compat-libs
    $AURGET_CMD android-sdk

    $AURGET_CMD android-studio

    $AURGET_CMD libtinfo
    gpg --recv-keys 702353E0F7E48EDB
    $AURGET_CMD ncurses5-compat-libs
    #$AURGET_CMD android-ndk
}

function printing_packages() {
    $AURGET_CMD hplip-plugin
}

function browser_packages() {
    $AURGET_CMD google-chrome
    $AURGET_CMD google-talkplugin
    #$AURGET_CMD google-earth
    $AURGET_CMD chrome-remote-desktop 
}

function font_packages() {
    $PACMAN_UNINSTALL_CMD ttf-droid
    $PACMAN_UNINSTALL_CMD ttf-oxygen
    $PACMAN_UNINSTALL_CMD noto-fonts
    $AURGET_CMD ttf-google-fonts-git
}

function java_packages() {
    # Oracle jdk
    $AURGET_CMD jdk
    sudo archlinux-java set java-8-jdk
}

function javascript_packages() {
    $AURGET_CMD nodejs-npm2arch
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
    ##$PACMAN_CMD debootstrap 
    $AURGET_CMD debian-archive-keyring
    $AURGET_CMD ubuntu-keyring
    gpg --keyserver pgp.mit.edu --recv-keys 2071B08A33BD3F06
    $AURGET_CMD gnupg1
}

function ide_pacakges() {
    $AURGET_CMD atom-editor-bin
}

function network_pacakges() {
    $AURGET_CMD tcptrack
}

function util_pacakges() {
    $AURGET_CMD ms-sys
 
    sudo pacman -S multilib-devel   
    $AURGET_CMD libpng12 lib32-libpng12
    $AURGET_CMD teamviewer
}

function arm_toolchain() {
    gpg --keyserver pgp.mit.edu --recv-keys 79BE3E4300411886
    gpg --keyserver pgp.mit.edu --recv-keys 38DBBDC86092693E
    $AURGET_CMD arm-linux-gnueabihf-linux-api-headers
    $AURGET_CMD arm-linux-gnueabihf-binutils

    gpg --keyserver pgp.mit.edu --recv-keys 25EF0A436C2A4AFF
    $AURGET_CMD arm-linux-gnueabihf-gcc-stage1 arm-linux-gnueabihf-glibc-headers
    $PACMAN_UNINSTALL_CMD arm-linux-gnueabihf-gcc-stage1
    $AURGET_CMD arm-linux-gnueabihf-gcc-stage2

    # compile step
    $AURGET_CMD arm-linux-gnueabihf-glibc
    $PACMAN_UNINSTALL_CMD arm-linux-gnueabihf-gcc-stage2 arm-linux-gnueabihf-glibc-headers
    #install step
    $AURGET_CMD arm-linux-gnueabihf-glibc
    
    $AURGET_CMD arm-linux-gnueabihf-gcc 
}

function install_modules() {
    power_management_packages
    android_packages
    printing_packages
    font_packages
    java_packages
    javascript_packages
    go_packages
    browser_packages
    coredova_packages
    #debian_packages
    network_pacakges
    util_pacakges
    #ide_pacakges
    arm_toolchain
}

aurget_install
install_modules 2>&1 | tee archlinux-aur.log
$AURGET_UPGRADE_CMD 2>&1 | tee archlinux-aur.log

