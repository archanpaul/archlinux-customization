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
    $AURGET_CMD android-studio
}

function printing_packages() {
    $AURGET_CMD hplip-plugin
}

function font_packages() {
    #$PACMAN_UNINSTALL_CMD ttf-droid
    #$PACMAN_UNINSTALL_CMD ttf-oxygen
    #$PACMAN_UNINSTALL_CMD noto-fonts
    $AURGET_CMD ttf-google-fonts-git
}

function ide_pacakges() {
    $AURGET_CMD visual-studio-code
}

function network_pacakges() {
    $AURGET_CMD tcptrack
}

function util_pacakges() {
    $AURGET_CMD ms-sys
    $PACMAN_CMD pkgfile
    $AURGET_CMD debtap
}

function arm_packages() {
    $AURGET_CMD gcc-arm-none-eabi-bin
}

function tor_packages() {
    gpg --recv-keys --keyserver hkp://pgp.mit.edu D1483FA6C3C07136
    $AURGET_CMD tor-browser
}

function install_modules() {
    aurget_install
    power_management_packages
    android_packages
    printing_packages
    #font_packages
    network_pacakges
    util_pacakges
    ide_pacakges
    arm_packages
    tor_packages
}

#aurget_install
#install_modules 2>&1 | tee archlinux-aur.log
$AURGET_UPGRADE_CMD 2>&1 | tee archlinux-aur_upgrade.log
