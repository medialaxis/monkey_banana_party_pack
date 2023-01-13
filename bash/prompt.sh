# https://wiki.archlinux.org/index.php/Bash/Prompt_customization

# This is the default prompt command. This prints a text in the terminal window
# title.
TERM_SYNC='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
PROMPT_COMMAND="$TERM_SYNC; $PROMPT_COMMAND"

PS1="\$(my_prompt.py -e \$?)"
