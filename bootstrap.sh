#!/bin/bash
set -e

ASDF_VERSION=0.7.6

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y openssh-server

sudo add-apt-repository -y ppa:kgilmer/regolith-stable
sudo apt-get install -y regolith-desktop

git clone https://github.com/asdf-vm/asdf.git ~/.local/share/asdf --branch "v$ASDF_VERSION"

mkdir -p $HOME/.config/asdf
export ASDF_CONFIG_FILE=$HOME/.config/asdf/asdfrc
export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME=$HOME/.config/asdf/tool-versions
export ASDF_DATA_DIR=$HOME/.local/share/asdf

. $HOME/.local/share/asdf/asdf.sh
. $HOME/.local/share/asdf/completions/asdf.bash

sudo apt-get install -y \
  automake autoconf libreadline-dev zlib1g-dev \
  libncurses-dev libssl-dev libyaml-dev libsqlite3-dev\
  libxslt-dev libffi-dev libtool unixodbc-dev \
  libbz2-dev unzip curl

asdf plugin-add python
asdf install python $(asdf list-all python 2 | grep -v dev | grep -v rc | tail -1)
asdf install python $(asdf list-all python 3 | grep -v dev | grep -v rc | tail -1)
asdf global python 3.8.1 2.7.17

asdf plugin-add ruby
asdf install ruby $(asdf list-all ruby 2 | grep -v dev | grep -v rc | grep -v preview | tail -1)
asdf global ruby 2.7.0

asdf plugin-add nodejs
bash $HOME/.local/share/asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs $(asdf list-all nodejs | tail -1)
asdf global nodejs 13.5.0

asdf plugin-add golang
asdf install golang $(asdf list-all golang | grep -v beta | grep -v rc | tail -1)
asdf global golang 1.13.5

export CARGO_HOME=$HOME/.local/share/cargo
export RUSTUP_HOME=$HOME/.local/share/rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y --no-modify-path

sudo bash -c 'echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu disco stable" > /etc/apt/sources.list.d/docker-ce.list'
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

sudo apt-get update

sudo apt-get install -y \
  fzf bat fd-find ripgrep tmux peco ncdu tig ranger \
  asciinema jq aria2 grip rebound mycli pgcli cookiecutter \
  neovim neomutt rclone direnv htop zsh code \
  docker-ce docker-ce-cli containerd.io vagrant \
  qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

mkdir $HOME/bin

wget https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip -O /tmp/exa.zip && \
  unzip /tmp/exa.zip && \
  rm /tmp/exa.zip && \
  mv exa-linux-x86_64 $HOME/bin/exa

wget -O $HOME/bin/diff-so-fancy https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy && \
  chmod +x $HOME/bin/diff-so-fancy

curl -s https://raw.githubusercontent.com/dnote/dnote/master/pkg/cli/install.sh | bindir=$HOME/bin sh

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
  chmod +x kubectl && \
  mv kubectl $HOME/bin

sudo adduser `id -un` libvirt
sudo adduser `id -un` docker

wget -O $HOME/bin/yq https://github.com/mikefarah/yq/releases/download/2.4.1/yq_linux_amd64 && chmod +x $HOME/bin/yq

wget -O /tmp/alacritty.deb https://github.com/jwilm/alacritty/releases/download/v0.4.0/Alacritty-v0.4.0-ubuntu_18_04_amd64.deb && sudo dpkg -i /tmp/alacritty.deb && rm /tmp/alacritty.deb

curl -Lo $HOME/bin/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && \
  chmod +x $HOME/bin/minikube

curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o $HOME/bin/docker-compose
chmod +x $HOME/bin/docker-compose

npm install -g tldr generate generate-gitignore taskbook cash-cli speed-test fkill-cli trash-cli

pip install litecli mdv virtualenvwrapper

install_fonts() {
  fonts_dir=$(mktemp -d)
  pushd $fonts_dir

  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Hack.zip
  unzip Hack.zip

  wget https://github.com/supermarin/YosemiteSanFranciscoFont/archive/master.zip
  unzip master.zip

  mkdir -p ~/.local/share/fonts

  shopt -s globstar
  mv ./**/*.ttf ~/.local/share/fonts
  shopt -u globstar

  fc-cache -fv

  popd
}

install_fonts
chsh -s /bin/zsh
