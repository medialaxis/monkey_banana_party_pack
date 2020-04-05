# Append history to history files after every command, not just when existing
# bash.
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# Append to history rather than overwriting it.
shopt -s histappend

# Causes all previous lines matching the current line to be removed from the
# history list before that line is saved
export HISTCONTROL=ignoredups

# Erase all matching lines before adding the new one
# export HISTCONTROL=erasedups

# Do not truncate history file when this variable is unset
export HISTFILESIZE=1000000
export HISTSIZE=1000000

# Add timestamp to each history entry
# export HISTTIMEFORMAT="%Y-%m-%d"
