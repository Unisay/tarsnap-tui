{
  system ? builtins.currentSystem,
  nixpkgs,
}:
let
  pkgs = nixpkgs.legacyPackages.${system};
  hpkgs = pkgs.haskell.packages.ghc98;
  hlib = pkgs.haskell.lib.compose;
in
pkgs.lib.pipe (hpkgs.callCabal2nix "tarsnapTui" (pkgs.lib.cleanSource ./.) { }) [
  hlib.dontHaddock
]
