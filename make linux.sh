#!/bin/bash

# Get the directory where this script is located
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_DIR" || exit

# The command logic:
# 1. Check if uv is installed
# 2. Check if make.py exists
# 3. Run or error out
CMD="
if ! command -v uv &> /dev/null; then
    echo 'Error: uv is not installed. Please install it from https://astral.sh/uv';
    echo '';
    read -n 1 -s -r -p 'Press any key to close...';
elif [ ! -f make.py ]; then
    echo 'Error: make.py not found in $REPO_DIR';
    sleep 3;
else
    echo 'Running make.py with uv...';
    uv run make.py;
    echo 'Process finished!';
    sleep 3;
fi"

# Priority list: Konsole -> Gnome Terminal -> Xterm
if command -v konsole &> /dev/null; then
    konsole -e bash -c "$CMD" &
elif command -v gnome-terminal &> /dev/null; then
    gnome-terminal -- bash -c "$CMD" &
elif command -v xterm &> /dev/null; then
    xterm -e bash -c "$CMD" &
else
    eval "$CMD"
    exit 0
fi

disown
exit 0