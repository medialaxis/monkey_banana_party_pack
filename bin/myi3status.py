#!/usr/bin/env python3

import json
import subprocess
import sys

def system_state():
    cp = subprocess.run('systemctl show --property=SystemState', shell=True, capture_output=True)
    return cp.stdout.decode().strip().split('=')[1]

def video_memory():
    cp = subprocess.run("nvidia-smi -q -x | xmllint --xpath 'string(/nvidia_smi_log/gpu/fb_memory_usage/free)' -", shell=True, capture_output=True)
    return cp.stdout.decode().strip()

def update_status(status):
    state_str = system_state()
    if state_str == "running":
        color = "#00FF00";
    else:
        color = "#FF0000";

    state = {
            "color": color,
            "full_text": f"sys: {state_str}",
            }

    vmem = {
            "color": "#FFFFFF",
            "full_text": f"vmem {video_memory()}",
            }

    return [state, vmem] + status

def main(argv):
    with subprocess.Popen('i3status', shell=True, stdout=subprocess.PIPE, bufsize=0, text=True) as ps:
        for line in ps.stdout:
           if line[0] == '{':
               sys.stdout.write(line)
           elif line[0:2] == "[\n":
               sys.stdout.write(line)
           elif line[0:2] == "[{":
               print(f"{json.dumps(update_status(json.loads(line)))}")
           elif line[0] in [',']:
               print(f",{json.dumps(update_status(json.loads(line[1:])))}")
           sys.stdout.flush()

if __name__ == '__main__':
    main(sys.argv)
