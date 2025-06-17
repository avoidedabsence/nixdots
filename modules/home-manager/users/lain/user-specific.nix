{
  config,
  pkgs,
  lib,
  inputs,
  ... 
}:

let
  dotfilesDir = ../../../../dotfiles;
in
{
  home.packages = with pkgs; [
    kitty 
    zsh-powerlevel10k 

    waybar
    mako 
    rofi-wayland 
    hyprlock
    hyprshot
    hypridle
    swaybg 
    neofetch
    killall
    firefox
    spotify
    vscode
    telegram-desktop
    pavucontrol 
    networkmanagerapplet 
    xfce.thunar
    
    git 
    python313
    playerctl
    poetry
    ruff
    postman 
    btop 
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initExtra = ''

      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';

  };
  
  programs.kitty = {
    enable = trun=e;
    font = {
      name = "FiraCode Nerd Font Mono"; 
      size = 11;
    };
    
    settings = {
      
      linux_display_server = "wayland";
      scrollback_lines = 2000;
      enable_audio_bell = false;
      
    };
  };

  xdg.configFile = {
    "kitty/kitty.conf".source = "${dotfilesDir}/kitty/kitty.conf"; 
  };
  
  
  home.file = {
    ".config/hypr/hyprland.conf".source = lib.mkDefault "${dotfilesDir}/hypr/hyprland.conf"; 
    ".config/hypr/wp.jpg".source = lib.mkDefault "${dotfilesDir}/hypr/wp.jpg"; 
    
    ".config/waybar/config.jsonc".source = lib.mkDefault "${dotfilesDir}/waybar/config.jsonc"; 
    ".config/waybar/mocha.css".source = lib.mkDefault "${dotfilesDir}/waybar/mocha.css"; 
    ".config/waybar/style.css".source = lib.mkDefault "${dotfilesDir}/waybar/style.css"; 
    
    ".config/waybar/custom/focus_class.sh".source = lib.mkDefault "${dotfilesDir}/waybar/custom/focus_class.sh"; 
    ".config/waybar/custom/spotify/mediaplayer.py".source = lib.mkDefault "${dotfilesDir}/waybar/custom/spotify/mediaplayer.py"; 

    
    ".config/rofi/colors.rasi".source = lib.mkDefault "${dotfilesDir}/rofi/colors.rasi"; 
    ".config/rofi/config.rasi".source = lib.mkDefault "${dotfilesDir}/rofi/config.rasi"; 
    ".config/rofi/fonts.rasi".source = lib.mkDefault "${dotfilesDir}/rofi/fonts.rasi"; 

    ".config/neofetch/config.conf".source = lib.mkDefault "${dotfilesDir}/neofetch/config.conf"; 

    ".config/mako/config".source = lib.mkDefault "${dotfilesDir}/mako/config"; 
  };

  
  home.activation.copyWaybarScripts = lib.hm.dag.entryAfter ["writeBoundary"] ''
    chmod +x ${config.home.homeDirectory}/.config/waybar/custom/*
    chmod +x ${config.home.homeDirectory}/.config/waybar/custom/spotify/*
  '';
  
  programs.git = {
    enable = true;
    userName = "alexey";
    userEmail = "schwartzalexey@yandex.com"; 
  };
  
  programs.vscode = {
    enable = true;
  };
  
  home.sessionVariables = {
    EDITOR = "code"; 
    TERM = "kitty";   
  };
  
  home.stateVersion = "25.05"; 
}
