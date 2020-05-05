#!/bin/bash
HOST_SYSTEM_PACKAGES=(
  "kitty"
  "zsh"
  "docker-ce-cli"
  "docker-ce"
  "containerd.io"
)

COMMON_NIX_PACKAGES=(
  "nixpkgs.bat"
  "nixpkgs.bear"
  "nixpkgs.clang-tools"
  "nixpkgs.direnv"
  "nixpkgs.docker-compose"
  "nixpkgs.dotnet-sdk"
  "nixpkgs.emacs"
  "nixpkgs.fd"
  "nixpkgs.fzf"
  "nixpkgs.gitAndTools.diff-so-fancy"
  "nixpkgs.go"
  "nixpkgs.kubectl"
  "nixpkgs.neovim"
  "nixpkgs.nodejs"
  "nixpkgs.python3"
  "nixpkgs.python3Packages.grip"
  "nixpkgs.python3Packages.virtualenvwrapper"
  "nixpkgs.ranger"
  "nixpkgs.ripgrep"
  "nixpkgs.tmux"
  "nixpkgs.tmuxinator"
  "nixpkgs.tree"
)

DOCKER_NIX_PACKAGES=(
  "nixpkgs.docker"
  "nixpkgs.git"
  "nixpkgs.unzip"
  "nixpkgs.zsh"
)

HOST_NIX_PACKAGES=(
  "nixpkgs.minikube"
)

in_docker() {
  [ -f /.dockerenv ]
}

setup_docker_repos() {
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu eoan stable"
  
  sudo apt update
}

git-clone-idempotent() {
  REPO="$1"
  DEFAULT_FOLDER="$(echo "$REPO" | sed 's|.*/||' | sed 's|.git$||')"
  FOLDER="${2:-$DEFAULT_FOLDER}"

  if [ -d "$FOLDER" ]; then
    cd "$FOLDER"
    git pull
  else
    git clone "$REPO" "$FOLDER"
  fi
}

in_docker || (
  setup_docker_repos
  sudo apt-get install -y ${HOST_SYSTEM_PACKAGES[@]}
  infocmp xterm-kitty | tic -x -
);

sudo groupadd -f docker
sudo usermod -aG docker $USER

sudo chown -R $USER /nix
curl -L https://nixos.org/nix/install | sh
. $HOME/.nix-profile/etc/profile.d/nix.sh

sudo chown -R $USER /nix
nix-env -iA ${COMMON_NIX_PACKAGES[@]}
in_docker && nix-env -iA ${DOCKER_NIX_PACKAGES[@]} || ${HOST_NIX_PACKAGES[@]}

FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"

FONTS=( Hack FiraCode )

for font in "${FONTS[@]}"; do
  echo "Installing $font nerd font"
  curl -Lo "$font.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/$font.zip" \
    && unzip -o "$font.zip" \
    && find . -maxdepth 1 -type f \( -iname \*.otf -o -iname \*.ttf \) | xargs -i{} mv {} "$FONTS_DIR" \
    && rm -f "$font.zip"
done

$HOME/stash/dotfiles/install

git-clone-idempotent https://github.com/hlissner/doom-emacs $HOME/.emacs.d
$HOME/.emacs.d/bin/doom install
