{ config, pkgs, lib, inputs, userConfig, ... }:

{
  nix.settings = {
    warn-dirty = false;
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ]; # import these in your config in order to use flakes
  };

  nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 7d";
	}; 

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen; # for AMD iGPU & nVidia GPU maximum performance, could be changed to legacy kernel or others

  networking.hostName = userConfig.hostname;
  networking.networkmanager.enable = true;

  networking.extraHosts = ''
    127.0.0.1 myapp.lc
  '';

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

  programs.proxychains = {
    enable = true;
    proxies = {
      main = {
        type = "socks5";
        host = "127.0.0.1";
        port = 1080;
      };
    };
    chain.type = "dynamic";
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
  programs.zsh.enable = true; # idk why

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  hardware.nvidia = lib.mkIf userConfig.enableNvidia {
    open = true; 
    modesetting.enable = true; 
    powerManagement.enable = false;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true; 
  };

  services.tlp = lib.mkIf userConfig.enableTLP {
    enable = true;
    settings = {
      RADEON_DPM_PERF_LEVEL_ON_AC = "high";
      RADEON_DPM_PERF_LEVEL_ON_BAT = "high";
      RADEON_DPM_STATE_ON_AC = "performance";
      RADEON_DPM_STATE_ON_BAT = "performance";
      
      PCIE_ASPM_ON_AC = "performance";
      PCIE_ASPM_ON_BAT = "performance";
      
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
      
      USB_AUTOSUSPEND = 0;
    };
  };
  
  services.power-profiles-daemon.enable = false;

  users.users.${userConfig.username} = {
    isNormalUser = true;
    description = userConfig.userDescription;
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    home-manager
    stdenv.cc.cc.lib gcc-unwrapped.lib zlib gnumake
    shadowsocks-libev openssl # For launching apps under proxy from rofi
    wayland
    obs-studio
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

  virtualisation.docker.enable = userConfig.enableDocker;

  users.extraGroups.docker.members = lib.mkIf userConfig.enableDocker [ userConfig.username ];

  services.postgresql.enable = userConfig.enablePostgreSQL;
  services.redis.enable = userConfig.enableRedis;
  services.clickhouse.enable = userConfig.enableClickhouse;

  services.flatpak.enable = true;

  environment.variables = {
    NIXOS_OZONE_WL = "1";
    LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib pkgs.gcc-unwrapped.lib pkgs.zlib ]; # For numpy / levenshtein support
  };

  system.stateVersion = "25.11";
}
