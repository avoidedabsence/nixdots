{ config, pkgs, lib, inputs, userConfig, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # import these in your config in order to use flakes

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen; # for AMD iGPU & nVidia GPU maximum performance, could be changed to legacy kernel or others

  networking.hostName = userConfig.hostname;
  networking.networkmanager.enable = true;

  systemd.services.shadowsocks = lib.mkIf userConfig.enableShadowsocks {
    description = "Shadowsocks-libev proxy";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.shadowsocks-libev}/bin/ss-local \
          -c "${userConfig.shadowsocksConfigPath}"
      '';
      Restart = "always";
    };
  };

  time.timeZone = userConfig.timeZone;

  i18n.defaultLocale = userConfig.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = userConfig.locale;
    LC_IDENTIFICATION = userConfig.locale;
    LC_MEASUREMENT = userConfig.locale;
    LC_MONETARY = userConfig.locale;
    LC_NAME = userConfig.locale;
    LC_NUMERIC = userConfig.locale;
    LC_PAPER = userConfig.locale;
    LC_TELEPHONE = userConfig.locale;
    LC_TIME = userConfig.locale;
  };

  nixpkgs.config.allowUnfree = true;

  services.xserver.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:alt_shift_toggle";
  };
  programs.hyprland.enable = true;

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.nvidia.open = lib.mkIf userConfig.enableNvidia true;
  hardware.nvidia.modesetting.enable = lib.mkIf userConfig.enableNvidia true;

  services.tlp = lib.mkIf userConfig.enableTLP {
    enable = true;
    settings = {
      PCIE_ASPM_ON_BAT = "performance";
      PCIE_ASPM_ON_AC = "performance";
      USB_AUTOSUSPEND = 1;
      RUNTIME_PM_ON_AC = "on";
    };
  };
  services.power-profiles-daemon.enable = false;

  programs.zsh.enable = true;

  users.users.${userConfig.username} = {
    isNormalUser = true;
    description = userConfig.userDescription;
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    home-manager
    stdenv.cc.cc.lib gcc-unwrapped.lib zlib
    shadowsocks-libev
    proxychains-ng # For launching apps under proxy from rofi
    wayland
    grim slurp wl-clipboard
  ];

  fonts.packages = with pkgs; [      
    material-design-icons
    material-symbols
    noto-fonts-emoji
    symbola
    fira
    fira-code
    meslo-lgs-nf
    font-awesome # fuck jetbrains mono
  ];

  services.postgresql.enable = userConfig.enablePostgreSQL;
  services.redis.enable = userConfig.enableRedis;
  services.clickhouse.enable = userConfig.enableClickhouse;

  environment.variables = {
    NIXOS_OZONE_WL = "1";
    LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib pkgs.gcc-unwrapped.lib pkgs.zlib ]; # For numpy / levenshtein support
  };

  system.stateVersion = "25.05";
}
