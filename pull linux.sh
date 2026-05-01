#!/bin/bash

# Get the directory where this script is located
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_DIR" || exit

# The commands to run
CMD="echo 'Updating repository in $REPO_DIR...'; git fetch --all && git pull; echo 'Done!'; exec bash"

# Open in a new terminal window
if command -v gnome-terminal &> /dev/null; then
    gnome-terminal -- bash -c "$CMD"
elif command -v xterm &> /dev/null; then
    xterm -e bash -c "$CMD"
elif command -v konsole &> /dev/null; then
    konsole -e bash -c "$CMD"
else
    # Fallback if no GUI terminal is detected
    eval "$CMD"
fi

read -rsp $'Press any key or wait 5 seconds to continue...\n' -n 1 -t 5;