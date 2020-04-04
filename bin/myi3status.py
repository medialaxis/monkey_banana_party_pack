#!/usr/bin/env python3

import json
import subprocess
import sys

def system_state():
    cp = subprocess.run('systemctl show --property=SystemState', shell=True, capture_output=True)
    return cp.stdout.decode().strip().split('=')[1]

def update_status(status):
    state = {
            "name": "system_state",
            "color": "#00FF00",
            "full_text": system_state(),
            }
    return [state] + status

def main(argv):
    with subprocess.Popen('i3status', shell=True, stdout=subprocess.PIPE) as ps:
        for line in ps.stdout:
            try:
                print(json.dumps(update_status(json.loads(line[1:]))))
            except json.JSONDecodeError:
                pass

if __name__ == '__main__':
    main(sys.argv)
