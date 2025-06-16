{ config, pkgs, inputs, ... }:

{
  # Basic user info
  home.username = "lain";
  home.homeDirectory = "/home/lain";
  home.stateVersion = "25.05";

  # Enable Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    
    settings = {
      # Monitor configuration
      monitor = [
        "desc:AU Optronics 0x7EAD 0x00007EAD,1920x1080@144,0x0,1"
        "desc:Xiaomi Corporation Mi Monitor 6730310001331,2560x1440@180,1920x0,1"
      ];

      # Workspace assignments
      workspace = [
        "1,monitor:desc:AU Optronics 0x7EAD 0x00007EAD"
        "2,monitor:desc:Xiaomi Corporation Mi Monitor 6730310001331"
        "3,monitor:desc:Xiaomi Corporation Mi Monitor 6730310001331"
        "4,monitor:desc:Xiaomi Corporation Mi Monitor 6730310001331"
        "5,monitor:desc:Xiaomi Corporation Mi Monitor 6730310001331"
        "6,monitor:desc:Xiaomi Corporation Mi Monitor 6730310001331"
      ];

      # Environment variables
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "AQ_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia-open"
        "LIBVA_DRIVER_NAME,nvidia-open"
      ];

      # Startup applications
      exec-once = [
        "swaybg -o \\* -i ~/.config/hypr/wp.jpg -m fill"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "waybar"
      ];

      # Variables
      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$menu" = "rofi -show drun";

      # General settings
      general = {
        gaps_in = 3;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(95678eff) rgba(643a44dd) 45deg";
        "col.inactive_border" = "rgba(643a44dd)";
        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";
      };

      # Decoration
      decoration = {
        rounding = 18;
        blur = {
          enabled = true;
          size = 8;
          passes = 1;
          vibrancy = 0.1696;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      # Animations
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # Input settings
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = false;
        };
      };

      # Gestures
      gestures = {
        workspace_swipe = false;
      };

      # Device specific configs
      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      # Key bindings
      "$mainMod" = "SUPER";
      bind = [
        "$mainMod, Q, exec, $terminal"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, R, exec, $menu"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"

        # Move focus
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Switch workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Special workspace
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through workspaces
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      # Mouse bindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };

  # Programs configuration
  programs = {
    # Git configuration
    git = {
      enable = true;
      userName = "alexey";
      userEmail = "schwartzalexey@yandex.com";
    };

    # Kitty terminal
    kitty = {
      enable = true;
      settings = {
        linux_display_server = "wayland";
        wayland_titlebar_color = "background";
        
        font_family = "MesloLGS NF";
        font_size = 14;
        background_opacity = "0.7";
        
        # Window settings
        initial_window_width = "95c";
        initial_window_height = "35c";
        window_padding_width = 20;
        confirm_os_window_close = 0;
        
        # Colors
        background = "#14151e";
        foreground = "#b976af";
        
        # Black
        color0 = "#151720";
        color8 = "#4f5572";
        
        # Red
        color1 = "#dd6777";
        color9 = "#e26c7c";
        
        # Green
        color2 = "#90ceaa";
        color10 = "#95d3af";
        
        # Yellow
        color3 = "#ecd3a0";
        color11 = "#f1d8a5";
        
        # Blue
        color4 = "#86aaec";
        color12 = "#8baff1";
        
        # Magenta
        color5 = "#c296eb";
        color13 = "#c79bf0";
        
        # Cyan
        color6 = "#93cee9";
        color14 = "#98d3ee";
        
        # White
        color7 = "#b976af";
        color15 = "#b976af";
      };
    };

    # ZSH with Oh My Zsh
    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "powerlevel10k/powerlevel10k";
        plugins = [ "git" "sudo" "docker" "kubectl" ];
      };
      initExtra = ''
        # Enable Powerlevel10k instant prompt
        if [[ -r "$${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$${(%):-%n}.zsh" ]]; then
          source "$${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$${(%):-%n}.zsh"
        fi
        
        # Load p10k config if it exists
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '';
    };

    # Rofi launcher
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };
  };

  # Services
  services = {
    # Waybar
    waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          spacing = 0;
          height = 0;
          margin-top = 8;
          margin-right = 8;
          margin-bottom = 0;
          margin-left = 8;
          
          modules-left = [ "hyprland/workspaces" "tray" "custom/spotify" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [ "cpu" "memory" "network" "pulseaudio#output" "pulseaudio#input" "clock" ];
          
          "hyprland/window" = {
            format = "{title:.80}";
            rewrite = {
              "(.*) — Zen Browser" = "$1";
              "tms" = "Terminal: Kitty";
              "t" = "Terminal: Kitty";
            };
            tooltip-format = "{title}\n\nClass: {class}";
            separate-outputs = true;
          };
          
          "hyprland/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
            tooltip = false;
          };
          
          tray = {
            icon-size = 16;
            show-passive-items = true;
            spacing = 10;
            tooltip = false;
          };
          
          clock = {
            format = "{:%I:%M %p - %a, %d %b %Y}";
            tooltip = false;
          };
          
          cpu = {
            format = "  {usage}%";
            tooltip = false;
          };
          
          memory = {
            format = "  {}%";
            tooltip = false;
          };
          
          network = {
            format-wifi = "  {signalStrength}%";
            format-ethernet = "  Connected";
            format-disconnected = "  Disconnected";
            tooltip = false;
          };
          
          "pulseaudio#output" = {
            format = "{icon} {volume}%";
            format-muted = "  Muted";
            format-icons = {
              default = [ "" "" "" ];
            };
            tooltip = false;
          };
          
          "pulseaudio#input" = {
            format = "{format_source}";
            format-source = "  {volume}%";
            format-source-muted = "  Muted";
            tooltip = false;
          };
        };
      };
      style = ''
        * {
          border: none;
          border-radius: 0;
          font-family: 'JetBrains Mono', monospace;
          font-weight: bold;
          font-size: 14px;
          min-height: 0;
        }
        
        window#waybar {
          background: rgba(20, 21, 30, 0.7);
          border-radius: 15px;
          color: #b976af;
          transition-property: background-color;
          transition-duration: .5s;
        }
        
        #workspaces button {
          padding: 5px 10px;
          background: transparent;
          color: #b976af;
          border-radius: 15px;
        }
        
        #workspaces button.active {
          background: #95678e;
          color: #14151e;
        }
        
        #tray, #clock, #cpu, #memory, #network, #pulseaudio {
          padding: 5px 15px;
          margin: 5px;
          border-radius: 15px;
          background: rgba(149, 103, 142, 0.3);
        }
      '';
    };
  };

  # Home environment
  home.sessionVariables = {
    EDITOR = "code";
    TERM = "kitty";
    BROWSER = "firefox";
  };

  # Copy configuration files
  home.file = {
    # Hyprland wallpaper (create a placeholder if needed)
    # ".config/hypr/wp.jpg".source = ./hypr/wp.jpg;
    
    # P10k config (copy your existing one if available)
    # ".p10k.zsh".source = ./.p10k.zsh;
    
    # Rofi configuration
    ".config/rofi/colors.rasi".text = ''
      /**
       *
       * Author : Levi Lacoss (fishyfishfish55)
       * Github : @fishyfishfish55
       *
       * Colors
       **/

      * {
          background:     #643a44dd;
          background-alt: #643a44dd;
          foreground:     #cdd6f4FF;
          selected:       #95678eff;
          active:         #414868FF;
          urgent:         #95678eff;
      }
    '';
    
    ".config/rofi/fonts.rasi".text = ''
      /**
       *
       * Author : Aditya Shakya (adi1090x)
       * Github : @adi1090x
       * 
       * Fonts
       *
       **/

      * {
         font: "Fira Sans Medium 10";
      }
    '';
    
    ".config/rofi/config.rasi".text = ''
      /**
       *
       * Author : Aditya Shakya (adi1090x)
       * Github : @adi1090x
       * 
       * Rofi Theme File
       * Rofi Version: 1.7.3
       **/

      /*****----- Configuration -----*****/
      configuration {
        modi:                       "drun,run,filebrowser,window";
          show-icons:                 false;
          display-drun:               " ";
          display-run:                " ";
          display-filebrowser:        " ";
          display-window:             " ";
        drun-display-format:        "{name}";
        window-format:              "{w} · {c} · {t}";
      }

      /*****----- Global Properties -----*****/
      @import                          "./colors.rasi"
      @import                          "./fonts.rasi"

      * {
          border-colour:               var(selected);
          handle-colour:               var(selected);
          background-colour:           var(background);
          foreground-colour:           var(foreground);
          alternate-background:        var(background-alt);
          normal-background:           var(background);
          normal-foreground:           var(foreground);
          urgent-background:           var(urgent);
          urgent-foreground:           var(background);
          active-background:           var(active);
          active-foreground:           var(background);
          selected-normal-background:  var(selected);
          selected-normal-foreground:  var(foreground);
          selected-urgent-background:  var(active);
          selected-urgent-foreground:  var(background);
          selected-active-background:  var(urgent);
          selected-active-foreground:  var(background);
          alternate-normal-background: var(background);
          alternate-normal-foreground: var(foreground);
          alternate-urgent-background: var(urgent);
          alternate-urgent-foreground: var(background);
          alternate-active-background: var(active);
          alternate-active-foreground: var(background);
      }

      /*****----- Main Window -----*****/
      window {
          /* properties for window widget */
          transparency:                "real";
          location:                    center;
          anchor:                      center;
          fullscreen:                  false;
          width:                       800px;
          x-offset:                    0px;
          y-offset:                    0px;

          /* properties for all widgets */
          enabled:                     true;
          margin:                      0px;
          padding:                     0px;
          border:                      1px solid;
          border-radius:               15px;
          border-color:                rgba(255, 255, 255, 0.2);
          cursor:                      "default";
          /* Ultra-transparent liquid glass effect */
          background-color:            rgba(20, 20, 30, 0.3);
      }

      /*****----- Main Box -----*****/
      mainbox {
          enabled:                     true;
          spacing:                     10px;
          margin:                      0px;
          padding:                     30px;
          border:                      0px solid;
          border-radius:               0px 0px 0px 0px;
          border-color:                @border-colour;
          background-color:            transparent;
          children:                    [ "inputbar", "message", "listview" ];
      }

      /*****----- Inputbar -----*****/
      inputbar {
          enabled:                     true;
          spacing:                     10px;
          margin:                      0px;
          padding:                     0px;
          border:                      0px solid;
          border-radius:               0px;
          border-color:                @border-colour;
          background-color:            transparent;
          text-color:                  @foreground-colour;
          children:                    [ "textbox-prompt-colon", "entry", "mode-switcher" ];
      }

      prompt {
          enabled:                     true;
          background-color:            inherit;
          text-color:                  inherit;
      }
      textbox-prompt-colon {
          enabled:                     true;
          padding:                     5px 0px;
          expand:                      false;
          str:                         "";
          background-color:            inherit;
          text-color:                  inherit;
      }
      entry {
          enabled:                     true;
          padding:                     5px 0px;
          background-color:            inherit;
          text-color:                  inherit;
          cursor:                      text;
          placeholder:                 "Search...";
          placeholder-color:           inherit;
      }
      num-filtered-rows {
          enabled:                     true;
          expand:                      false;
          background-color:            inherit;
          text-color:                  inherit;
      }
      textbox-num-sep {
          enabled:                     true;
          expand:                      false;
          str:                         "/";
          background-color:            inherit;
          text-color:                  inherit;
      }
      num-rows {
          enabled:                     true;
          expand:                      false;
          background-color:            inherit;
          text-color:                  inherit;
      }
      case-indicator {
          enabled:                     true;
          background-color:            inherit;
          text-color:                  inherit;
      }

      /*****----- Listview -----*****/
      listview {
          enabled:                     true;
          columns:                     1;
          lines:                       8;
          cycle:                       true;
          dynamic:                     true;
          scrollbar:                   true;
          layout:                      vertical;
          reverse:                     false;
          fixed-height:                true;
          fixed-columns:               true;
          
          spacing:                     5px;
          margin:                      0px;
          padding:                     0px;
          border:                      0px solid;
          border-radius:               0px;
          border-color:                @border-colour;
          background-color:            transparent;
          text-color:                  @foreground-colour;
          cursor:                      "default";
      }
      scrollbar {
          handle-width:                3px ;
          handle-color:                @handle-colour;
          border-radius:               10px;
          background-color:            @alternate-background;
      }

      /*****----- Elements -----*****/
      element {
          enabled:                     true;
          spacing:                     10px;
          margin:                      0px;
          padding:                     5px 10px;
          border:                      0px solid;
          border-radius:               10px;
          border-color:                @border-colour;
          background-color:            transparent;
          text-color:                  @foreground-colour;
          cursor:                      pointer;
      }
      element normal.normal {
          background-color:            var(normal-background);
          text-color:                  var(normal-foreground);
      }
      element normal.urgent {
          background-color:            var(urgent-background);
          text-color:                  var(urgent-foreground);
      }
      element normal.active {
          background-color:            var(active-background);
          text-color:                  var(active-foreground);
      }
      element selected.normal {
          background-color:            var(selected-normal-background);
          text-color:                  var(selected-normal-foreground);
      }
      element selected.urgent {
          background-color:            var(selected-urgent-background);
          text-color:                  var(selected-urgent-foreground);
      }
      element selected.active {
          background-color:            var(selected-active-background);
          text-color:                  var(selected-active-foreground);
      }
      element alternate.normal {
          background-color:            var(alternate-normal-background);
          text-color:                  var(alternate-normal-foreground);
      }
      element alternate.urgent {
          background-color:            var(alternate-urgent-background);
          text-color:                  var(alternate-urgent-foreground);
      }
      element alternate.active {
          background-color:            var(alternate-active-background);
          text-color:                  var(alternate-active-foreground);
      }
      element-icon {
          background-color:            transparent;
          text-color:                  inherit;
          size:                        24px;
          cursor:                      inherit;
      }
      element-text {
          background-color:            transparent;
          text-color:                  inherit;
          highlight:                   inherit;
          cursor:                      inherit;
          vertical-align:              0.5;
          horizontal-align:            0.0;
      }

      /*****----- Mode Switcher -----*****/
      mode-switcher{
          enabled:                     false;
          spacing:                     10px;
          margin:                      0px;
          padding:                     0px;
          border:                      0px solid;
          border-radius:               0px;
          border-color:                @border-colour;
          background-color:            transparent;
          text-color:                  @foreground-colour;
      }
      button {
          padding:                     5px 10px;
          border:                      0px solid;
          border-radius:               10px;
          border-color:                @border-colour;
          background-color:            @alternate-background;
          text-color:                  inherit;
          cursor:                      pointer;
      }
      button selected {
          background-color:            var(selected-normal-background);
          text-color:                  var(selected-normal-foreground);
      }

      /*****----- Message -----*****/
      message {
          enabled:                     true;
          margin:                      0px;
          padding:                     0px;
          border:                      0px solid;
          border-radius:               0px 0px 0px 0px;
          border-color:                @border-colour;
          background-color:            transparent;
          text-color:                  @foreground-colour;
      }
      textbox {
          padding:                     8px 10px;
          border:                      0px solid;
          border-radius:               10px;
          border-color:                @border-colour;
          background-color:            @alternate-background;
          text-color:                  @foreground-colour;
          vertical-align:              0.5;
          horizontal-align:            0.0;
          highlight:                   none;
          placeholder-color:           @foreground-colour;
          blink:                       true;
          markup:                      true;
      }
      error-message {
          padding:                     10px;
          border:                      2px solid;
          border-radius:               10px;
          border-color:                @border-colour;
          background-color:            @background-colour;
          text-color:                  @foreground-colour;
      }
    '';
    
    # Use your actual font configuration
    ".fonts.conf".text = ''
      <?xml version="1.0"?><!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
       <dir>~/.local/share/fonts</dir>
      </fontconfig>
    '';
    
    # Proxychains configuration
    ".proxychains/proxychains.conf".text = ''
      dynamic_chain
      proxy_dns

      [ProxyList]
      socks5 127.0.0.1 1080
    '';
  };

  # Install packages for user
  home.packages = with pkgs; [];

  # Font configuration
  fonts.fontconfig.enable = true;

  # XDG configuration
  xdg = {
    enable = true;
    mimeApps.enable = true;
  };
}
