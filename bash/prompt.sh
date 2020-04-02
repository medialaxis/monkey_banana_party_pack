smiley()
{
    if [ $? = 0 ]; then
        tput bold
        tput setaf 2 # Green
        echo ":)"
    else
        tput bold
        tput setaf 1 # Red
        echo ":("
    fi
}

PS1="\[\033[01;32m\]\u@\h\[\033[01;33m\] \w\n$(smiley) \[\033[01;34m\]\$\[\033[00m\] "
