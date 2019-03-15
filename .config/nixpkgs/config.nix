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

      cfg = { allowUnfree = localUnfree; allowBroken = localBroken; };

      pin1703  = import <pinned-17.03>   { config = cfg; };
      pin1709  = import <pinned-17.09>   { config = cfg; };
      pin1803  = import <pinned-18.03>   { config = cfg; };
      pin1809  = import <pinned-18.09>   { config = cfg; };
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
            awscli
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
            latest.discord
          # gajim
            latest.skype
            latest.slack
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
          # calibre
          # cura
            evince
            flashprint
            freecad
            freemind
            gephi
            ggobi
          # ghostscriptX
            gimp
            google-chrome
          # googleearth
          # google-earth
          # gramps
            guvcview
            inkscape
            libreoffice
            musescore
            meshlab
            xfce.mousepad
            paraview
            xfce.parole
            protege
            qgis
            qpdfview
            remmina
            rstudio
            scribus
            shutter
          # slic3r
          # teigha
            vlc
            xclip
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
          # julia
            maxima
            mono
            monodevelop
            octave
            R
            rhino
            sage
            squeak
          ];
        };

        netEnv = with pkgs; buildEnv {
          name = "env-net";
          # Networking tools.
          paths = [
            cacert
            dnsutils
            globusconnectpersonal
            httpie
            inetutils
          # ipfs
          # miniHttpd
            openssl
            samba
            tcpdump
          # vrpn
            wget
          ];
        };

        termEnv = with pkgs; buildEnv {
          name = "env-term";
          # Terminal tools.
          paths = [
            bvi
            python3Packages.glances
            htop
            mc
            pv
            screen
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
            btrfs-dedupe
            coreutils
            diffstat
            diffutils
            dos2unix
          # fcrackzip
            fdupes
            file
            findutils
            gawk
            git
            git-lfs
            gnumake
            gnupg
            inotify-tools
          # john
            lzma
            mercurial
            mkpasswd
          # mpack
            nix-index
            nixpkgs-lint
            p7zip
            haskellPackages.pandoc
            haskellPackages.pandoc-citeproc
            parallel
            patchelf
            patchutils
            pbzip2
            pinentry
            pixz
          # pxz
          # stow
            time
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
            nethack
            protobuf
            qrencode
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

        vimEnv = import ./vimEnv.nix { inherit pkgs; };

        unityEnv = import ./unityEnv.nix { inherit super pkgs pin1809; };

        juliaEnv = import ./juliaEnv.nix { inherit pkgs; };

        rEnv = import ./rEnv.nix { inherit pkgs; };

        pythonEnv = import ./pythonEnv.nix {
                      inherit pkgs excludeList;
                      base = if workarounds then pin1809 else unstable;
                    };

        inherit (import ./haskellEnv.nix { inherit pkgs pin1709 pin1803 unstable; })
          haskellEnv
          ghcEnv7
          ghcEnv8
          ghcEnvLatest
        ; 

        apacheKafka011 = self.apacheKafka.override { majorVersion = "0.11"; };

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
