#!/bin/bash

cp_vscode_settings(){
  cp -f ./src/Biff/settings.json ~/.config/Code/User/settings.json
}

cp_gitconfig(){
  cp -f ./src/Biff/.gitconfig ~/.gitconfig
}

git_user(){
  git config --global user.name "$1"
  git config --global user.email "$2"
}

install_libsecret(){
  sudo apt-get install libsecret-1-0 libsecret-1-dev
  cd /usr/share/doc/git/contrib/credential/libsecret
  sudo make
  git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
}

install_clj(){
  SCRIPT_NAME=linux-install-1.10.3.855.sh
  FILE=/tmp/${SCRIPT_NAME}
  sudo apt update
  sudo apt install -y rlwrap
  curl -o /tmp/${SCRIPT_NAME} https://download.clojure.org/install/${SCRIPT_NAME}
  chmod +x ${FILE}
  sudo bash ${FILE}
  sudo rm ${FILE}
}

install_gnome_shell_clock_override(){
  cd ../
  git clone https://github.com/stuartlangridge/gnome-shell-clock-override
  cd gnome-shell-clock-override
  make -j install
}

install_jdk(){
  # 11.0.2
  # 14.0.2
  # 16.0.1
  FILE=openjdk-$1_linux-x64_bin.tar.gz
  URL=https://download.java.net/java/GA/jdk11/9/GPL/$FILE
  echo $URL
  wget $URL -P ~/Downloads
  mkdir -p ~/bin
  tar -xvzf ~/Downloads/$FILE -C ~/bin
}

bashrc(){
  cat ./src/Biff/.bashrc >> ~/.bashrc
}

install_golang(){
  FILENAME=go1.15.7.linux-amd64.tar.gz
  wget https://go.dev/dl/$FILENAME -P ~/Downloads
  mkdir -p ~/bin
  tar -xvzf ~/Downloads/$FILENAME -C ~/bin
  go version
}

install_qt(){
  sudo apt-get install qt5-default
}

"$@"