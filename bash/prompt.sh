# https://wiki.archlinux.org/index.php/Bash/Prompt_customization

bold="$(tput bold)"
red="$(tput setaf 1)"
green="$(tput setaf 2)"
yellow="$(tput setaf 3)"
blue="$(tput setaf 4)"
reset="$(tput sgr0)"

smiley_color()
{
    if [ $OK = 0 ]; then
        echo -n "${bold}${green}"
    else
        echo -n "${bold}${red}"
    fi
}

smiley_face()
{
    if [ $OK = 0 ]; then
        echo -n ":)"
    else
        echo -n ":("
    fi
}

PS1="\[${bold}${green}\]\u@\h\[${bold}${yellow}\] \w\n\[\$(smiley_color)\]\$(smiley_face) \[${bold}${blue}\]\$\[${reset}\] "
