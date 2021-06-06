{
  pkgs
, localUnfree ? (builtins.getEnv "NIX_REQUIREFREE" != "1")
, localBroken ? (builtins.getEnv "NIX_ALLOWBROKEN" == "1")
, workarounds ? (builtins.getEnv "NIX_WORKAROUNDS" == "1")
}:

{

  allowUnfree = localUnfree;

  allowBroken = localBroken;

  android_sdk.accept_license = true;

  packageOverrides = super:
    let

      self = super.pkgs;

      cfg = {
         allowUnfree = localUnfree;
         allowBroken = localBroken;
         android_sdk.accept_license = true;
      };

      pin1703  = import <pinned-17.03>   { config = cfg; };
      pin1709  = import <pinned-17.09>   { config = cfg; };
      pin1803  = import <pinned-18.03>   { config = cfg; };
      pin1809  = import <pinned-18.09>   { config = cfg; };
      pin1903  = import <pinned-19.03>   { config = cfg; };
      pin1909  = import <pinned-19.09>   { config = cfg; };
      pin2003  = import <pinned-20.03>   { config = cfg; };
      pin2009  = import <pinned-20.09>   { config = cfg; };
      pin2105  = import <pinned-21.05>   { config = cfg; };
      unstable = import <pinned-unstable>{ config = cfg; };
      latest   = import <nixos-latest>   { config = cfg; };

      excludeList = xs: if workarounds then [] else xs;
      includeSet  = xs: if workarounds then xs else {};

    in
      with self; rec {

        nativeGraphicalEnv = with pkgs; buildEnv {
          name = "env-native-graphical";
          # Custom environment for NixOS installations with X11.
          paths = [
            cloudEnv
            commEnv
            dataEnv
            deskEnv
            fontEnv
            netEnv
            termEnv
            texEnv
            toolEnv
            vimEnv
          ] ++ excludeList [
            chessEnv
          ];
        };

        nativeServerEnv = with pkgs; buildEnv {
          name = "env-native-server";
          # Custom environment for NixOS installations without X11.
          paths = [
            cloudEnv
            dataEnv
            netEnv
            termEnv
            texEnv
            toolEnv
            vimEnv
          ];
        };

        hostedServerEnv = with pkgs; buildEnv {
          name = "env-hosted-server";
          # Custom environment for non-NixOS installations.
          paths = [
            cloudEnv
            dataEnv
            netEnv
            termEnv
            texEnv
            toolEnv
          ] ++ excludeList [
            vimEnv
          ];
        };

        chessEnv = with pkgs; buildEnv {
          name = "env-chess";
          # Chess tools.
          paths = [
          # chessdb
          # eboard
            scid
            stockfish
          # xboard
          ];
        };

        cloudEnv = with pkgs; buildEnv {
          name = "env-cloud";
          # Cloud tools.
          paths = [
     latest.awscli2
          # ec2-api-tools
            google-cloud-sdk
          ] ++ excludeList [
            drive
          ];
        };

        commEnv = with pkgs; buildEnv {
          name = "env-comm";
          # Graphical clients for communication.
          paths = [
          # latest.discord
     latest.element-desktop
          # gajim
     latest.skype
     latest.slack
     latest.tdesktop
          # tigervnc
          ];
        };

        dataEnv = with pkgs; buildEnv {
          name = "env-data";
          # Data tools.
          paths = [
          # easytag
          # exif
            ffmpeg
          # gdal
          # gpsbabel
            graphviz
          # hdf5
          # id3v2
            imagemagick
          # lame
            librdf_raptor2
            librdf_rasqal
            librdf_redland
            mongodb
            mongodb-tools
            kafkacat
          # perseus
          # proj
            saxonb
            scim
          ];
        };

        deskEnv = with pkgs; buildEnv {
          name = "env-desk";
          # Graphical desktop tools.
          paths = [
          # anki
            baobab
            blender
            calibre
          # cura
            evince
            flashprint
    pin1909.freecad
            freemind
            gephi
            ggobi
          # ghostscriptX
            gimp
   unstable.google-chrome
            googleearth
          # gramps
            guvcview
#   pin1809.handbrake
            inkscape
          # keybase-gui
            libreoffice
            musescore
            meshlab
            xfce.mousepad
            paraview
            xfce.parole
            protege
    pin1809.qgis
            qpdfview
            rdesktop
            remmina
            rstudio
            scribus
            shutter
          # slic3r
            stellarium
          # teigha
            tikzit
            vlc
            xclip
            xkbd
            zotero
          ];
        };

        fontEnv = with pkgs; buildEnv {
          name = "env-font";
          # Fonts.
          paths = [
            gentium
            google-fonts
            hack-font
          ];
        };

        langEnv = with pkgs; buildEnv {
          name = "env-lang";
          # Programming languages.
          paths = [
            android-studio
            dart
            erlang
            fsharp
            ghostscript
            glpk
            gnu-smalltalk
            gnuapl
            go
            gprolog
            html-tidy
            jre
            julia
            lean
            maxima
            mono
            monodevelop
            octave
            R
            rhino
            sage
            squeak
            vscode
          ];
        };

        netEnv = with pkgs; buildEnv {
          name = "env-net";
          # Networking tools.
          paths = [
            bmon
            cacert
            dnsutils
          # globusconnectpersonal
            gping
            httpie
            iftop
            inetutils
     latest.ipfs
     latest.ipget
          # miniHttpd
            mtr
            nethogs
            nmap
            openssl
            samba
            tcpdump
            textile
            wget
          ];
        };

        termEnv = with pkgs; buildEnv {
          name = "env-term";
          # Terminal tools.
          paths = [
            broot
            bvi
            cheat
            dstat
            python3Packages.glances
            htop
          # manix
            mc
            meld
            pv
            ranger
            screen
            sysstat
            tmux
            tree
          ] ++ excludeList [
            atop
          ];
        };

        texEnv = with pkgs; buildEnv {
          name = "env-tex";
          # TeX tools.
          paths = [
          # tetex
            texlive.combined.scheme-full
          # texlive.combined.scheme-small
          ];
        };

        toolEnv = with pkgs; buildEnv {
          name = "env-tool";
          # Tools and utilities.
          paths = [
            aspellDicts.en
            bc
            binutils
          # btrfs-dedupe
            coreutils
            diffstat
            diffutils
            dos2unix
            expect
          # fcrackzip
            fdupes
            file
            findutils
            gawk
            git
            git-crypt
            git-lfs
            gitAndTools.gitRemoteGcrypt
            gnumake
            gnupg
          # google-music-scripts
            html-tidy
            inotify-tools
          # john
            jq
          # kbfs
          # keybase
            lzma
            mercurial
            mkpasswd
          # mpack
            niv
            nix-index
            nixpkgs-lint
            haskellPackages.pandoc
            haskellPackages.pandoc-citeproc
            ncdu
            p7zip
            parallel
            patchelf
            patchutils
            pbzip2
            pinentry
            pixz
            pdftk
            pgpdump
          # pxz
            qrencode
            ripgrep
          # stow
            time
            trezor_agent
            unar
            unzip
          # usbutils
          # xxd
          # zbackup
            zip
          ];
        };

        extraEnv = with pkgs; buildEnv {
          name = "env-extra";
          # Miscellaneous tools.
          paths = [
            ant
          # apacheKafka
            aspell
            cvs
            fop
            getmail
          # hadoop
            libpst
            protobuf
            rcs
          # spark
            subversion
          ];
        };

        devEnv = pkgs.buildEnv {
          name = "env-dev";
          # Miscellaneous software development derviations.
          paths = [
            spacenavd
            spnavcfg
            vrpn
          ];
        };

        gameEnv = pkgs.buildEnv {
          name = "env-game";
          # Games.
          paths = [
            freeorion
            nethack
          ];
        };

        vimEnv  = import  ./nvimEnv.nix { inherit pkgs; };

        unityEnv = import ./unityEnv.nix { inherit super pkgs pin1809; };

        rEnv = import ./rEnv.nix { inherit pkgs; };

        pythonEnv = import ./pythonEnv.nix { inherit pkgs; };

        inherit (import ./haskellEnv.nix { inherit pkgs pin1709 pin1803 pin2009 pin2105; })
          haskellEnv
          ghcEnv7103
          ghcEnv822
          ghcEnv865
          ghcEnv8104
        ; 

        tor-browser-bundle-bin-unstable = unstable.tor-browser-bundle-bin;

        apacheKafka011 = self.apacheKafka.override { majorVersion = "0.11"; };

        julia_13 = import <nixpkgs/pkgs/development/compilers/julia/shared.nix> {
          majorVersion       = "1"                                                   ;
          minorVersion       = "2"                                                   ;
          maintenanceVersion = "0"                                                   ;
          src_sha256         = "02ijqw3b9l8vvrl2xqmhynr95cq1p873ml7xj4fwjrs7n0gl7p65";
          libuvVersion       = "2348256acf5759a544e5ca7935f638d2bc091d60"            ;
          libuvSha256        = "1363f4vqayfcv5zqg07qmzjff56yhad74k16c22ian45lram8mv8";
        } { inherit ApplicationServices arpack cmake CoreServices curl fetchurl fetchzip fftw fftwSinglePrec gfortran gmp libunwind libgit2 m4 makeWrapper mpfr openblas openlibm openspecfun patchelf pcre2 perl python2 readline stdenv utf8proc which zlib; };

      } // (

        let
          toPackage = file: _: {
            name  = builtins.replaceStrings [ ".nix" ] [ "" ] file;
            value = super.callPackage (./. + "/custom/${file}") { };
          };
        in
          super.lib.mapAttrs' toPackage (builtins.readDir ./custom)

      );

}
