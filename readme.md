# avoidedabsence@dotfiles

## Quick Setup

1. **Edit `config.nix`** to customize hostname, services & etc.

2. **Enable nix-command and flakes** (experimental features):

   ```nix
   nix.settings.experimental-features = [ "nix-command" "flakes" ];
   ```

3. **Copy your hardware configuration**:

   ```bash
   sudo nixos-generate-config --show-hardware-config > modules/hardware/hardware-configuration.nix
   ```

4. **Switch to the flake**:
   - **Full system**: `sudo nixos-rebuild switch --flake .#your-hostname`
   - **Home-manager only**: `home-manager switch --flake .#your-username`

## Configuration Options

All customizable options are in `config.nix`:

- **System Identity**: hostname username and desc
- **Localization**: timezone and locale
- **Hardware**: gpu drivers and power management
- **Services**: Shadowsocks, PostgreSQL, Redis, ClickHouse -- some development tools

## Advanced Customization

### Dotfiles

All dotfiles are stored in the `dotfiles/` directory and are automatically linked to your home directory.

In order to make changes to the DE, reinstantiate home-manager: `home-manager switch --flake .#your-username`

### Telegram theme

Theme for desktop can be installed here: [*boop*](https://t.me/addtheme/wh60qgGElK6HaBES), although its kinda raw so i will be improving it on the way

## TODO

- [x] Telegram
- [x] Tweaks on waybar, rofi
- [ ] ZSH
- [ ] Spicetify
