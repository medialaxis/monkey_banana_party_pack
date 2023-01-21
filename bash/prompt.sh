# https://wiki.archlinux.org/index.php/Bash/Prompt_customization

# This is the default prompt command. This prints a text in the terminal window
# title.
_my_term_sync()
{
    printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"
}

_my_prompt()
{
    my_prompt -e $?
}

_my_prompt_command()
{
    PS1="$(_my_prompt)"
    _my_history_prompt_command
    _my_term_sync
}

PROMPT_COMMAND="_my_prompt_command"
