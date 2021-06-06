{
  pkgs
, pin1709
, pin1803
, pin2009
, pin2105
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
#     packages // {
#        ghcmod7 = super.ghc-mod.override { cabal-helper = super.cabal-helper; };
#     };
      packages;


  haskell7103Packages = pin1709.haskell.packages.ghc7103.override {
    overrides = localHaskellPackages false;
  };

  haskell822Packages = pin1803.haskell.packages.ghc822.override {
    overrides = localHaskellPackages false;
  };

  haskell865Packages = pin2009.haskell.packages.ghc865.override {
    overrides = localHaskellPackages false;
  };

  haskell8104Packages = pin2105.haskell.packages.ghc8104.override {
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
  
    ghcEnv7103 = pkgs.buildEnv {
      name = "env-ghc7103";
      # GHC tools.
      paths = with haskell7103Packages; [
        (ghcWithHoogle (h: [ ]))
        cabal-install
      # ghcmod7
      # ghcid
        hasktags
      # hdevtools
        hindent
        hlint
        pointfree
        pointful
        threadscope
      ];
    };
  
    ghcEnv822 = pkgs.buildEnv {
      name = "env-ghc822";
      # GHC tools.
      paths = with haskell822Packages; [
        (ghcWithHoogle (h: [ ]))
        cabal-install
      # ghcid
        hasktags
      # hdevtools
        hindent
        hlint
        pointfree
        pointful
        threadscope
      ];
    };
  
    ghcEnv865 = pkgs.buildEnv {
      name = "env-ghc865";
      # GHC tools.
      paths = with haskell865Packages; [
        (ghcWithHoogle (h: [ ]))
        cabal-install
        haskell-language-server
        hlint
      ];
    };
  
    ghcEnv8104 = pkgs.buildEnv {
      name = "env-ghc8104";
      # GHC tools.
      paths = with haskell8104Packages; [
        (ghcWithHoogle (h: [ ]))
        cabal-install
        haskell-language-server
        hlint
      ];
    };

  }
