{
  pkgs
, localUnfree ? (builtins.getEnv "NIX_REQUIREFREE" != "1")
, localBroken ? (builtins.getEnv "NIX_ALLOWBROKEN" == "1")
, workarounds ? (builtins.getEnv "NIX_WORKAROUNDS" == "1")
}:

{

  allowUnfree = localUnfree;

  allowBroken = localBroken;

  permittedInsecurePackages = [
  ];

  android_sdk.accept_license = true;

  packageOverrides = super:
    let

      self = super.pkgs;

      cfg = {
         allowUnfree = localUnfree;
         allowBroken = localBroken;
         android_sdk.accept_license = true;
      };

      nixos2505  = import <nixos-25.05>    { config = cfg; };
      unstable   = import <nixos-unstable> { config = cfg; };

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
          ];
        };

        commEnv = with pkgs; buildEnv {
          name = "env-comm";
          # Graphical clients for communication.
          paths = [
            briar
          # briar-desktop
   unstable.cwtch-ui
   unstable.discord
            element-desktop
            slack
   unstable.signal-desktop
            tdesktop
   unstable.zoom
          ];
        };

        dataEnv = with pkgs; buildEnv {
          name = "env-data";
          # Data tools.
          paths = [
            dasel
            easytag
            exif
            exiftool
            ffmpeg
          # FlameGraph
          # gdal
            gifsicle
          # gpsbabel
            graphviz
          # hdf5
            id3v2
            imagemagick
            kcat
          # lame
            librdf_raptor2
            librdf_rasqal
            librdf_redland
  nixos2505.mongodb
  nixos2505.mongodb-tools
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
          # audacity
            audio-recorder
          # ardour
            baobab
            blender
   unstable.brave
            calibre
          # cura
            evince
            flashprint
            freecad
            freemind
            gephi
          # ggobi
          # ghostscriptX
            gimp
   unstable.google-chrome
          # googleearth
            gpa
            gramps 
            python3Packages.grip
            guvcview
            handbrake
            inkscape
            kdePackages.kdenlive
            keybase-gui
            lagrange
            ledger-live-desktop
            libreoffice
   unstable.librewolf
            lmms
            marktext
            musescore
            meshlab
            mongodb-compass
            monero-gui
       xfce.mousepad
          # mpv-with-scripts
            noise-repellent
            obsidian
            paraview
       xfce.parole
            plantuml
            poppler_utils
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
          # slic3r
            soundfont-arachno
            soundfont-fluid
            soundfont-generaluser
            stellarium
          # teigha
       xfce.xfce4-terminal
            thedesk
   unstable.thunderbird
   unstable.tor-browser
            tikzit
            trezor-suite
            vlc
            write_stylus
            xclip
            xkbd
            xorg.xhost
            xdotool
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
            caligula
            cheat
            dool
            dysk
            entr
            fzf
            glances
            nodePackages.gramma
            htop
            lynx
            manix
            mc
            meld
            pastel
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
            html-tidy
            inotify-tools
            intel-gpu-tools
          # john
            jq
          # k3b
            ledger_agent
            libfido2
            mercurial
            mkpasswd
          # mpack
            netcat-gnu
            nitrokey-app2
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
            xz
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
          # getmail
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
          # freeorion
            nethack
          ];
        };

        vimEnv  = import  ./nvimEnv.nix { inherit pkgs; };

        rEnv = import ./rEnv.nix { inherit pkgs; };

        pythonEnv = import ./pythonEnv.nix { inherit pkgs; };

        rustEnv = import ./rustShell.nix { inherit pkgs; };

        vscodeEnv = import ./vscodeEnv.nix { inherit pkgs; };

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
