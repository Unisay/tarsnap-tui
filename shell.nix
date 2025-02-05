{
  system ? builtins.currentSystem,
  nixpkgs,
}:
let
  pkgs = nixpkgs.legacyPackages.${system};
  hpkgs = pkgs.haskell.packages.ghc98;
  myHaskellPackages = pkgs.haskellPackages.extend (
    final: prev: {
      tarsnapTui = import ./package.nix {
        inherit system nixpkgs;
      };
    }
  );
  
in
hpkgs.shellFor {
  packages = p: [ ];
  nativeBuildInputs = with pkgs; [
    haskell.compiler.ghc98
    cabal-install
    hpkgs.cabal-fmt
    hlint
    fourmolu
    hpkgs.haskell-language-server
  ];
}
