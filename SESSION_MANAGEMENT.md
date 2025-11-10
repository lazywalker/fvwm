# FVWM Session Management

This FVWM configuration now supports full session saving and restoration, allowing you to save and restore your running applications, window positions, and states across desktop sessions.

## Features

- **Save Running Applications**: Save all currently running applications and their launch commands
- **Automatic Application Restart**: Applications are automatically restarted on next login
- **Save Window Positions**: Save the exact position of all open windows
- **Save Window States**: Save window states (iconified, maximized, shaded, sticky)
- **Save Desktop and Page**: Remember which virtual desktop (0=Main, 1=Code, 2=Play) and which page (0-8 in 3x3 grid) each window was on
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
   - **Save and Quit**: Save session completely, then exit FVWM (waits for save to finish)

### Session File Locations

The session is saved to two files:
- `~/.fvwm/session-apps`: List of running applications and their launch commands
- `~/.fvwm/session`: Window positions, sizes, and states

You can back up these files to preserve your session:
```bash
cp ~/.fvwm/session ~/.fvwm/session.backup
cp ~/.fvwm/session-apps ~/.fvwm/session-apps.backup
```

## Configuration

The session management feature can be configured to match your desktop layout. Edit the `~/.fvwm/scripts/session-config` file to set:

- **FVWM_NUM_DESKTOPS**: Number of virtual desktops (e.g., 3 for Main, Code, Play)
- **FVWM_PAGE_COLS**: Number of page columns in the page grid (e.g., 3 for a 3x3 grid)
- **FVWM_PAGE_ROWS**: Number of page rows in the page grid (e.g., 3 for a 3x3 grid)

**Example configuration:**
```bash
# For 3 desktops with a 3x3 page grid (9 pages per desktop)
FVWM_NUM_DESKTOPS=3
FVWM_PAGE_COLS=3
FVWM_PAGE_ROWS=3
```

**Important:** These values must match your FVWM configuration:
- `FVWM_NUM_DESKTOPS` should match the number of `DesktopName` definitions in your config
- `FVWM_PAGE_COLS` and `FVWM_PAGE_ROWS` should match your `DesktopSize` setting (e.g., `DesktopSize 3x3`)

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
   - Loads configuration from `~/.fvwm/scripts/session-config`
   - Queries all running windows and their processes
   - Calculates which page each window is on (based on window position and screen dimensions)
   - Validates desktop and page numbers against configured limits
   - Extracts the command line that started each application
   - Saves application commands with desktop and page info to `~/.fvwm/session-apps`
   - Saves window positions with desktop and page info to `~/.fvwm/session`

2. **Restore Session** (On Login):
   - Reads `~/.fvwm/session-apps` and restarts each application
   - Waits for windows to appear
   - Reads `~/.fvwm/session` which:
     - Uses `GotoDesk` to switch to the correct desktop
     - Uses `GotoPage` to switch to the correct page
     - Positions windows at their exact location on that page

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
- Verify your configuration matches your FVWM setup in `~/.fvwm/scripts/session-config`
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

**Configuration mismatch:**
- If windows restore to wrong desktops/pages, check `~/.fvwm/scripts/session-config`
- The configuration values must match your FVWM config (`DesktopName` count and `DesktopSize`)
- Example: If config has `DesktopSize 3x3`, set `FVWM_PAGE_COLS=3` and `FVWM_PAGE_ROWS=3`
- After changing the configuration, save a new session with the corrected settings

**Known Limitations:**
- Applications started with complex shell commands may not restore correctly
- Some applications may open multiple windows; only the first window info is saved
- Background processes and daemons are not saved (e.g., system tray apps)
- Terminal sessions with active programs may need manual restoration

## Technical Details

The session management feature uses:

- **fvwm-save-session.sh**: Queries window information and application commands using wmctrl or xprop/xwininfo
- **fvwm-save-and-quit.sh**: Wrapper that saves session completely before quitting FVWM
- **fvwm-restore-session.sh**: Restarts saved applications from their command lines
- **Read**: FVWM command that loads and executes the saved session file
- **Style * SessionMgt**: Enables session management for all windows

### Save Process

The script queries all visible windows and saves:
1. **Application Information** (to `session-apps`):
   - Window class/name
   - Process ID (PID)
   - Command line that started the application
   - Desktop number (0, 1, 2)
   - Page X coordinate (0-2 in 3x3 grid)
   - Page Y coordinate (0-2 in 3x3 grid)

2. **Window Geometry** (to `session`):
   - Position (X, Y coordinates relative to page)
   - Size (width, height)
   - State (maximized, iconified, sticky)
   - Desktop and page assignment

### Application List Format

The `session-apps` file contains:
```bash
# Application: Firefox (PID: 12345)
APP_CLASS="Firefox"
APP_DESKTOP="0"
APP_PAGE_X="1"
APP_PAGE_Y="0"
APP_CMD="/usr/bin/firefox"

# Application: xterm (PID: 12346)
APP_CLASS="xterm"
APP_DESKTOP="1"
APP_PAGE_X="2"
APP_PAGE_Y="1"
APP_CMD="/usr/bin/xterm"
```

### Window Position Format

The `session` file contains FVWM commands:
```fvwm
# Window: Firefox (Class: Firefox, Desktop: 0, Page: 1,0)
Next (Firefox) GotoDesk 0 0
Next (Firefox) GotoPage 1 0
Next (Firefox) ResizeMove 1024p 768p 100p 50p
Next (Firefox) Maximize 100 100

# Window: Terminal (Class: xterm, Desktop: 1, Page: 2,1)
Next (xterm) GotoDesk 0 1
Next (xterm) GotoPage 2 1
Next (xterm) ResizeMove 800p 600p 500p 200p
```

### Restore Process

On login or when loading a session:
1. `fvwm-restore-session.sh` reads `session-apps`
2. Launches each saved application in the background
3. Waits 2-3 seconds for windows to appear
4. FVWM reads `session` file and for each window:
   - Uses `Next (ClassName) GotoDesk 0 N` to switch to the correct desktop
   - Uses `Next (ClassName) GotoPage X Y` to switch to the correct page
   - Uses `Next (ClassName) ResizeMove` to position the window on that page
5. All windows are restored to their exact desktop, page, and position
