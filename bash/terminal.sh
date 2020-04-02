# Used by i3-sensible-terminal for starting terminals in i3.
# export TERMINAL=xterm
# export TERMINAL=xfce4-terminal
export TERMINAL=urxvt

# Turn on 256 color support...
if [ "x$TERM" = "xxterm" ]
then
    export TERM="xterm-256color"
fi
