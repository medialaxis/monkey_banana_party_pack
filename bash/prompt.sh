# https://wiki.archlinux.org/index.php/Bash/Prompt_customization

bold="$(tput bold)"
red="$(tput setaf 1)"
green="$(tput setaf 2)"
yellow="$(tput setaf 3)"
blue="$(tput setaf 4)"
reset="$(tput sgr0)"

smiley_color()
{
    if [ $? = 0 ]; then
        echo -n "${bold}${green}"
        return 0
    else
        echo -n "${bold}${red}"
        return 1
    fi
}

smiley_face()
{
    if [ $? = 0 ]; then
        echo -n ":)"
    else
        echo -n ":("
    fi
}

# PS1="\[\033[01;32m\]\u@\h\[\033[01;33m\] \w\n$(smiley) \[\033[01;34m\]\$\[\033[00m\] "
PS1="\[${bold}${green}\]\u@\h\[${bold}${yellow}\] \w\n\[\$(smiley_color)\]\$(smiley_face) ${bold}${blue}\$${reset} "
