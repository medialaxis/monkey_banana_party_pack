#!/bin/bash

set -euo pipefail

start_server()
{
    # -br:      create root window with black background
    # -ac:      disable access control restrictions
    # -noreset: don't reset after last client exists
    # -screen:  800x600 pixels
    # use ctrl+shift to capture keyboard
    Xephyr -br -ac -noreset -screen 800x600 :1 &
}

start_client()
{
    DISPLAY=:1 awesome
}

"$@"
