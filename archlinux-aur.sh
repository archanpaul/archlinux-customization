# AUR packages install

CDIR=`pwd`

PACMAN_PKG_INSTALL_CMD="pacman -U --noconfirm --needed "
PACMAN_CMD="sudo pacman -S --noconfirm --needed "
AUR_CMD="yay -Sy --noconfirm --needed "
AUR_UPGRADE_CMD="yay -Syu --noconfirm --needed "

function yay_install() {
    mkdir -p $CDIR/cache
    cd $CDIR/cache
    rm -rf yay*
    git clone https://aur.archlinux.org/yay.git
    cd $CDIR/cache/yay && makepkg -sci
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

    sudo mkdir -p /opt/android-sdk
    sudo chown -R root:wheel /opt/android-sdk
    sudo chmod -R u+rwX,go+rwX,o-w /opt/android-sdk

    cat <<EOF | sudo tee /etc/profile.d/android-sdk.sh
export ANDROID_HOME=/opt/android-sdk/
export ANDROID_SDK_ROOT=\$ANDROID_HOME
export ANDROID_NDK_ROOT=\$ANDROID_HOME/ndk/21.1.6352462
export ANDROID_NDK_HOME=\$ANDROID_NDK_ROOT
export PATH=\$PATH:\$ANDROID_HOME/platform-tools/
EOF

    source /etc/profile.d/android-sdk.sh
}

function ide_pacakges() {
    $AUR_CMD visual-studio-code-bin
    $PACMAN_CMD  gnome-keyring libsecret

    # sudo echo 'fs.inotify.max_user_watches=524288' | sudo tee -a /etc/sysctl.conf
    # sudo sysctl -p

    ## vscode list extensions
    # code --list-extensions | xargs -L 1 echo code --install-extension

    ## vscode install extensions
    # code --install-extension BazelBuild.vscode-bazel
    # code --install-extension Dart-Code.dart-code
    # code --install-extension Dart-Code.flutter
    # code --install-extension GitHub.github-vscode-theme
    # code --install-extension GitHub.vscode-pull-request-github
    # code --install-extension golang.go
    # code --install-extension mhutchie.git-graph
    # code --install-extension ms-azuretools.vscode-docker
    # code --install-extension ms-python.python
    # code --install-extension ms-python.vscode-pylance
    # code --install-extension ms-toolsai.jupyter
    # code --install-extension ms-toolsai.jupyter-keymap
    # code --install-extension ms-toolsai.jupyter-renderers
    # code --install-extension ms-vscode-remote.remote-containers
    # code --install-extension ms-vscode-remote.remote-ssh
    # code --install-extension ms-vscode-remote.remote-ssh-edit
    # code --install-extension ms-vscode.cmake-tools
    # code --install-extension ms-vscode.cpptools
    # code --install-extension redhat.java
    # code --install-extension redhat.vscode-yaml
    # code --install-extension VisualStudioExptTeam.vscodeintellicode
}

function python_packages() {
    $AUR_CMD python-conda

    ## conda init
    ## conda create --name py39conda python=3.9
    ## conda activate py39conda
    ## conda install anaconda
    ## conda install scikit-learn-intelex
    ## conda install tensorflow
    ## conda install -c conda-forge opencv

}

function printutil_packages() {
    $AUR_CMD hplip-plugin
}

function arm_packages() {
    $AUR_CMD gcc-arm-none-eabi-bin
}

function db_packages() {
    $AUR_CMD mongodb-bin mongodb-tools-bin
    $AUR_CMD mongodb-compass
}


function gcloud_packages() {
    $AUR_CMD google-cloud-sdk
}

function browser_packages() {
    $AUR_CMD tor-browser-en
    $AUR_CMD google-chrome
    $AUR_CMD microsoft-edge-stable-bin
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

    sudo chown -R root:wheel /opt/go-packages
    sudo chmod -R u+rwX,go+rwX,o-w /opt/go-packages
}

function go_tools_libs_packages() {
    source /etc/profile.d/go-packages.sh

    ## VSCode go plugin dependency
    export GO111MODULE=on

    go get -v github.com/uudashr/gopkgs/v2/cmd/gopkgs
    go get -v github.com/ramya-rao-a/go-outline
    go get -v github.com/cweill/gotests/...
    go get -v github.com/fatih/gomodifytags
    go get -v github.com/josharian/impl
    go get -v github.com/haya14busa/goplay/cmd/goplay
    go get -v github.com/go-delve/delve/cmd/dlv
    go get -v github.com/stamblerre/gocode
    go get -v golang.org/x/lint/golint
    go get -v golang.org/x/tools/gopls
    go get -v honnef.co/go/tools/cmd/staticcheck

    ## Dev tools
    go get -u -v github.com/cespare/reflex
    go get -u -v golang.org/x/...
    go get -u -v golang.org/x/tools/...
    go get -u -v golang.org/x/tools/cmd/...
    go get -u -v golang.org/x/tools/gopls
    #go get -u -v golang.org/x/tools/go/analysis/...
    ## goMobile
    go get -u -v golang.org/x/mobile/cmd/gobind
    go get -u -v golang.org/x/mobile/cmd/gomobile
    ## HTTP
    go get -u -v github.com/gin-gonic/gin
    go get -u -v github.com/gin-gonic/contrib/...
    go get -u -v github.com/dgrijalva/jwt-go
    #go get -v -v github.com/go-chi/chi
    #go get -v -v github.com/go-chi/cors
    ## Log
    go get -v -v go.uber.org/zap
    ## goNum
    go get -u -v -t gonum.org/v1/gonum/...
    ## DB
    go get -u -v github.com/dgraph-io/dgo/v2
    go get -u -v go.mongodb.org/mongo-driver
    go get -u -v go.mongodb.org/mongo-driver/bson
    go get -u -v go.mongodb.org/mongo-driver/mongo/options
    go get -u -v go.mongodb.org/mongo-driver/mongo/readpref
    ## protobuf
    go get -u -v github.com/golang/protobuf/proto
    go get -u -v github.com/golang/protobuf/protoc-gen-go
    ## gRPC
    go get -u -v google.golang.org/grpc
    ## Messaging
    #go get -u -v github.com/nats-io/nats.go
    #go get -u -v github.com/nats-io/nats-server
    #go get -u -v github.com/nats-io/nats-streaming-server
    #go get github.com/liftbridge-io/go-liftbridge
    #go get -u -v github.com/ThreeDotsLabs/watermill
    # Go CDK
    #go get -u -v gocloud.dev
    # UUID
    go get -u -v github.com/google/uuid
    # Embedded DB
    go get -u -v go.etcd.io/bbolt/...
    go get -u -v github.com/dgraph-io/badger/...
    # Firebase
    go get -u -v firebase.google.com/go
    go get -u -v firebase.google.com/go/auth
    # opencv
    go get -u -d gocv.io/x/gocv

    ## Update
    #go get -u -v all
}

function flutter_packages() {
    sudo rm -rf /opt/flutter-sdk
    sudo mkdir -p /opt/flutter-sdk

    sudo git clone -b stable --single-branch https://github.com/flutter/flutter.git /opt/flutter-sdk --depth=1
    # sudo git clone -b master https://github.com/flutter/flutter.git /opt/flutter-sdk

    sudo mkdir /opt/flutter-sdk/pub_cache
    sudo chown -R root:wheel /opt/flutter-sdk
    sudo chmod -R u+rwX,go+rwX,o-w /opt/flutter-sdk

    cat <<EOF | sudo tee /etc/profile.d/flutter-sdk.sh
export FLUTTER_ROOT=/opt/flutter-sdk/
export PUB_CACHE=\$FLUTTER_ROOT/pub_cache
export ENABLE_FLUTTER_DESKTOP=true
export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable
export PATH=\$PATH:\$FLUTTER_ROOT/bin:\$PUB_CACHE/bin
EOF
    source /etc/profile.d/flutter-sdk.sh

    #flutter doctor
    #flutter doctor --android-licenses
    #flutter config --no-analytics
    #flutter precache
    #flutter config --enable-linux-desktop
    #flutter config --enable-windows-desktop
    #flutter config --enable-windows-uwp-desktop
    #flutter config --enable-macos-desktop
    #pub global activate protoc_plugin
}

function gnome_packages() {
    $AUR_CMD gnome-shell-extension-dash-to-dock
    $AUR_CMD gnome-shell-extension-dash-to-panel
}

function kde_packages() {
    sudo cat <<EOF | sudo tee /usr/local/bin/kde-lock-session.sh
#!/bin/sh
loginctl lock-session
EOF
    sudo chmod 775 /usr/local/bin/kde-lock-session.sh
}

function install_modules() {
    echo "Starting installataion ..."
    #power_management_packages
    #ide_pacakges
    #python_packages
    #printutil_packages
    #arm_packages
    #db_packages
    #gcloud_packages
    #browser_packages
    #gnome_packages
    #kde_packages
    #go_packages
    #go_tools_libs_packages
    #android_packages
    #flutter_packages
}

function install_aur_helpers() {
    yay_install
}

#install_aur_helpers
yay -Sy
#install_modules 2>&1 | tee archlinux-aur.log

#$AUR_UPGRADE_CMD 2>&1 | tee archlinux-aur_upgrade.log
