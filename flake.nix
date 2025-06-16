{
  description = "NixOS configuration for lain";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        navi = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs lib; };
          modules = [
            ./modules/system/configuration.nix
            ./modules/hardware/hardware-configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.lain = {
                imports = [ ./modules/home-manager/users/lain/user-specific.nix ];
              };
            }
          ];
        };
      };

      homeConfigurations = {
        "lain@navi" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./modules/home-manager/users/lain/user-specific.nix
            ./modules/home-manager/home.nix
          ];
        };
      };
    };
}
