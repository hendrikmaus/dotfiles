# -----------------------------------------------------------------------------
# zsh profile
# -----------------------------------------------------------------------------

# Define default editor
export EDITOR=/usr/bin/vim

# Define default browser
export BROWSER=/usr/bin/vivaldi-stable

# Setup ssh agent
if [[ -z "${SSH_AUTH_SOCK}" ]]; then
  eval $(ssh-agent -s)
  ssh-add
fi

