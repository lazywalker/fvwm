# FVWM3 Configuration

A customized FVWM3 window manager configuration with enhanced features.

## Features

- **Session Management**: Save and restore window positions and states across logins
  - See [SESSION_MANAGEMENT.md](SESSION_MANAGEMENT.md) for details
  - Keyboard shortcuts: Ctrl+Alt+S (save), Ctrl+Alt+L (load)
  - Menu access via root menu → Session
- Virtual desktops and page navigation
- Customizable window decorations and themes
- Integrated tint2 panel and system tray
- Multiple keyboard shortcuts for window management

## Installation

1. Copy this configuration to `~/.fvwm/`:
   ```bash
   cp -r * ~/.fvwm/
   ```

2. Start or restart FVWM3

## Session Management

This configuration includes built-in session save and restore functionality. Your window layouts will be automatically restored on next login.

For detailed information, see [SESSION_MANAGEMENT.md](SESSION_MANAGEMENT.md).
