XDG_CONFIG_HOME=${XDG_CONFIG_HOME:=$HOME/.config}
mkdir -p $HOME/.cache/z

# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install Homebrew cask apps
brew tap homebrew/cask-fonts
brew cask install \
  1password \
  1password-cli \
  alacritty \
  docker \
  font-hack-nerd-font \
  iterm2 \
  vagrant \
  virtualbox \
  virtualbox-extension-pack \
  visual-studio-code
  
brew install \
  asdf \
  coreutils \
  automake \
  autoconf \
  openssl \
  libyaml \
  readline \
  libxslt \
  libtool \
  unixodbc \
  unzip \
  curl \
  gnupg

mkdir -p $HOME/.config/asdf
mkdir -p $HOME/.local/share/asdf
export ASDF_CONFIG_FILE=$HOME/.config/asdf/asdfrc
export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME=$HOME/.config/asdf/tool-versions
export ASDF_DATA_DIR=$HOME/.local/share/asdf

. $(brew --prefix asdf)/asdf.sh
. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash

asdf plugin-add python
PY2_VERSION=$(asdf list-all python 2 | grep -v dev | grep -v rc | tail -1)
PY3_VERSION=$(asdf list-all python 3 | grep -v dev | grep -v rc | tail -1)
asdf install python $PY2_VERSION
asdf install python $PY3_VERSION
asdf global python $PY3_VERSION $PY2_VERSION

asdf plugin-add ruby
RUBY_VERSION=$(asdf list-all ruby 2 | grep -v dev | grep -v rc | grep -v preview | tail -1)
asdf install ruby $RUBY_VERSION
asdf global ruby $RUBY_VERSION

asdf plugin-add nodejs
bash $HOME/.local/share/asdf/plugins/nodejs/bin/import-release-team-keyring
NODEJS_VERSION=$(asdf list-all nodejs | tail -1)
asdf install nodejs $NODEJS_VERSION
asdf global nodejs $NODEJS_VERSION

asdf plugin-add golang
GOLANG_VERSION=$(asdf list-all golang | grep -v beta | grep -v rc | tail -1)
asdf install golang $GOLANG_VERSION
asdf global golang $GOLANG_VERSION

export CARGO_HOME=$HOME/.local/share/cargo
export RUSTUP_HOME=$HOME/.local/share/rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y --no-modify-path

brew tap dnote/dnote

brew install \
  aria2 \
  asciinema \
  bat \
  cashi-cli \
  diff-so-fancy \
  direnv \
  dnote \
  fd \
  fzf \
  gibo \
  htop \
  kubernetes-cli \
  minikube \
  mycli \
  ncdu \
  neomutt \
  neovim \
  peco \
  pgcli \
  ranger \
  rclone \
  ripgrep \
  tig \
  tldr \
  tree \
  yq

/usr/local/bin/npm -g install taskbook speed-test fkill-cli
/usr/local/bin/pip3 install virtualenvwrapper

asdf reshim

$(brew --prefix)/opt/fzf/install --xdg --completion --key-bindings --no-update-rc

mkdir -p ~/.config/zsh/completion
ln -s /Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion ~/.config/zsh/completion/_docker
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-machine.zsh-completion ~/.config/zsh/completion/_docker-machine
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-compose.zsh-completion ~/.config/zsh/completion/_docker-compose

chsh -s /bin/zsh
