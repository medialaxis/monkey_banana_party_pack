green='\e[1;32m'
red='\e[1;31m'

smiley_color()
{
    if [ $? = 0 ]; then
        echo -e "${green}"
        return 0
    else
        echo -e "${red}"
        return 1
    fi
}

smiley_face()
{
    if [ $? = 0 ]; then
        echo -n ":)"
        return 0
    else
        echo -n ":("
        return 1
    fi
}

PS1="\[\033[01;32m\]\u@\h\[\033[01;33m\] \w\n\[\$(smiley_color)\]\$(smiley_face) \[\033[01;34m\]\$\[\033[00m\] "
