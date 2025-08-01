{
  description = "Home Manager configuration of minhnbnt";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.05";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ignis = {
      url = "github:ignis-sh/ignis/2cf7e62";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "github:quickshell-mirror/quickshell/v0.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      home-manager,
      ignis,
      nixpkgs,
      quickshell,
      ...
    }:

    let
      system = "x86_64-linux";
      quickshell-overlay = final: prev: {
        quickshell = quickshell.packages.${prev.system}.default;
      };

      pkgs = import nixpkgs {

        inherit system;

        overlays = [
          ignis.overlays.default
          quickshell-overlay
        ];
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
