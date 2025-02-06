{
  system ? builtins.currentSystem,
  nixpkgs,
}:
let
  pkgs =
    (import nixpkgs {
      inherit system;
      overlays = [
        (final: prev: {
          haskellPackages = prev.haskellPackages.override {
            ghc = prev.haskellPackages.ghc.override {
              enableRelocatedStaticLibs = true;
              enableShared = false;
              enableDwarf = false;
            };
            buildHaskellPackages = prev.haskellPackages.buildHaskellPackages.override (old: {
              ghc = final.haskellPackages.ghc;
            });
          };
        })
      ];
      config = { };
    }).pkgsMusl;
  hpkgs = pkgs.haskell.packages.ghc98;
  hlib = pkgs.haskell.lib.compose;
in
pkgs.lib.pipe
  (pkgs.haskellPackages.callCabal2nix "tarsnapTui" (pkgs.lib.cleanSource ./.) {
  })
  [
    hlib.dontHaddock
    hlib.justStaticExecutables
    hlib.disableSharedLibraries
    hlib.enableDeadCodeElimination
    (hlib.appendConfigureFlags [
      "-O2"
      "--ghc-option=-fPIC"
      "--ghc-option=-optl=-static"
      "--extra-lib-dirs=${
        pkgs.gmp6.override {
          withStatic = true;
        }
      }/lib"
      "--extra-lib-dirs=${
        pkgs.libffi.overrideAttrs (old: {
          dontDisableStatic = true;
        })
      }/lib"
      "--extra-lib-dirs=${
        pkgs.ncurses.override {
          enableStatic = true;
        }
      }/lib"
      "--extra-lib-dirs=${pkgs.zlib.static}/lib"
    ])
  ]
