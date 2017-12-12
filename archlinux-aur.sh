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

function ide_pacakges() {
    $AURGET_CMD visual-studio-code
}

function printutil_packages() {
    $AURGET_CMD hplip-plugin
}

function arm_packages() {
    $AURGET_CMD gcc-arm-none-eabi-bin
}

function install_modules() {
    aurget_install
    power_management_packages
    android_packages
    ide_pacakges
    printutil_packages
    arm_packages
}

#aurget_install
#install_modules 2>&1 | tee archlinux-aur.log
$AURGET_UPGRADE_CMD 2>&1 | tee archlinux-aur_upgrade.log
