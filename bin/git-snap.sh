#!/bin/bash

set -euo pipefail

git add .
git commit -a -m "snap"
git push
