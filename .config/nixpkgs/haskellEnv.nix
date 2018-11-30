{
  pkgs
, pin1709
, pin1803
, unstable
}:

let

  localHaskellPackages = libProf: self: super:
    with pkgs.haskell.lib;
    let
      toPackage = file: _: {
        name  = builtins.replaceStrings [ ".nix" ] [ "" ] file;
        value = self.callPackage (./. + "/haskell/${file}") { };
      };
      packages = pkgs.lib.mapAttrs' toPackage (builtins.readDir ./haskell);
    in
      packages // {
         ghcmod7 = super.ghc-mod.override { cabal-helper = super.cabal-helper; };
      };


  haskell7Packages = pin1709.haskell.packages.ghc7103.override {
    overrides = localHaskellPackages false;
  };

  haskell8Packages = pin1803.haskell.packages.ghc822.override {
    overrides = localHaskellPackages false;
  };

  haskellLatestPackages = unstable.haskell.packages.ghc822.override {
    overrides = localHaskellPackages false;
  };

in

  {
  
    haskellEnv = pkgs.buildEnv {
      name = "env-haskell";
      # Nix tools for Haskell.
      paths = with pkgs; [
        nix-prefetch-git
        cabal2nix
      ];
    };
  
    ghcEnv7 = pkgs.buildEnv {
      name = "env-ghc7";
      # GHC 7 tools.
      paths = with haskell7Packages; [
        (ghcWithHoogle (h: [ ]))
        cabal-install
        ghcmod7
        ghcid
        hasktags
        hdevtools
        hindent
        hlint
        pointfree
        pointful
        threadscope
      ];
    };
  
    ghcEnv8 = pkgs.buildEnv {
      name = "env-ghc8";
      # GHC 8 tools.
      paths = with haskell8Packages; [
        (ghcWithHoogle (h: [ ]))
        cabal-install
      # ghc-mod
        ghcid
        hasktags
        hdevtools
        hindent
        hlint
        pointfree
        pointful
        threadscope
      ];
    };
  
    ghcEnvLatest = pkgs.buildEnv {
      name = "env-ghc-latest";
      # LatestGHC tools.
      paths = with haskellLatestPackages; [
        (ghcWithHoogle (h: [ ]))
        cabal-install
      # ghc-mod
        ghcid
      # hasktags
        hdevtools
        hindent
        hlint
        pointfree
        pointful
      # threadscope
      ];
    };
  
  }
