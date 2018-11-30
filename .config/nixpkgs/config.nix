{
  pkgs
, localUnfree ? (builtins.getEnv "NIX_REQUIREFREE" != "1")
, localBroken ? (builtins.getEnv "NIX_ALLOWBROKEN" == "1")
, workarounds ? (builtins.getEnv "NIX_WORKAROUNDS" == "1")
}:

{

  allowUnfree = localUnfree;

  allowBroken = localBroken;

  packageOverrides = super:
    let

      self = super.pkgs;

      cfg = { allowUnfree = localUnfree; allowBroken = localBroken; };

      pin1703  = import <pinned-17.03>   { config = cfg; };
      pin1709  = import <pinned-17.09>   { config = cfg; };
      pin1803  = import <pinned-18.03>   { config = cfg; };
      pin1809  = import <pinned-18.09>   { config = cfg; };
      unstable = import <pinned-unstable>{ config = cfg; };

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
            unstable.discord
            gajim
            skype
            slack
            tigervnc
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
            pin1803.kafkacat
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
            unstable.google-chrome
          # google-chrome
          # googleearth
          # google-earth
          # gramps
            guvcview
            inkscape
            libreoffice
            musescore
            unstable.meshlab
            xfce.mousepad
            paraview
            xfce.parole
            protege
            qgis
            remmina
            rstudio
            scribus
            shutter
          # pin1803.slic3r
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
            julia
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
            inetutils
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
          # vim
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
            nix-repl
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

        vimEnv = import ./vim.nix { inherit pkgs; };

        inherit (import ./haskell.nix { inherit pkgs pin1709 pin1803 unstable; }) haskellEnv ghcEnv7 ghcEnv8 ghcEnvLatest;

        inherit (import ./unity.nix { inherit super pkgs pin1803; }) unity3d unityEnv;

        pythonEnv =
          let
            python =
              let
                packageOverrides = self: super: {
#                 tensorFlow = unstable.python36Packages.tensorflow;
                };
              in
                (if workarounds then pin1809 else unstable).python36.override { inherit packageOverrides; };
          in
            pkgs.buildEnv {
            name = "env-python";
            # Custom Python environment.
            paths = [
              (python.withPackages (ps: with ps; [
                async-timeout
                asyncio
                bokeh
                bootstrapped-pip
              # catboost
              # dist-keras
              # elephas
              # eli5
                fiona
                flask
                gensim
                geopandas
              # ggplot
                h5py
              # json
                jupyter
              # lightgbm
                matplotlib
                networkx
                nltk
                numpy
                pandas
                pip
                pipenv
                plotly
                protobuf
                pydot
              # rasterio
                scikitlearn
                scipy
              # scrapy
                seaborn
              # snakes
              # spacy
              # spark-deep-learning
                spyder
                statsmodels
              # tensorflow_hub
              # tensorflowjs
              # Theano
                websockets
                xgboost
              ]
              ++ excludeList [
                Keras
                pytorch
                tensorflow
              ]))
            ];
          };

        pipEnv = pkgs.buildEnv {
          name = "env-pip";
          paths = [
            (unstable.python3.withPackages (ps: with ps; [
              unstable.pipenv
            ]))
          # unstable.pipenv
          ];
        };

        rEnv = let
                 deriveR = {name, src, buildInputs, postPatch}:
                   stdenv.mkDerivation {
                     inherit name;
                     inherit src;
                     inherit postPatch;
                     buildInputs = [R] ++ buildInputs;
                     configurePhase = ''
                       runHook preConfigure
                       export R_LIBS_SITE="$R_LIBS_SITE''${R_LIBS_SITE:+:}$out/library"
                       runHook postConfigure
                     '';
                     buildPhase = ''
                       runHook preBuild
                       runHook postBuild
                     '';
                     installFlags = [];
                     rCommand = "R";
                     installPhase = ''
                       runHook preInstall
                       mkdir -p $out/library
                       $rCommand CMD INSTALL $installFlags --configure-args="$configureFlags" -l $out/library .
                       runHook postInstall
                     '';
                     postFixup = ''
                       if test -e $out/nix-support/propagated-native-build-inputs; then
                           ln -s $out/nix-support/propagated-native-build-inputs $out/nix-support/propagated-user-env-packages
                       fi
                     '';
                     checkPhase = ''
                       # noop since R CMD INSTALL tests packages
                     '';
                 };
                 iplot =
                   let
                     aname = "iplot";
                     version = "1.1.0";
                   in
                     deriveR {
                       name = "r-${aname}-${version}";
                       src = fetchgit {
                         url = "https://github.nrel.gov/InsightCenter/iplot.git";
                         rev = "f9d6090bceabc83bda520452c8b0098610ad3d64";
                         sha256="0ynrm3v68b2f20s8kc4x23hcxfnyzhzpn6ig9x47zs90yn5zdn9n";
                       };
                       postPatch = ''
                       '';
                       buildInputs = [
                         openssl
                         zlib
                         rPackages.Rcpp
                         rPackages.jsonlite
                       ];
                     };
               in
                 pkgs.buildEnv {
                   name = "env-r";
                   # Custom R environment.
                   paths = with rPackages; [
#                super.rstudioWrapper.override {
#                  packages = with self.rPackages; [
                     R
                     BH
                     circlize
                     codetools
                     crayon
                     data_table
                     DBI
                     devtools
                     digest
                   # dplr
                     evaluate
                     FNN
                     GGally
                     ggplot2
                     highr
                     Hmisc
                     httr
                     igraph
                   # iplot
                     jsonlite
                     keras
                     kernlab
                     knitr
                     kSamples
                     lubridate
                     memo
                     pbdZMQ
                     plotrix
                     quantmod
                     Rcpp
                     RcppEigen
                     repr
                     reshape2
                     rpart
                     shiny
                     shinyjs
                     SPARQL
                     sqldf
                     stringr
                   # TDA
                     tensorflow
                     tidyr
                     uuid
                     yaml
                   ];
                 };

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
