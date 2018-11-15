# AUR packages install

CDIR=`pwd`

PACMAN_PKG_INSTALL_CMD="pacman -U --noconfirm --needed "
PACMAN_CMD="sudo pacman -S --noconfirm --needed "
AURMAN_CACHE=$CDIR/aurman-cache
AUR_CMD="aurman -S --noedit --noconfirm --cachedir $AURMAN_CACHE --needed "
AUR_UPGRADE_CMD="aurman -Syu --noedit --noconfirm --cachedir $AURMAN_CACHE --needed "

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
    ln -sf ~/.cache/aurman /home/public/archlinux-repos/archlinux.aur/aurman-cache 
    rm -rf $CDIR/aurman*
    curl https://aur.archlinux.org/cgit/aur.git/snapshot/aurman.tar.gz | tar zxv
    gpg --recv-keys 465022E743D71E39
    cd $CDIR/aurman && makepkg -sci
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
    $AUR_CMD ncurses5-compat-libs
}

function ide_pacakges() {
    $AUR_CMD visual-studio-code-bin
    $PACMAN_CMD  gnome-keyring libsecret
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


function gcloud_packages() {
    $AUR_CMD google-cloud-sdk
}

function install_modules() {
    power_management_packages
    android_packages
    ide_pacakges
    printutil_packages
    arm_packages
    db_packages
    gcloud_packages
}

function install_aur_helpers() {
    aurman_install
}

#install_aur_helpers
#install_modules 2>&1 | tee archlinux-aur.log
$AUR_UPGRADE_CMD 2>&1 | tee archlinux-aur_upgrade.log
