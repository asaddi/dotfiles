export CLICOLOR=
export GREP_OPTIONS=--color

activate() {
    local root env_base env_activate

    [ -n "$VIRTUAL_ENV" ] && deactivate

    root=$(hg root 2>/dev/null)
    if [ -z "$root" ]; then
        root="$PWD"
    fi

    if [ -n "$VENV_BASE" ]; then
        env_base="$VENV_BASE"/$(basename "$root")
    else
        env_base="$root"/.env
    fi

    env_activate="$env_base"/bin/activate
    if [ -e "$env_activate" ]; then
        . "$env_activate"
        return 0
    else
        echo "no virtualenv at $env_base" >&2
        return 1
    fi
}

VCS_PROMPT_HG_ENABLE=true
VCS_PROMPT_GIT_ENABLE=true

autoload -U colors
colors

setopt promptsubst

VCS_PROMPT_PREFIX=" %{$fg[cyan]%}("
VCS_PROMPT_SUFFIX="%{$fg[cyan]%}%)%{$reset_color%}"
VCS_PROMPT_DIRTY="%{$fg[red]%}✘"
VCS_PROMPT_CLEAN="%{$fg[green]%}✔"

if $VCS_PROMPT_HG_ENABLE && whence -p hg >/dev/null && command hg help prompt >/dev/null 2>&1; then
    function hg_prompt_info {
        local _OUT
        _OUT=$(command hg prompt --angle-brackets "$VCS_PROMPT_PREFIX<branch><%{$fg[green]%}@<bookmark>> F1kXbIWY<status>$VCS_PROMPT_SUFFIX" 2>/dev/null)
        _OUT=${_OUT:s/F1kXbIWY?/$VCS_PROMPT_DIRTY/:s/F1kXbIWY!/$VCS_PROMPT_DIRTY/:s/F1kXbIWY/$VCS_PROMPT_CLEAN/}
        echo "$_OUT"
    }
else
    function hg_prompt_info { }
fi

if $VCS_PROMPT_GIT_ENABLE && whence -p git >/dev/null; then
    function git_prompt_info {
        local ref STATUS
        ref=$(command git symbolic-ref HEAD 2>/dev/null) || return
        echo "$VCS_PROMPT_PREFIX${ref#refs/heads/} $(git_prompt_status)$VCS_PROMPT_SUFFIX"
    }

    function git_prompt_status {
        local STATUS=$(command git status --porcelain 2>/dev/null | tail -n1)
        if [[ -n $STATUS ]]; then
            echo "$VCS_PROMPT_DIRTY"
        else
            echo "$VCS_PROMPT_CLEAN"
        fi
    }
else
    function git_prompt_info { }
fi

PS1='%{$bold_color%}[%{$reset_color$fg[white]%}%m%{$reset_color$bold_color%}:%{$reset_color$fg[magenta]%}%3~%{$reset_color$bold_color%}]%{$reset_color%}$(hg_prompt_info)$(git_prompt_info) %n%(?.%{$fg[green]%}.%{$fg[red]%})%#%{$reset_color%} '
