# Enable FZF completion (**<tab>)
source /usr/share/fzf/completion.bash
source /usr/share/fzf/key-bindings.bash
_fzf_setup_completion path git okular vim mplayer
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_ALT_C_COMMAND='systool list_dir'
