# https://github.com/casey/just

set export
set shell := ["bash", "-uc"]

_default:
  @just --list

# configure the system
configure:
  sudo -v
  just _pkglist-hook
  just _default-shell
  just _ssh-agent
  just _docker

# install everything
install:
  just install-base-packages

# manage package list hook for pacman
_pkglist-hook:
  #!/usr/bin/env bash
  set -euo pipefail
  
  hook_path=/usr/share/libalpm/hooks/keep-package-list.hook

  if [[ ! -f "${hook_path}" ]]; then
    sudo cp "$HOME/templates/keep-package-list.hook" "${hook_path}"
    echo "Placed pkglist hook in: ${hook_path}"
  fi

# set zsh as the default shell
_default-shell:
  #!/usr/bin/env bash
  set -euo pipefail

  if [[ "${SHELL}" != "/usr/bin/zsh" ]]; then
    chsh --shell /usr/bin/zsh
    echo "Set the default shell to zsh"
  fi

# setup ssh agent service
_ssh-agent:
  #!/usr/bin/env bash
  set -euo pipefail

  mkdir -p ~/.config/systemd/user
  cp templates/ssh-agent.service ~/.config/systemd/user
  systemctl --user enable ssh-agent
  systemctl --user start ssh-agent
  mkdir -p ~/.ssh
  [[ ! -f "~/.ssh/config" ]] && touch ~/.ssh/config
  chmod 600 ~/.ssh/config
  if ! grep -qF "AddKeysToAgent" ~/.ssh/config; then
    echo "AddKeysToAgent yes" >> ~/.ssh/config
  fi

# configure docker
_docker:
  #!/usr/bin/env bash
  set -euo pipefail
  sudo -v
  if ! grep -qF "docker" /etc/group; then
    sudo groupadd docker
  fi
  sudo usermod -aG docker $USER
  sudo systemctl enable docker.service
  sudo systemctl enable containerd.service

# install all base packages
install-base-packages:
  paru -S --needed $(sort $HOME/.pkglist-base)
