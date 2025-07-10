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
      url = "github:ignis-sh/ignis";
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
    let
      system = "x86_64-linux";
    in
    {
      homeConfigurations = {
        minhnbnt = home-manager.lib.homeManagerConfiguration {

          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {
            ignisPkgs = ignis.packages.${system};
          };

          modules = [ ./home.nix ];
        };
      };
    };
}
