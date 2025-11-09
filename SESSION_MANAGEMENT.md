# FVWM Session Management

This FVWM configuration now supports session saving and restoration, allowing you to save and restore your window positions and states across desktop sessions.

## Features

- **Save Window Positions**: Save the exact position of all open windows
- **Save Window States**: Save window states (iconified, maximized, shaded, sticky)
- **Save Desk and Page**: Remember which virtual desktop and page each window was on
- **Automatic Restore**: Windows are automatically restored on FVWM startup
- **Manual Control**: Save and load sessions manually at any time

## Usage

### Automatic Session Restoration

When you start FVWM, if a saved session file exists at `~/.fvwm/session`, it will be automatically loaded and your windows will be restored to their previous positions and states.

### Manual Session Operations

#### Using Keyboard Shortcuts

- **Ctrl+Alt+S**: Save the current session
- **Ctrl+Alt+L**: Load a previously saved session

#### Using the Menu

Right-click on the desktop to open the root menu, then:

1. Select "Session" from the menu
2. Choose from:
   - **Save Session**: Save current window layout
   - **Load Session**: Restore previously saved session
   - **Save and Quit**: Save session and exit FVWM

### Session File Location

The session is saved to: `~/.fvwm/session`

You can back up this file to preserve your layout:
```bash
cp ~/.fvwm/session ~/.fvwm/session.backup
```

## Requirements

The session save functionality requires one of the following tools to be installed:
- **wmctrl** (recommended) - Install with: `sudo apt install wmctrl` or `sudo pacman -S wmctrl`
- **xprop** and **xwininfo** (fallback) - Usually pre-installed with X11

To check if you have the required tools:
```bash
which wmctrl xprop xwininfo
```

## Important Notes

### Application Support

- **Window Positions**: All windows will have their positions and states saved
- **Application Restart**: FVWM saves window geometry and states, but applications themselves are NOT automatically restarted
- **Manual Restart**: After restoring a session, you need to manually open your applications again, and they will be positioned correctly

### Best Practices

1. **Regular Saves**: Use Ctrl+Alt+S to save your session when you have a good window layout
2. **Before Logout**: Use "Save and Quit" from the Session menu to ensure your layout is saved
3. **Multiple Layouts**: You can manually copy the session file to save different layouts:
   ```bash
   cp ~/.fvwm/session ~/.fvwm/session.work
   cp ~/.fvwm/session ~/.fvwm/session.home
   ```

### Troubleshooting

**Session file not being created:**
- Install wmctrl: `sudo apt install wmctrl` or `sudo pacman -S wmctrl`
- Make sure you have some windows open when saving
- Check that `~/.fvwm/scripts/fvwm-save-session.sh` exists and is executable
- Run manually to test: `~/.fvwm/scripts/fvwm-save-session.sh ~/.fvwm/session`

**Windows not restoring to correct positions:**
- Make sure you saved the session with Ctrl+Alt+S before logging out
- Check that `~/.fvwm/session` file exists and contains window commands
- View the session file: `cat ~/.fvwm/session`
- Open your applications first, then press Ctrl+Alt+L to restore positions

**Applications not restarting:**
- This is expected - FVWM saves window positions only, not running applications
- You need to manually start your applications after login
- Once applications are running, press Ctrl+Alt+L to restore their positions

## Technical Details

The session management feature uses:

- **fvwm-save-session.sh**: A shell script that queries window information using wmctrl or xprop/xwininfo
- **Read**: FVWM command that loads and executes the saved session file
- **Style * SessionMgt**: Enables session management for all windows

The script queries all visible windows and saves their:
- Window class/name
- Position (X, Y coordinates)
- Size (width, height)
- State (maximized, iconified, sticky)
- Desktop number

The session file contains FVWM commands like:
```fvwm
# Window: Firefox
Next (Firefox, CurrentDesk) ResizeMove 1024p 768p 100p 50p
Next (Firefox, CurrentDesk) Maximize 100 100

# Window: Terminal
Next (xterm, CurrentDesk) ResizeMove 800p 600p 500p 200p
```

These commands are executed when you load the session, positioning any windows that match the saved class names.
