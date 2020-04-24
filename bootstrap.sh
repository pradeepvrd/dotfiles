#!/bin/bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu eoan stable"

sudo apt update
sudo apt install -y kitty curl zsh docker-ce docker-ce-cli containerd.io

infocmp xterm-kitty | tic -x -
sudo usermod -aG docker $USER

curl -L https://nixos.org/nix/install | sh
. $HOME/.nix-profile/etc/profile.d/nix.sh

nix-env -iA \
  nixpkgs.bat \
  nixpkgs.bear \
  nixpkgs.clang-tools \
  nixpkgs.direnv \
  nixpkgs.docker-compose \
  nixpkgs.dotnet-sdk \
  nixpkgs.fd \
  nixpkgs.fzf \
  nixpkgs.git \
  nixpkgs.gitAndTools.diff-so-fancy \
  nixpkgs.go \
  nixpkgs.kubectl \
  nixpkgs.minikube \
  nixpkgs.neovim \
  nixpkgs.nix \
  nixpkgs.nodejs \
  nixpkgs.python3 \
  nixpkgs.python3Packages.grip \
  nixpkgs.python3Packages.virtualenvwrapper \
  nixpkgs.ranger \
  nixpkgs.ripgrep \
  nixpkgs.tmux \
  nixpkgs.tmuxinator \
  nixpkgs.tree

FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"

FONTS=( Hack FiraCode )

for font in "${FONTS[@]}"; do
  echo "Installing $font nerd font"
  curl -Lo "$font.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/$font.zip" \
    && unzip -o "$font.zip" \
    && mv *.otf *.ttf "$FONTS_DIR" \
    && rm -f "$font.zip"
done
