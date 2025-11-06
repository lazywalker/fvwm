# GitHub Copilot Instructions for FVWM Configuration

## Repository Overview

This repository contains configuration files for FVWM3 (F Virtual Window Manager), a powerful and highly customizable window manager for X11. The configuration includes themes, key bindings, compositor settings, and panel configurations to create a complete desktop environment.

## File Structure

- `config` - Main FVWM3 configuration file (FVWM configuration syntax)
- `picom.conf` - Picom compositor configuration
- `xdgmenu` - XDG menu definitions for application launcher
- `sxhkd/sxhkdrc` - Simple X Hotkey Daemon key bindings configuration
- `tint2/tint2rc` - Tint2 panel configuration
- `themes/` - FVWM themes with decorations and color schemes (e.g., milk, classic, kawaii, etc.)
- `images/` - Image resources organized in subdirectories:
  - `backgrounds/` - Desktop background images
  - `bgicons/` - Background icons
  - `icons/` - General icons including window control icons
  - `launchers/` - Application launcher icons
  - `windowicons/` - Window-specific icons

## Configuration File Syntax

### FVWM Configuration (`config`)

FVWM uses a specific configuration syntax:

- **Commands**: Start with capital letters (e.g., `SetEnv`, `DestroyFunc`, `AddToFunc`)
- **Variables**: Use `$[variable_name]` syntax or environment variables
- **Functions**: Defined with `DestroyFunc` followed by `AddToFunc`
- **Function Actions**: Use prefixes like `+ I` (Immediate), `+ C` (Click), `+ D` (Double Click), `+ M` (Motion)
- **Comments**: Start with `#`
- **Modules**: Loaded with `Module` command (e.g., `Module FvwmPager`)

Example:
```fvwm
DestroyFunc MyFunction
AddToFunc MyFunction
+ I Echo "Immediate action"
+ C Echo "On click"
```

### Environment Variables

- Use `SetEnv` to define environment variables
- Use `InfoStoreAdd` for FVWM internal variables
- Reference with `$[variable_name]` syntax

### Key Bindings (sxhkd)

- Format: `modifier + key` followed by command
- Commented bindings start with `#`
- Use standard modifier names: `super`, `alt`, `ctrl`, `shift`

### Picom Configuration

- Uses standard INI-style syntax with comments starting with `#`
- All configuration lines end with semicolons
- Boolean values are `true`/`false`
- Numeric values can be integers or floats

## Coding Conventions

1. **Comments**: Use descriptive comments with section headers using `#` symbols
2. **Indentation**: Use consistent indentation for function definitions
3. **Naming**: 
   - Use descriptive names for functions and variables
   - Environment variables typically prefixed with `fvwm_` (e.g., `fvwm_home`, `fvwm_terminal`)
   - Functions use CamelCase (e.g., `StartFunction`, `RaiseMoveX`)
4. **Organization**: Group related configurations together with clear section headers
5. **Paths**: Use environment variables for paths instead of hardcoding

## Common Patterns

### Starting Applications

Use `Exec exec` to launch applications in the `StartFunction`:
```fvwm
Exec exec application-name &
```

### Defining Menus

```fvwm
DestroyMenu "MenuName"
AddToMenu "MenuName"
+ "Item Name" Action
```

### Window Styles

```fvwm
Style WindowName [options]
```

## Important Considerations

1. **Test Changes**: FVWM configuration changes typically require restarting the window manager
2. **Path References**: Paths should use environment variables for portability
3. **Module Loading**: Ensure modules are loaded in the correct order
4. **Compatibility**: Consider FVWM3 specific features vs older FVWM versions
5. **Dependencies**: This configuration assumes certain applications are installed (tint2, picom, sxhkd, etc.)

## When Making Changes

- Maintain the existing structure and organization
- Follow the established naming conventions
- Keep configurations modular and well-commented
- Preserve backward compatibility where possible
- Use environment variables for paths and application references
- Test that syntax is valid for FVWM3
