# AUR packages install

PACMAN_PKG_INSTALL_CMD="pacman -U --noconfirm --needed "
PACMAN_CMD="sudo pacman -S --noconfirm --needed "
AUR_CMD="aurman -S --noedit --noconfirm --needed "
AUR_UPGRADE_CMD="aurman -Syu --noedit --noconfirm --needed "


CDIR=`pwd`

function expac-git_install() {
    $PACMAN_CMD python-regex
    rm -rf $CDIR/expac-git*
    curl https://aur.archlinux.org/cgit/aur.git/snapshot/expac-git.tar.gz | tar zxv
    cd $CDIR/expac-git && makepkg
    cd $CDIR/expac-git && sudo $PACMAN_PKG_INSTALL_CMD expac-git-*.xz
    cd $CDIR
}

function aurman_install() {
    expac-git_install
    rm -rf $CDIR/aurman*
    curl https://aur.archlinux.org/cgit/aur.git/snapshot/aurman.tar.gz | tar zxv
    cd $CDIR/aurman && makepkg
    cd $CDIR/aurman && sudo $PACMAN_PKG_INSTALL_CMD aurman-*.xz
    cd $CDIR
}

function power_management_packages() {
    $AUR_CMD laptop-mode-tools
    sudo systemctl enable laptop-mode
    sudo systemctl restart laptop-mode
}

function android_packages() {
    $AUR_CMD android-studio
}

function ide_pacakges() {
    $AUR_CMD visual-studio-code-bin
    #code --install-extension Dart-Code.dart-code
    #code --install-extension PKief.material-icon-theme
    #code --install-extension donjayamanne.githistory
    #code --install-extension formulahendry.code-runner
    #code --install-extension joshpeng.theme-charcoal-oceanicnext
    #code --install-extension lukehoban.Go
    #code --install-extension ms-python.python
    #code --install-extension ms-vscode-devlab.vscode-mongodb
    #code --install-extension ms-vscode.cpptools
    #code --install-extension msjsdiag.debugger-for-chrome
}

function printutil_packages() {
    $AUR_CMD hplip-plugin
}

function arm_packages() {
    $AUR_CMD gcc-arm-none-eabi-bin
}

function db_packages() {
    $AUR_CMD mongodb-compass
}

function install_modules() {
    #aurman_install
    power_management_packages
    android_packages
    ide_pacakges
    printutil_packages
    arm_packages
    db_packages
}

install_modules 2>&1 | tee archlinux-aur.log
$AUR_UPGRADE_CMD 2>&1 | tee archlinux-aur_upgrade.log
