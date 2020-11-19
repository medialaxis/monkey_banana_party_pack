# https://wiki.archlinux.org/index.php/Xinit

# Load .Xresources into X. Without this, .Xresources does not work.
xrdb -merge "$HOME/.Xresources"

# Start i3
exec i3
