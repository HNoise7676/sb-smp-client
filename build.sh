#!/bin/bash

# Check for uv
if ! command -v uv &> /dev/null; then
    echo "[!] uv not found. Installing..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source $HOME/.cargo/env
fi

echo "Launching SB-SMP Builder..."
uv run build.py
