# https://github.com/casey/just

set export

default:
  @just --list

# configure the system
configure:
  sudo -v
  just _pkglist-hook
  just _default-shell

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
    sudo chsh --shell /usr/bin/zsh
    echo "Set the default shell to zsh"
  fi

# install all base packages
install-base-packages:
  paru -S --needed $(sort $HOME/.pkglist-base)
