#!/bin/bash
# FVWM Save Session and Quit Script
# Saves the session and then signals FVWM to quit

SESSION_FILE="${1:-$HOME/.fvwm/session}"

# Run the save session script and wait for it to complete
"$(dirname "$0")/fvwm-save-session.sh" "$SESSION_FILE"

# Now signal FVWM to quit
# Use FvwmCommand if available, otherwise use kill
if command -v FvwmCommand &> /dev/null; then
    FvwmCommand "Quit"
else
    # Find FVWM process and send quit signal
    pkill -TERM fvwm3 || pkill -TERM fvwm
fi
