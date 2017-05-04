export LC_CTYPE=en_US.UTF-8
export BLOCKSIZE=K
export EDITOR=/usr/bin/vi
export PAGER=/usr/bin/less
export LESS=-XRi

if [[ -o interactive ]]; then
    PS1='[%m:%3~] %n%# '
    bindkey -e

    HISTFILE=~/.history
    HISTSIZE=1000
    SAVEHIST=1000
    setopt sharehistory histignorealldups histignorespace histreduceblanks
    setopt histnostore
    bindkey '^xp' history-beginning-search-backward
    bindkey '^xn' history-beginning-search-forward

    setopt shwordsplit globsubst cshnullglob
    unsetopt notify bgnice hup

    alias v='ls -l'

    autoload -U compinit
    autoload -U complist
    compinit
    zstyle ':completion:*' menu select=20

fixssh() {
    for key in SSH_AUTH_SOCK SSH_CONNECTION SSH_CLIENT; do
        if tmux show-environment | egrep "^${key}" >/dev/null; then
            value=`tmux show-environment | egrep "^${key}" | sed -e "s/^[A-Z_]*=//"`
            export ${key}="${value}"
        fi
    done
}

fi
