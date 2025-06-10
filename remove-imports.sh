#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find and delete all .import files recursively from that directory
find "$SCRIPT_DIR" -type f -name '*.import' -exec rm -v {} \;

echo "All .import files have been removed from $SCRIPT_DIR"
