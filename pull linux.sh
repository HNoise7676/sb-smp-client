#!/bin/bash

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_DIR" || exit

# Removed 'exec bash' so the process ends after sleep
CMD="echo 'Updating repository in $REPO_DIR...'; git fetch --all && git pull; echo 'Done!'; sleep 3"

if command -v konsole &> /dev/null; then
    # Note: Modern Konsole versions often prefer --noclose or -e 
    # To ensure it closes, we simply run the command.
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