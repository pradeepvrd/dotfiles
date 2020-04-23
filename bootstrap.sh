sudo pacman -Sy docker kitty wl-clipboard
yay -S nerd-fonts-fira-code nerd-fonts-hack

nix-env -iA \
  nixpkgs.bat \
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
