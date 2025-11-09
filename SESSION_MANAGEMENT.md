# FVWM Session Management

This FVWM configuration now supports full session saving and restoration, allowing you to save and restore your running applications, window positions, and states across desktop sessions.

## Features

- **Save Running Applications**: Save all currently running applications and their launch commands
- **Automatic Application Restart**: Applications are automatically restarted on next login
- **Save Window Positions**: Save the exact position of all open windows
- **Save Window States**: Save window states (iconified, maximized, shaded, sticky)
- **Save Desk and Page**: Remember which virtual desktop and page each window was on
- **Automatic Restore**: Applications and windows are automatically restored on FVWM startup
- **Manual Control**: Save and load sessions manually at any time

## Usage

### Automatic Session Restoration

When you start FVWM, if saved session files exist:
1. Saved applications will be automatically restarted (`~/.fvwm/session-apps`)
2. After a brief delay, window positions and states will be restored (`~/.fvwm/session`)

This means your complete desktop environment, including running applications and their positions, will be restored automatically on login.

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

### Session File Locations

The session is saved to two files:
- `~/.fvwm/session-apps`: List of running applications and their launch commands
- `~/.fvwm/session`: Window positions, sizes, and states

You can back up these files to preserve your session:
```bash
cp ~/.fvwm/session ~/.fvwm/session.backup
cp ~/.fvwm/session-apps ~/.fvwm/session-apps.backup
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

- **Full Session Save**: All running applications and their launch commands are saved
- **Automatic Application Restart**: Applications are automatically restarted on next login
- **Window Positions**: All windows will have their positions and states restored
- **Desktop/Page Preservation**: Applications will be restored to their correct virtual desktop and page

### How It Works

1. **Save Session** (Ctrl+Alt+S):
   - Queries all running windows and their processes
   - Extracts the command line that started each application
   - Saves application commands to `~/.fvwm/session-apps`
   - Saves window positions to `~/.fvwm/session`

2. **Restore Session** (On Login):
   - Reads `~/.fvwm/session-apps` and restarts each application
   - Waits for windows to appear
   - Reads `~/.fvwm/session` and positions windows correctly

### Best Practices

1. **Regular Saves**: Use Ctrl+Alt+S to save your session when you have a good desktop setup
2. **Before Logout**: Use "Save and Quit" from the Session menu to ensure your session is saved
3. **Multiple Sessions**: You can manually copy the session files to save different layouts:
   ```bash
   cp ~/.fvwm/session ~/.fvwm/session.work
   cp ~/.fvwm/session-apps ~/.fvwm/session-apps.work
   ```
4. **Clean Start**: Delete session files if you want a fresh start:
   ```bash
   rm ~/.fvwm/session ~/.fvwm/session-apps
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

**Applications not restarting automatically:**
- Check that `~/.fvwm/session-apps` file exists and contains application commands
- View the app list: `cat ~/.fvwm/session-apps`
- Make sure scripts are executable: `chmod +x ~/.fvwm/scripts/*.sh`
- Test restore manually: `~/.fvwm/scripts/fvwm-restore-session.sh ~/.fvwm`
- Some applications may need special handling (see below)

**Known Limitations:**
- Applications started with complex shell commands may not restore correctly
- Some applications may open multiple windows; only the first window info is saved
- Background processes and daemons are not saved (e.g., system tray apps)
- Terminal sessions with active programs may need manual restoration

## Technical Details

The session management feature uses:

- **fvwm-save-session.sh**: Queries window information and application commands using wmctrl or xprop/xwininfo
- **fvwm-restore-session.sh**: Restarts saved applications from their command lines
- **Read**: FVWM command that loads and executes the saved session file
- **Style * SessionMgt**: Enables session management for all windows

### Save Process

The script queries all visible windows and saves:
1. **Application Information** (to `session-apps`):
   - Window class/name
   - Process ID (PID)
   - Command line that started the application
   - Desktop number

2. **Window Geometry** (to `session`):
   - Position (X, Y coordinates)
   - Size (width, height)
   - State (maximized, iconified, sticky)
   - Desktop/page assignment

### Application List Format

The `session-apps` file contains:
```bash
# Application: Firefox (PID: 12345)
APP_CLASS="Firefox"
APP_DESKTOP="0"
APP_CMD="/usr/bin/firefox"

# Application: xterm (PID: 12346)
APP_CLASS="xterm"
APP_DESKTOP="1"
APP_CMD="/usr/bin/xterm"
```

### Window Position Format

The `session` file contains FVWM commands:
```fvwm
# Window: Firefox (Class: Firefox)
Next (Firefox, CurrentDesk) ResizeMove 1024p 768p 100p 50p
Next (Firefox, CurrentDesk) Maximize 100 100

# Window: Terminal (Class: xterm)
Next (xterm, CurrentDesk) ResizeMove 800p 600p 500p 200p
```

### Restore Process

On login or when loading a session:
1. `fvwm-restore-session.sh` reads `session-apps`
2. Launches each saved application in the background
3. Waits 2-3 seconds for windows to appear
4. FVWM reads `session` file and positions windows using the `Next` command
5. Windows that match the saved class names are positioned correctly
