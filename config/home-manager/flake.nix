{
  description = "Home Manager configuration of minhnbnt";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ignis = {
      url = "github:ignis-sh/ignis/7042b95";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ignis,
      ...
    }:
    {
      homeConfigurations = {
        minhnbnt = home-manager.lib.homeManagerConfiguration {

          pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [
              ignis.overlays.default
            ];
          };

          modules = [ ./home.nix ];
        };
      };
    };
}
