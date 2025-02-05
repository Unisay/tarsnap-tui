{
  description = "Tarsnap TUI";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        tarsnapTui = import ./package.nix { inherit system nixpkgs; };
      in
      rec {
        formatter."${system}" = pkgs.nixfmt;
        devShells.default = import ./shell.nix { inherit system nixpkgs; };
        packages.default = tarsnapTui;
        apps.default = {
          type = "app";
          program = "${tarsnapTui}/bin/tarsnap-tui";
        };
      }
    );
}
