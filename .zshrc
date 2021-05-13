# -----------------------------------------------------------------------------
# zsh
# -----------------------------------------------------------------------------


# Functions
# -----------------------------------------------------------------------------

# Show some status info
status() {
    print
    print "Date..: "$(date "+%Y-%m-%d %H:%M:%S")
    print "Shell.: Zsh $ZSH_VERSION (PID = $$, $SHLVL nests)"
    print "Term..: $TTY ($TERM), ${BAUD:+$BAUD bauds, }$COLUMNS x $LINES chars"
    print "Login.: $LOGNAME (UID = $EUID) on $HOST"
    print "System: $(cat /etc/[A-Za-z]*[_-][rv]e[lr]*)"
    print "Uptime: $(uptime)"
    print
}

# include file if it exists
incl() {
  [ -f $1 ] && source $1
}

# -----------------------------------------------------------------------------


export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt append_history
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt inc_append_history
setopt share_history
setopt autocd

# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Zle-Builtins
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

bindkey -e

# start typing + [Up-Arrow] - fuzzy find history forward
if [[ "${terminfo[kcuu1]}" != "" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search
  bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi

# start typing + [Down-Arrow] - fuzzy find history backward
if [[ "${terminfo[kcud1]}" != "" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search
  bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# [delete] - removes one character
bindkey '^?' backward-delete-char
if [[ "${terminfo[kdch1]}" != "" ]]; then
  bindkey "${terminfo[kdch1]}" delete-char
else
  bindkey "^[[3~" delete-char
  bindkey "^[3;5~" delete-char
  bindkey "\e[3~" delete-char
fi

if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line
fi
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}"  end-of-line
fi

# [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5C' forward-word

# [Ctrl-LeftArrow] - move backward one word
bindkey '^[[1;5D' backward-word

# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit

# case-insensitive command completion as well as cd fuzzy auto-compltion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select

autoload -Uz promptinit
promptinit
setopt PROMPT_SUBST

# Plugins
incl /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
incl /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# -----------------------------------------------------------------------------


# misc tools
# -----------------------------------------------------------------------------

# setup direnv
eval "$(direnv hook zsh)"

# fzf history search
incl /usr/share/fzf/key-bindings.zsh
incl /usr/share/fzf/completion.zsh

# zoxide (https://github.com/ajeetdsouza/zoxide)
# as alternative to jump
eval "$(zoxide init zsh)"

# golang
export GOPATH="$HOME/go"

# helm (Kubernetes)
export HELM_HOME="$HOME/.config/helm"

# gradle home
export GRADLE_USER_HOME="$HOME/.gradle"

# java home
export JAVA_HOME="$HOME/.sdkman/candidates/java/current"

# kubectl autocompletion without spaces after each entry
source <(kubectl completion zsh | sed '/"-f"/d')

# Google Cloud SDK 
incl /opt/google-cloud-sdk/path.zsh.inc
incl /opt/google-cloud-sdk/completion.zsh.inc

# -----------------------------------------------------------------------------


# Aliases
# -----------------------------------------------------------------------------

# Move around
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# List directory contents
alias ls='exa'
alias l='exa --long --group-directories-first --all'
alias lt='exa -lTL2'
alias ltt='exa -lTL3'

# Misc
alias grep='/usr/bin/grep --color=auto'
alias ipinfo="curl -s http://ipinfo.io | jq"
alias ipexternal="curl -s http://ipinfo.io/ip"
alias xx="exit"
alias zsource="source $HOME/.zshrc"
alias pass="gopass"
alias tf="terraform"
alias j="just"
alias jc="just --choose"
alias jl="just --list"

# Git
alias g="git"
alias gs="git status"
alias gm="git checkout master && git pull origin master --rebase"
alias gbr="git checkout -b $*"
alias gpush='git push -u origin $(git rev-parse --abbrev-ref HEAD)'
alias gpull="git pull"
alias gaa="git add . && git status"
alias ga="git add -p"
alias gc="git commit"
alias gd="git diff"
alias gdc="git diff --cached"

# Dotfiles Config
alias cfg='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias cfga='cfg add -p'
alias cfgs='cfg status'
alias cfgp='cfg push'
alias cfgc='cfg commit'
alias cfgd='cfg diff'

# Kubernetes
alias k='kubectl'
alias kgp='kubectl get pods'

# inlcude variables to select common kubeconfigs
incl $HOME/Development/kubernetes/configs.zsh.inc

# ssh
alias ssh='TERM=xterm-256color ssh'

# -----------------------------------------------------------------------------


# PATH
# -----------------------------------------------------------------------------

export PATH="$HOME/.bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/.sdkman/candidates/java/current/bin:$PATH"
export PATH="$HOME/.pyenv/versions/3.8.2/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.krew/bin:$PATH"
export PATH="$HOME/.istioctl/bin:$PATH"
export PATH="$HOME/Development/scripts:$PATH"

# -----------------------------------------------------------------------------


# starship
# -----------------------------------------------------------------------------

eval "$(starship init zsh)"

# -----------------------------------------------------------------------------

