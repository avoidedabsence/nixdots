# lain@nixdots

## Installation

1. Enable **nix-command** and **flakes**, as they are experimental features

   ```nix
   nix.settings.experimental-features = [ "nix-command" "flakes" ];
   ```

2. Switch to:

   - the **whole** flake: `sudo nixos-rebuild switch --flake .#navi`

   - only the **home-manager** (dots w/o hardware, be sure to have all needed desktop env enabled): `home-manager switch --flake .#lain`

## Optionally

You can change **hostname** and **username** by slightly tweaking the `flake.nix` (change *navi* and *lain* to wanted) and renaming the `modules/home-manager/users/lain` directory.

Also, there is a **shadowsocks-libev** service that automatically starts shadowsocks proxy from `~/proj/conf.json` directory. Comment it out, if you do not need it.

## TODO

- [ ] ZSH
- [x] Telegram
- [ ] Spicetify
- [x] Tweaks on waybar, rofi

### Telegram theme

Theme for desktop can be installed here: [*boop*](https://t.me/addtheme/wh60qgGElK6HaBES), although its kinda raw so i will be improving it on the way
