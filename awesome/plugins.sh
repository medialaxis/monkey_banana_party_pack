#!/bin/bash

clone()
{
    git clone https://github.com/lcpz/lain ~/.local/share/awesome/plugins/lain
    pushd ~/.local/share/awesome/plugins/lain
    git checkout 88f5a8abd2649b348ffec433a24a263b37f122c0 2> /dev/null
    popd

}

"$@"
