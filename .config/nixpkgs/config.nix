{ pkgs }:

{

  allowUnfree = true;

  packageOverrides = super:
    let
      self = super.pkgs;
      unstable = import <nixos-unstable>{};
    in
      with self; rec {
 
        lemur = with pkgs; buildEnv {
          name = "lemur";
          paths = [
            # Command-line
            ffmpeg
            imagemagick
            librdf_raptor2
            librdf_rasqal
            # Graphical
            blender
            gephi
            ggobi
            graphviz
            guvcview
            inkscape
            libreoffice
            meshlab
            pandoc
            paraview
            qgis
            rstudio
            scid
#           (import <nixos-unstable> {}).google-chrome
            unstable.google-chrome
            # Communication
#           discord
            gajim
            skype
            slack
            tigervnc
            # Xfce
            xfce.mousepad
            xfce.parole
            # Programming
            jre
            python3
            R
            # Services
            awscli
            google-cloud-sdk
          ];
        };

        myHaskellPackages = libProf: self: super:
          with pkgs.haskell.lib; let pkg = self.callPackage; in rec {

            raft = pkg /scratch/raft {};
            daft = pkg /scratch/daft {};

          # ghcmod7 = pkg ./ghc-mod-4.1.6.nix {};

            mkDerivation = args: super.mkDerivation (args // {
              enableLibraryProfiling = libProf;
              enableExecutableProfiling = false;
            });

          };

        haskell7Packages = super.haskell.packages.ghc7103.override {
          overrides = myHaskellPackages false;
        };

        ghcEnv = pkgs.myEnvFun {
          name = "ghc7";
          buildInputs = with haskell7Packages; [
            (ghcWithHoogle (h: [ ]))
            cabal-install
          # ghcmod7
            ghcid
            hasktags
            hdevtools
            hlint
            pointfree
            pointful
          # threadscope
          ];
        };

        haskellEnv = pkgs.buildEnv {
          name = "env-haskell";
          paths = [
            nix-prefetch-git
            cabal2nix
          ];
        };

      };

}
