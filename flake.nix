{
  description = "avoidedabsence@nixdots";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      userConfig = import ./config.nix;
      
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        ${userConfig.hostname} = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs lib userConfig; };
          modules = [
            ./modules/system/configuration.nix
            ./modules/hardware/hardware-configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs userConfig; };
              home-manager.users.${userConfig.username} = {
                imports = [ ./modules/home-manager/users/user-specific.nix ];
              };
            }
          ];
        };
      };

      homeConfigurations = {
        ${userConfig.username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs userConfig; };
          modules = [
            ./modules/home-manager/users/user-specific.nix
            ./modules/home-manager/home.nix
          ];
        };
      };
    };
}
