#!/usr/bin/env python3

import json
import subprocess
import sys

def main(argv):
    with subprocess.Popen('i3status', shell=True, stdout=subprocess.PIPE) as ps:
        for line in ps.stdout:
            try:
                print(json.loads(line[1:]))
            except json.JSONDecodeError:
                pass

if __name__ == '__main__':
    main(sys.argv)
