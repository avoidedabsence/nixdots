{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix  # Comment out for flake usage
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  
  #  networking.tun.enable = true;
  networking.hostName = "navi";
  networking.networkmanager.enable = true;
  
  systemd.services.shadowsocks = {
    description = "Shadowsocks-libev proxy";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.shadowsocks-libev}/bin/ss-local \
          -c "/home/lain/proj/cfg.json"
      '';
      Restart = "always";
    };
  };
  
  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

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
  
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;
  services.tlp = { 
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

  users.users.lain = {
    isNormalUser = true;
    description = "lain";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Terminal
    zsh kitty zsh-powerlevel10k
    # System necessities
    home-manager stdenv.cc.cc.lib gcc-unwrapped.lib shadowsocks-libev proxychains zlib
    # Desktop environment necessities
    hyprland xfce.thunar wayland waybar mako
    # Fonts
    nerd-fonts.fira-code material-design-icons material-symbols noto-fonts-emoji symbola fira fira-code meslo-lgs-nf font-awesome 
    # Programs
    firefox spotify vscode telegram-desktop
    # DevOps & other development stuff
    git postgresql redis clickhouse python3 poetry postman ruff btop
    # Eye-candy & comfort
    pavucontrol networkmanagerapplet rofi hyprlock hyprshot hypridle swaybg neofetch killall
    # Screenshots
    grim slurp wl-clipboard
  ];

  services.postgresql.enable = true;
  services.redis.enable = true;
  services.clickhouse = {
    enable = true;
    package = pkgs.clickhouse;
  };
  
  environment.variables.EDITOR = "code";
  environment.variables.TERM = "kitty";  
  environment.variables.NIXOS_OZONE_WL = "1";
  environment.variables.LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.gcc-unwrapped.lib}/lib:$LD_LIBRARY_PATH";
  system.stateVersion = "25.05";
}
