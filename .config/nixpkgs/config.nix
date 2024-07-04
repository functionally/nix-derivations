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

      pin1703    = import <pinned-17.03>   { config = cfg; };
      pin1709    = import <pinned-17.09>   { config = cfg; };
      pin1803    = import <pinned-18.03>   { config = cfg; };
      pin1809    = import <pinned-18.09>   { config = cfg; };
      pin1903    = import <pinned-19.03>   { config = cfg; };
      pin1909    = import <pinned-19.09>   { config = cfg; };
      pin2003    = import <pinned-20.03>   { config = cfg; };
      pin2009    = import <pinned-20.09>   { config = cfg; };
      pin2105    = import <pinned-21.05>   { config = cfg; };
      pin2111    = import <pinned-21.11>   { config = cfg; };
      pin2205    = import <pinned-22.05>   { config = cfg; };
      pin2211    = import <pinned-22.11>   { config = cfg; };
      unstable   = import <nixos-unstable> { config = cfg; };
      latest     = import <nixpkgs>        { config = cfg; };
      pinHaskell = import <haskell>        { config = cfg; };

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
          # vscodeEnv
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
            awscli2
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
            briar
   unstable.discord
            element-desktop
          # gajim
            skypeforlinux
            slack
            tdesktop
          # tigervnc
          ];
        };

        dataEnv = with pkgs; buildEnv {
          name = "env-data";
          # Data tools.
          paths = [
            dasel
            easytag
            exif
            ffmpeg
          # FlameGraph
          # gdal
          # gpsbabel
            graphviz
          # hdf5
            id3v2
            imagemagick
            kafkacat
          # lame
            librdf_raptor2
            librdf_rasqal
            librdf_redland
            mongodb
            mongodb-tools
          # perseus
            pgtop
            postgresql
          # proj
            saxonb
            sc-im
          ];
        };

        deskEnv = with pkgs; buildEnv {
          name = "env-desk";
          # Graphical desktop tools.
          paths = [
          # anki
            audacity
            baobab
            blender
            calibre
          # cura
            evince
            flashprint
            freecad
            freemind
            gephi
            ggobi
          # ghostscriptX
            gimp
   unstable.google-chrome
#           googleearth
            gpa
            gramps
            guvcview
            handbrake
            inkscape
            kdenlive
            lagrange
            libreoffice
            musescore
            meshlab
       xfce.mousepad
          # mpv-with-scripts
            obsidian
            paraview
       xfce.parole
            plantuml
            protege
            protonvpn-gui
            qbittorrent
            qdigidoc
            qgis
            qpdfview
            rdesktop
            remmina
       xfce.ristretto
            rstudio
            scribus
            shutter
            slic3r
            stellarium
          # teigha
       xfce.xfce4-terminal
   unstable.thunderbird
            tikzit
            vlc
            write_stylus
            xclip
            xkbd
            xdotool
   unstable.zoom
            zotero
          ];
        };

        fontEnv = with pkgs; buildEnv {
          name = "env-font";
          # Fonts.
          paths = [
          # gentium
            google-fonts
            hack-font
            mononoki
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
            gping
            httpdump
            httpie
            iftop
            inetutils
            ipget
            linux-wifi-hotspot
            magic-wormhole
          # miniHttpd
            mtr
            nethogs
            nmap
            openssl
            samba
            socat
            tcpdump
            wget
            youtube-tui
            yt-dlp
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
            glances
            nodePackages.gramma
            htop
            manix
            mc
            meld
            pv
            ranger
            screen
            sysstat
            telescope
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
            python3Packages.base58
            bc
            binutils
            blink1-tool
          # btrfs-dedupe
            coreutils
            cpulimit
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
            gnupg-pkcs11-scd
            gnumake
            gnupg
          # google-music-scripts
            html-tidy
            inotify-tools
          # john
            jq
            k3b
            ledger_agent
            lzma
            mercurial
            mkpasswd
          # mpack
            netcat-gnu
            niv
            nix-index
            nix-output-monitor
            nix-prefetch-git
            nixpkgs-lint
            haskellPackages.pandoc
          # haskellPackages.pandoc-citeproc
            ncdu
            opensc
            p7zip
            parallel
            patchelf
            patchutils
            pbzip2
            pcsctools
            pinentry
            pixz
            pdftk
            pgpdump
            podman-tui
          # pxz
            qrencode
            remarshal
            ripgrep
          # stow
            time
            tinycbor
            trezor_agent
            unar
            urlencode
            unzip
          # usbutils
            wacomtablet
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

        rEnv = import ./rEnv.nix { inherit pkgs; };

        pythonEnv = import ./pythonEnv.nix { inherit pkgs; };

        agdaEnv = import ./agdaEnv.nix { inherit pkgs; };

        rustEnv = import ./rustShell.nix { inherit pkgs; };

        vscodeEnv = import ./vscodeEnv.nix { inherit pkgs; };

        inherit (import ./haskellEnv.nix { inherit pkgs pin1709 pin1803 pin2009 pin2105 pinHaskell; })
          haskellEnv
          ghcEnv7103
          ghcEnv822
          ghcEnv865
          ghcEnv8107
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
