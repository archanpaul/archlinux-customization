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
    gpg --keyserver pgp.mit.edu --recv-keys F7E48EDB
    $AURGET_CMD ncurses5-compat-libs
    $AURGET_CMD android-sdk

    $AURGET_CMD android-studio

    $AURGET_CMD libtinfo
    gpg --recv-keys 702353E0F7E48EDB
    $AURGET_CMD ncurses5-compat-libs
    $AURGET_CMD libtinfo5
    #$AURGET_CMD android-ndk
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

function javascript_packages() {
    $AURGET_CMD nodejs-npm2arch
}

function go_packages() {
    $AURGET_CMD gocode-git
    $AURGET_CMD go-gpm

    # go get -u golang.org/x/tools/cmd/...
    # go get -u github.com/golang/lint
    # go get -u github.com/nsf/gocode
    # go get -u github.com/derekparker/delve/cmd/dlv
    # go get -u github.com/cespare/reflex
    # go get -u github.com/zmb3/gogetdoc
    # go get -u github.com/alecthomas/gometalinter

    # go get -u github.com/codegangsta/negroni
    # go get -u github.com/gorilla/mux
    # go get -u github.com/gorilla/context
    # go get -u github.com/dgrijalva/jwt-go
    # go get github.com/boltdb/bolt
}

function server_packages() {
    $AURGET_CMD nsq
}

function gtk_themes() {
    $AURGET_CMD gtk-theme-arc
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
    $AURGET_CMD atom-editor
    echo "apm install autocomplete-go go-config go-get go-imports go-plus go-rename gofmt gometalinter-linter platformio-ide-terminal atom-beautify atom-bootstrap3 auto-detect-indentation autoclose-html color-picker file-type-icons highlight-line highlight-selected linter linter-csslint linter-htmlhint pigments godoc navigator-go tester-go gorename builder-go go-debug file-icons spacegray-dark-ui electron-syntax dartlang atom-toolbar synced-sidebar"
}

function network_pacakges() {
    $AURGET_CMD tcptrack
}

function util_pacakges() {
    $AURGET_CMD ms-sys
}

function remote_desktop_pacakges() {
    sudo pacman -S multilib-devel   
    $AURGET_CMD libpng12 lib32-libpng12
    $AURGET_CMD lib32-libjpeg6-turbo
    $AURGET_CMD teamviewer
}

function install_modules() {
    power_management_packages
    #android_packages
    printing_packages
    #font_packages
    #java_packages
    #javascript_packages
    go_packages
    server_packages
    #browser_packages
    #cordova_packages
    #debian_packages
    network_pacakges
    util_pacakges
    #ide_pacakges
    #remote_desktop_pacakges
}

aurget_install
install_modules 2>&1 | tee archlinux-aur.log
$AURGET_UPGRADE_CMD 2>&1 | tee archlinux-aur_upgrade.log

