#!/usr/bin/env python3

import os
import socket
import argparse


# ANSI escape codes
BLUE = "\033[0;34m"
CYAN = "\033[0;36m"
GREEN = "\033[0;32m"
RED = "\033[0;31m"
WHITE = "\033[0;37m"
YELLOW = "\033[0;33m"

BOLDBLUE = "\033[1;34m"
BOLDCYAN = "\033[1;36m"
BOLDGREEN = "\033[1;32m"
BOLDRED = "\033[1;31m"
BOLDWHITE = "\033[1;37m"
BOLDYELLOW = "\033[1;33m"

RESET = "\033[0m"


def main():
    # Parse arguments.
    parser = argparse.ArgumentParser()
    parser.add_argument("-e", "--exit_code", type=int, required=True)
    args = parser.parse_args()

    # Get current user
    user = os.getlogin()

    # Get current hostname
    hostname = socket.gethostname()

    # Get current git branch
    branch = os.popen("git rev-parse --abbrev-ref HEAD").read().strip()

    # Get current working directory and shorten it
    cwd = os.getcwd()
    home = os.path.expanduser("~")
    cwd = cwd.replace(home, "~")

    # Get STY environment variable
    sty = os.getenv("STY")

    if args.exit_code == 0:
        smiley = f"{BOLDGREEN}:)"
    else:
        smiley = f"{BOLDRED}:("

    user_host = f"{BOLDGREEN}{user}@{hostname}{RESET}"
    screen = f"{BOLDCYAN}(screen)"
    branch = f"{BOLDWHITE}({branch})"
    dir = f"{BOLDYELLOW}{cwd}"
    prompt = f"{BOLDBLUE}$"

    # Print prompt with colors
    if sty:
        print(f"{user_host} {screen} {branch} {dir}\n{smiley} {prompt}{RESET} ")
    else:
        print(f"{user_host} {branch} {dir}\n{smiley} {prompt}${RESET} ")


if __name__ == '__main__':
    main()
