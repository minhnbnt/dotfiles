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

    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ ignis.overlays.default ];
      };

      username = "minhnbnt";
      homeDirectory = "/home/${username}";
      dotDirectory = "${homeDirectory}/dotfiles";
    in

    {
      formatter.${system} = pkgs.nixfmt-rfc-style;

      homeConfigurations = {

        ${username} = home-manager.lib.homeManagerConfiguration {

          inherit pkgs;

          extraSpecialArgs = { inherit dotDirectory username; };

          modules = [
            { home = { inherit username homeDirectory; }; }
            ./home.nix
          ];
        };
      };
    };
}
