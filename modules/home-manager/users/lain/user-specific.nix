
{
  config,
  pkgs,
  lib,
  inputs,
  ... 
}:

let
  
  
  dotfilesDir = ../../../dotfiles;
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
    (xfce.thunar.override { plugins = [ xfce.thunar-archive-plugin xfce.thunar-media-tags-plugin ]; }) 

    
    git
    
    
    python3.withPackages (ps: with ps; [ poetry ruff ]) 
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
    enable = true;
    font = {
      name = "FiraCode Nerd Font Mono"; 
      size = 11;
    };
    
    settings = {
      
      linux_display_server = "wayland";
      scrollback_lines = 2000;
      enable_audio_bell = false;
      
    };
    
    configFile = ../../../dotfiles/kitty/kitty.conf; 
  };

  
  
  
  home.file = {
    ".config/hypr/hyprland.conf".source = lib.mkDefault ../../../dotfiles/hypr/hyprland.conf;
    ".config/hypr/wp.jpg".source = lib.mkDefault ../../../dotfiles/hypr/wp.jpg;
    
    ".config/waybar/config.jsonc".source = lib.mkDefault ../../../dotfiles/waybar/config.jsonc;
    ".config/waybar/mocha.css".source = lib.mkDefault ../../../dotfiles/waybar/mocha.css;
    ".config/waybar/style.css".source = lib.mkDefault ../../../dotfiles/waybar/style.css;
    
    ".config/waybar/custom/focus_class.sh".source = lib.mkDefault ../../../dotfiles/waybar/custom/focus_class.sh;
    ".config/waybar/custom/spotify/mediaplayer.py".source = lib.mkDefault ../../../dotfiles/waybar/custom/spotify/mediaplayer.py;

    
    ".config/rofi/colors.rasi".source = lib.mkDefault ../../../dotfiles/rofi/colors.rasi;
    ".config/rofi/config.rasi".source = lib.mkDefault ../../../dotfiles/rofi/config.rasi;
    ".config/rofi/fonts.rasi".source = lib.mkDefault ../../../dotfiles/rofi/fonts.rasi;

    
    ".config/neofetch/config.conf".source = lib.mkDefault ../../../dotfiles/neofetch/config.conf;
  };

  
  home.activation.copyWaybarScripts = lib.hm.dag.entryAfter ["writeBoundary"] ''
    
    chmod +x ${config.home.homeDirectory}/.config/waybar/custom/*.sh
    chmod +x ${config.home.homeDirectory}/.config/waybar/custom/spotify/*.py
  '';

  
  programs.git = {
    enable = true;
    userName = "lain";
    userEmail = "lain@example.com"; 
    
    
    
  };

  
  
  programs.vscode = {
    enable = true;
    
    
    
    
    
    
    
    
    
    
  };

  
  home.sessionVariables = {
    EDITOR = "code"; 
    TERM = "kitty";   
    
  };

  
  
  home.stateVersion = "24.05"; 
}
