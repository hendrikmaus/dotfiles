# Dotfiles

## Setup

```shell
git clone --bare git@github.com:hendrikmaus/dotfiles.git $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout
# will likely fail; delete all files it complains about and run again

source ~/.zshrc
cfg config.status.showUntrackedFiles no

# assuming 'yay' is installed
yay -S paru just

just configure
just install-base-packages

# reboot
```

