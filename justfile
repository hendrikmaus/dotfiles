# https://github.com/casey/just

set export

default:
  @just --list

# manage package list hook for pacman
pkglist:
  #!/usr/bin/env bash
  set -euo pipefail
  
  hook_path=/usr/share/libalpm/hooks/keep-package-list.hook

  if [[ ! -f "${hook_path}" ]]; then
    sudo cp "$HOME/templates/keep-package-list.hook" "${hook_path}"
    echo "Placed pkglist hook in: ${hook_path}"
  fi
