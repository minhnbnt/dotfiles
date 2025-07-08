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
      ignisPkgs = ignis.packages.${system};
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = { inherit ignisPkgs; };
    in
    {
      homeConfigurations = {
        minhnbnt = home-manager.lib.homeManagerConfiguration {
          inherit pkgs extraSpecialArgs;
          modules = [ ./home.nix ];
        };
      };
    };
}
