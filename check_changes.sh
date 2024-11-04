#!/bin/bash

# Directory to watch
WATCH_DIR="/mnt/gaia/"
# File to store the last checksum
CHECKSUM_FILE="/tmp/gaia_checksum.txt"
# Command to run
COMMAND="npx quartz sync"

# Calculate the current checksum of the directory
CURRENT_CHECKSUM=$(find "$WATCH_DIR" -type f -exec md5sum {} + | md5sum)

# Check if the checksum file exists
if [[ -f "$CHECKSUM_FILE" ]]; then
    # Compare with the last recorded checksum
    LAST_CHECKSUM=$(cat "$CHECKSUM_FILE")
    if [[ "$CURRENT_CHECKSUM" != "$LAST_CHECKSUM" ]]; then
        echo "Changes detected in $WATCH_DIR. Running command..."
        cd /usr/src/quartz || exit
        $COMMAND
        echo "Command executed."
        # Update the checksum file
        echo "$CURRENT_CHECKSUM" > "$CHECKSUM_FILE"
    else
        echo "No changes detected in $WATCH_DIR."
    fi
else
    # If the checksum file doesn't exist, create it
    echo "$CURRENT_CHECKSUM" > "$CHECKSUM_FILE"
fi
