{
  description = "my-desktop-flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # Home Manager configuration
    homeConfigurations = {
      "lain" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          hyprland.homeManagerModules.default
          ./home.nix
        ];
        extraSpecialArgs = { inherit inputs; };
      };
    };

    # NixOS configuration 
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          hyprland.nixosModules.default
          ./configuration.nix
        ];
        specialArgs = { inherit inputs; };
      };
    };

    # Development shell for easy installation
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        pkgs.home-manager
        pkgs.git
      ];
      
      shellHook = ''
        echo "🚀 Desktop Environment Flake Setup"
        echo "Run: home-manager switch --flake .#lain"
        echo "Or for NixOS: sudo nixos-rebuild switch --flake .#desktop"
      '';
    };
  };
}
