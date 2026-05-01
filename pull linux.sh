#!/bin/bash

# Get the directory where this script is located
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_DIR" || exit

# The commands to run: 
# 1. Update git 2. Print Done 3. Sleep 3 seconds 4. Open bash
CMD="echo 'Updating repository in $REPO_DIR...'; git fetch --all && git pull; echo 'Done!'; sleep 3; exec bash"

# Priority list: Konsole -> Gnome Terminal -> Xterm
if command -v konsole &> /dev/null; then
    konsole -e bash -c "$CMD" &
elif command -v gnome-terminal &> /dev/null; then
    gnome-terminal -- bash -c "$CMD" &
elif command -v xterm &> /dev/null; then
    xterm -e bash -c "$CMD" &
else
    # Fallback to current window
    eval "$CMD"
    exit 0
fi

# Disown the background terminal so this script can close fully
disown
exit 0