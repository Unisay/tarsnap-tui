{ pkgs, ... }:
{
  name = "tarsnap-tui";
  compiler-nix-name = "ghc96";

  crossPlatforms =
    p:
    pkgs.lib.optionals pkgs.stdenv.hostPlatform.isx86_64 (
      [ p.mingwW64 ] ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [ p.musl64 ]
    );

  # Tools to include in the development shell
  shell.tools.cabal = "latest";
  shell.tools.hlint = "latest";
  shell.tools.haskell-language-server = "latest";
}
