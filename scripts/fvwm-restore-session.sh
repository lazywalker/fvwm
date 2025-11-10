#!/bin/bash
# FVWM Session Restore Script
# Restarts saved applications and restores window positions

SESSION_DIR="${1:-$HOME/.fvwm}"
APP_LIST_FILE="${SESSION_DIR}/session-apps"
SESSION_FILE="${SESSION_DIR}/session"

# Check if application list exists
if [ ! -f "$APP_LIST_FILE" ]; then
    echo "No saved applications found at: $APP_LIST_FILE"
    echo "Only restoring window positions (if any)"
    exit 0
fi

echo "Restoring session applications..."

# Read and launch applications
APP_CLASS=""
APP_DESKTOP=""
APP_PAGE_X=""
APP_PAGE_Y=""
APP_CMD=""

while IFS= read -r line; do
    # Skip comments and empty lines
    [[ "$line" =~ ^#.*$ ]] && continue
    [[ -z "$line" ]] && {
        # End of an app block - launch it if we have all info
        if [ -n "$APP_CLASS" ] && [ -n "$APP_CMD" ]; then
            echo "Launching: $APP_CLASS on Desktop $APP_DESKTOP, Page ($APP_PAGE_X,$APP_PAGE_Y)"
            echo "  Command: $APP_CMD"
            
            # Launch in background
            (
                eval "$APP_CMD" &>/dev/null &
            )
            
            # Small delay to let application start
            sleep 0.5
        fi
        
        # Reset for next app
        APP_CLASS=""
        APP_DESKTOP=""
        APP_PAGE_X=""
        APP_PAGE_Y=""
        APP_CMD=""
        continue
    }
    
    # Parse app information
    if [[ "$line" =~ ^APP_CLASS=\"(.*)\"$ ]]; then
        APP_CLASS="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ ^APP_DESKTOP=\"(.*)\"$ ]]; then
        APP_DESKTOP="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ ^APP_PAGE_X=\"(.*)\"$ ]]; then
        APP_PAGE_X="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ ^APP_PAGE_Y=\"(.*)\"$ ]]; then
        APP_PAGE_Y="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ ^APP_CMD=\"(.*)\"$ ]]; then
        APP_CMD="${BASH_REMATCH[1]}"
    fi
done < "$APP_LIST_FILE"

# Handle last app if file doesn't end with empty line
if [ -n "$APP_CLASS" ] && [ -n "$APP_CMD" ]; then
    echo "Launching: $APP_CLASS on Desktop $APP_DESKTOP, Page ($APP_PAGE_X,$APP_PAGE_Y)"
    echo "  Command: $APP_CMD"
    (
        eval "$APP_CMD" &>/dev/null &
    )
fi

echo "Application launch complete. Waiting for windows to appear..."

# Wait a bit for applications to create their windows
sleep 2

echo "Session restore complete. Window positions will be applied automatically."
