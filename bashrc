__prompt_command() {
    local EXIT=$?

    local reset_color="\[\e(B\e[m\]"
    local bold_color="\[\e[1m\]"
    local red="\[\e[31m\]"
    local green="\[\e[32m\]"
    local magenta="\[\e[35m\]"
    local white="\[\e[37m\]"

    PS1="$bold_color[$reset_color$white\h$reset_color$bold_color:$reset_color$magenta\w$reset_color$bold_color]$reset_color \u"

    if [ $EXIT != 0 ]; then
        PS1+="$red\$$reset_color "
    else
        PS1+="$green\$$reset_color "
    fi
}

PROMPT_COMMAND=__prompt_command
