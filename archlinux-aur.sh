# AUR packages install

CDIR=`pwd`

PACMAN_PKG_INSTALL_CMD="pacman -U --noconfirm --needed "
PACMAN_CMD="sudo pacman -S --noconfirm --needed "
AUR_CMD="yay -Sy --noconfirm --needed "
AUR_UPGRADE_CMD="aurman -Syu --noedit --noconfirm --cachedir $AURMAN_CACHE --needed "

function yay_install() {
    rm -rf $CDIR/yay*
    git clone https://aur.archlinux.org/yay.git
    cd $CDIR/yay && makepkg -sci
    cd $CDIR/yay && sudo $PACMAN_PKG_INSTALL_CMD yay-*.xz
    cd $CDIR
}

function power_management_packages() {
    $AUR_CMD laptop-mode-tools
    #sudo systemctl enable laptop-mode
    #sudo systemctl restart laptop-mode
}

function android_packages() {
    $AUR_CMD android-studio
    $AUR_CMD ncurses5-compat-libs
    
    sudo mkdir /opt/android-sdk
    sudo chown -R root:wheel /opt/android-sdk
    sudo chmod -R u+rwX,go+rwX,o-w /opt/android-sdk

    cat <<EOF | sudo tee /etc/profile.d/android-sdk.sh
export ANDROID_HOME=/opt/android-sdk/
export ANDROID_SDK_ROOT=\$ANDROID_HOME
export ANDROID_NDK_ROOT=\$ANDROID_HOME/ndk-bundle
export PATH=\$PATH:\$ANDROID_HOME/platform-tools/
EOF

    source /etc/profile.d/android-sdk.sh
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
    $AUR_CMD mongodb
    $AUR_CMD mongodb-compass
}


function gcloud_packages() {
    $AUR_CMD google-cloud-sdk
}

function browser_packages() {
    $AUR_CMD tor-browser-en
}

function go_packages() {
    sudo rm -rf /opt/go-packages
    sudo mkdir /opt/go-packages

    sudo chown -R root:wheel /opt/go-packages
    sudo chmod -R u+rwX,go+rwX,o-w /opt/go-packages

    cat <<EOF | sudo tee /etc/profile.d/go-packages.sh
export GOPATH=/opt/go-packages
export PATH=\$PATH:\$GOPATH/bin
EOF

    source /etc/profile.d/go-packages.sh

    ## VSCode go plugin dependency
    go get -u -v github.com/ramya-rao-a/go-outline
    go get -u -v github.com/mdempsky/gocode
    go get -u -v github.com/uudashr/gopkgs/cmd/gopkgs
    go get -u -v github.com/rogpeppe/godef
    go get -u -v github.com/sqs/goreturns
    go get -u -v golang.org/x/tools/cmd/gorename
    go get -u -v golang.org/x/lint/golint
    go get -u -v github.com/stamblerre/gocode
    go get -u -v golang.org/x/lint/golint


    ## Dev tools
    go get -u -v golang.org/x/...
    go get -u -v golang.org/x/crypto
    go get -u -v golang.org/x/tools/...
    ## utils
    #go get -u -v golang.org/x/tools/cmd/goimports
    #go get -u -v golang.org/x/tools/go/analysis/...
    ## goMobile
    go get -u -v golang.org/x/mobile/cmd/gobind
    go get -u -v golang.org/x/mobile/cmd/gomobile
    ## compile
    go get -u -v github.com/cespare/reflex
    ## HTTP
    go get -u -v github.com/gin-gonic/gin
    go get -u -v github.com/gin-gonic/contrib/...
    go get -u -v github.com/dgrijalva/jwt-go
    ## goNum
    go get -u -v -t gonum.org/v1/gonum/...
    ## DB
    go get -u -v gopkg.in/mgo.v2

    # CDK
    go get gocloud.dev
    # Protobuf
    go get -u github.com/golang/protobuf/proto
    go get -u github.com/golang/protobuf/protoc-gen-go
    ## gRPC
    go get -u google.golang.org/grpc

    ## Update
    #go get -u -v all

    sudo chown -R root:wheel /opt/go-packages
    sudo chmod -R u+rwX,go+rwX,o-w /opt/go-packages
}

function flutter_packages() {
    sudo rm -rf /opt/flutter-sdk
    sudo mkdir -p /opt/flutter-sdk

    #sudo git clone -b stable --single-branch https://github.com/flutter/flutter.git /opt/flutter-sdk --depth=1
    sudo git clone -b master https://github.com/flutter/flutter.git /opt/flutter-sdk
    sudo mkdir /opt/flutter-sdk/pub_cache
    sudo chown -R root:wheel /opt/flutter-sdk
    sudo chmod -R u+rwX,go+rwX,o-w /opt/flutter-sdk

    cat <<EOF | sudo tee /etc/profile.d/flutter-sdk.sh
export FLUTTER_ROOT=/opt/flutter-sdk/
export PUB_CACHE=\$FLUTTER_ROOT/pub_cache
export ENABLE_FLUTTER_DESKTOP=true
export PATH=\$PATH:\$FLUTTER_ROOT/bin:\$PUB_CACHE/bin
EOF

    source /etc/profile.d/flutter-sdk.sh

    flutter doctor
    flutter precache
}

function kde_utils() {
    sudo cat <<EOF | sudo tee /usr/local/bin/kde-lock-session.sh
#!/bin/sh
loginctl lock-session
EOF
    sudo chmod 775 /usr/local/bin/kde-lock-session.sh
}

function install_modules() {
    echo "Starting installataion ..."
    ##power_management_packages
    ##android_packages
    #go_packages
    ##flutter_packages
    ##ide_pacakges
    #printutil_packages
    #arm_packages
    #db_packages
    #gcloud_packages
    #browser_packages
    ##kde_utils
}

function install_aur_helpers() {
    yay_install
}

#install_aur_helpers
install_modules 2>&1 | tee archlinux-aur.log

#$AUR_UPGRADE_CMD 2>&1 | tee archlinux-aur_upgrade.log
