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

install_lein(){
  wget https://raw.githubusercontent.com/technomancy/leiningen/2.9.5/bin/lein -P ~/Downloads
  mkdir -p ~/bin
  mv ~/Downloads/lein ~/bin
  chmod a+x ~/bin/lein
}

install_nodejs(){
  curl -fsSL https://deb.nodesource.com/setup_12.x | sudo -E bash -
  sudo apt-get install -y nodejs
}

install_mono(){
  sudo apt install -y gnupg ca-certificates
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
  echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
  sudo apt update
  sudo apt install -y mono-complete
}

install_scheme(){
  # sudo apt-get install -y build-essential  uuid-dev libncurses5-dev libncursesw5-dev libx11-dev
  # sudo apt-get install -y lsb-release build-essential libssl-dev python

  # cd ~/bin && git clone https://github.com/cisco/ChezScheme

  # cd ~/bin/ChezScheme && \
  # git checkout 5aba39c40b46cee61a388d71ef4e5eebfa717108 && \
  #   ./configure && \
  #   sudo make install

  sudo apt install chezscheme
}

"$@"