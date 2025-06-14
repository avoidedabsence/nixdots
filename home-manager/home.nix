{ config, pkgs, ... }:

{
  home.username = "lain";
  home.homeDirectory = "/home/lain";
  programs.git = {
    enable = true;
    userName = "alexey";
    userEmail = "schwartzalexey@yandex.com";
  };

  home.environment.variables.EDITOR = "code";
  home.environment.variables.TERM = "kitty";

  home.stateVersion = "25.05"; # Or your nixos version
}
