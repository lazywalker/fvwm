# FVWM Session Management Scripts

This directory contains scripts for saving and restoring FVWM sessions.

## Scripts

- **session-config** - Configuration file for desktop and page layout
- **fvwm-save-session.sh** - Saves current window positions and running applications
- **fvwm-restore-session.sh** - Restores saved applications
- **fvwm-save-and-quit.sh** - Saves session and quits FVWM

## Configuration

The `session-config` file contains settings that must match your FVWM configuration:

### FVWM_NUM_DESKTOPS

The number of virtual desktops defined in your FVWM config.

**Example:** If your config has:
```fvwm
DesktopName 0 Main
DesktopName 1 Code
DesktopName 2 Play
```
Then set: `FVWM_NUM_DESKTOPS=3`

### FVWM_PAGE_COLS and FVWM_PAGE_ROWS

The page grid dimensions defined in your FVWM config.

**Example:** If your config has:
```fvwm
DesktopSize 3x3
```
Then set:
```bash
FVWM_PAGE_COLS=3
FVWM_PAGE_ROWS=3
```

This creates a 3x3 grid of pages (9 pages total per desktop).

## How It Works

1. **Save Session**: The save script queries all window positions and calculates which desktop and page each window is on using the configured grid dimensions.

2. **Page Calculation**: 
   - Page X = (window X position) / (screen width)
   - Page Y = (window Y position) / (screen height)
   - Results are capped to the configured page grid bounds

3. **Desktop Validation**: Desktop numbers are validated against the configured number of desktops.

4. **Restore Session**: Applications are restarted, and FVWM applies saved window positions.

## Changing Your Layout

If you change your desktop or page layout:

1. Update your FVWM config file (`~/.fvwm/config`):
   - Modify `DesktopName` entries
   - Update `DesktopSize` setting

2. Update `session-config`:
   - Set `FVWM_NUM_DESKTOPS` to match the number of desktops
   - Set `FVWM_PAGE_COLS` and `FVWM_PAGE_ROWS` to match `DesktopSize`

3. Restart FVWM

4. Save a new session with the updated configuration

## Examples

### Two Desktops with 2x2 Page Grid

**FVWM config:**
```fvwm
DesktopName 0 Work
DesktopName 1 Personal
DesktopSize 2x2
```

**session-config:**
```bash
FVWM_NUM_DESKTOPS=2
FVWM_PAGE_COLS=2
FVWM_PAGE_ROWS=2
```

### Four Desktops with 4x1 Page Grid

**FVWM config:**
```fvwm
DesktopName 0 Main
DesktopName 1 Code
DesktopName 2 Web
DesktopName 3 Media
DesktopSize 4x1
```

**session-config:**
```bash
FVWM_NUM_DESKTOPS=4
FVWM_PAGE_COLS=4
FVWM_PAGE_ROWS=1
```

## Default Configuration

If `session-config` is missing, the scripts will use these defaults:
- 3 desktops
- 3x3 page grid (9 pages per desktop)

## See Also

For more information about session management, see the main `SESSION_MANAGEMENT.md` file in the repository root.
