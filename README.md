# Desktop Environment Flake - Hyprland Setup

This flake recreates a complete Hyprland-based desktop environment on any NixOS machine.

## Features

- **Hyprland** window manager with custom configuration
- **Waybar** status bar with custom styling
- **Kitty** terminal with custom colors and transparency
- **Rofi** application launcher
- **ZSH** with Oh My Zsh and Powerlevel10k theme
- Custom keybindings and workspace setup
- NVIDIA graphics support
- Complete theming and font configuration

## Prerequisites

- NixOS system with flakes enabled
- Git installed

## Installation

### Option 1: Home Manager only (recommended for existing systems)

```bash
# Clone the configuration
git clone <this-repo> ~/desktop-flake
cd ~/desktop-flake

# Copy your wallpaper to the hypr directory
cp /path/to/your/wallpaper.jpg hypr/wp.jpg

# Copy your p10k configuration
cp ~/.p10k.zsh ./.p10k.zsh

# Apply the configuration
home-manager switch --flake .#lain
```

### Option 2: Full NixOS system

```bash
# Clone to /etc/nixos
sudo git clone <this-repo> /etc/nixos/desktop-flake
cd /etc/nixos/desktop-flake

# Edit hardware-configuration.nix to match your system
sudo cp /etc/nixos/hardware-configuration.nix ./

# Copy your wallpaper and p10k config (same as above)

# Apply the configuration
sudo nixos-rebuild switch --flake .#desktop
```

## Customization

### Monitor Configuration
Edit the monitor settings in `home.nix`:
```nix
monitor = [
  "your-monitor-description,resolution@refresh,position,scale"
];
```

### Keybindings
All keybindings use Super (Windows) key as the main modifier:
- `Super + Q` - Open terminal (Kitty)
- `Super + C` - Close active window
- `Super + E` - Open file manager (Thunar)
- `Super + R` - Open application launcher (Rofi)
- `Super + 1-6` - Switch to workspace
- `Super + Shift + 1-6` - Move window to workspace

### Colors and Themes
The color scheme is defined in multiple places:
- Kitty colors in `programs.kitty.settings`
- Waybar colors in `services.waybar.style`
- Rofi colors in `home.file.".config/rofi/colors.rasi"`

### Adding Applications
Add packages to the `home.packages` list in `home.nix`. Note that many packages are already defined in `configuration.nix` to avoid duplication.

## File Structure

- `flake.nix` - Main flake configuration
- `home.nix` - Home Manager configuration
- `configuration.nix` - NixOS system configuration
- `hypr/` - Hyprland configuration and assets
- `README.md` - This file

## Troubleshooting

### Fonts not working
Make sure to copy your `.p10k.zsh` file and that the MesloLGS NF font is properly installed.

### Wallpaper not showing
Copy your wallpaper to `hypr/wp.jpg` or update the path in the Hyprland configuration.

### NVIDIA issues
The configuration includes NVIDIA-specific settings. If you're using different graphics hardware, comment out the NVIDIA-related lines in `configuration.nix`.

## Notes

- This configuration assumes a dual-monitor setup. Adjust monitor configurations as needed.
- Some network-specific autoconnect commands are included - remove or modify as needed.
- The configuration includes development tools (PostgreSQL, Redis, ClickHouse) - remove if not needed.
