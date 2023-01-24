#!/bin/bash

plugin()
{
    local remote=$1
    local commit=$2

    local plugin_dir=~/.local/share/awesome/plugins/$(basename $remote)

    if [ ! -d $plugin_dir ]; then
        git clone $remote $plugin_dir
    fi

    pushd $plugin_dir > /dev/null
    git fetch
    git checkout $commit 2> /dev/null
    popd > /dev/null
}

plugin https://github.com/lcpz/lain 88f5a8abd2649b348ffec433a24a263b37f122c0
