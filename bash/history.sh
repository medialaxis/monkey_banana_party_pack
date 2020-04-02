# Append history to history files after every command, not just when existing
# bash.
if [ -n "$PROMPT_COMMAND" ]; then
    PROMPT_COMMAND="$PROMPT_COMMAND;history -a"
else
    PROMPT_COMMAND="history -a"
fi

# Causes all previous lines matching the current line to be removed from the
# history list before that line is saved
export HISTCONTROL=ignoredups

# Do not truncate history file when this variable is unset
export HISTFILESIZE=1000000
export HISTSIZE=1000000

