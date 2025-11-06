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

## Important Notes

### Application Support

- **Window Positions**: All windows will have their positions and states saved
- **Application Restart**: FVWM saves window geometry and states, but applications themselves need to support X Session Management (SM) to automatically restart
- **SM-Aware Applications**: Applications like Firefox, Thunderbird, terminals (with proper configuration) that support SM will automatically restart when you log back in

### Best Practices

1. **Regular Saves**: Use Ctrl+Alt+S to save your session when you have a good window layout
2. **Before Logout**: Use "Save and Quit" from the Session menu to ensure your layout is saved
3. **Multiple Layouts**: You can manually copy the session file to save different layouts:
   ```bash
   cp ~/.fvwm/session ~/.fvwm/session.work
   cp ~/.fvwm/session ~/.fvwm/session.home
   ```

### Troubleshooting

**Windows not restoring to correct positions:**
- Make sure you saved the session with Ctrl+Alt+S before logging out
- Check that `~/.fvwm/session` file exists
- Verify that SessionMgt is enabled in the config (it is by default)

**Applications not restarting:**
- This is expected - FVWM saves window positions, not application states
- Use a full session manager (like xfce4-session or gnome-session) if you need automatic application restart
- Some applications (like Firefox) have their own session restore features

## Technical Details

The session management feature uses FVWM's built-in commands:

- `SaveSession`: Writes window information to the session file
- `Read`: Loads and applies the saved session
- `Style * SessionMgt`: Enables session management for all windows

The session file contains FVWM commands that recreate window positions and states.
