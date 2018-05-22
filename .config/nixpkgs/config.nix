{ pkgs, localUnfree ? true, localBroken ? false, workarounds ? false }:

{

  allowUnfree = localUnfree;

  allowBroken = localBroken;

  packageOverrides = super:
    let

      fetchNixpkgs = import ./fetchNixpkgs.nix;

      self = super.pkgs;

      cfg = { allowUnfree = localUnfree; allowBroken = localBroken; };
      unstable = import <nixos-unstable>{ config = cfg; };
      old1703  = import <nixos-17.03>{ config = cfg; };
      old1709  = import <nixos-17.09>{ config = cfg; };
      old1803  = import <nixos-18.03>{ config = cfg; };
      pin1709  = import (
        fetchNixpkgs {
          rev = "b62c50ce5d3b6053f6f4afa10f2c4013ac0bfe9c";
        # sha256 = "0maw671jf54nx6gdlqhr5srl8kk78951mj847r325824f5bg8rsj";
        }
      ) { config = cfg; };
      recent   = import (
        fetchNixpkgs {
          rev = "f7ac0760a14999837462e7338ef81e5632c93b2f";
        # sha256 = "0x5fmjk98ipi6jx5784fz5nymn6a3rpv5m4i69z3rhp0djn4hipc";
        }
      ) { config = cfg; };

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
            recent.skype
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
            evince
            freemind
            gephi
            ggobi
            ghostscriptX
            gimp
          # unstable.google-chrome
            google-chrome
          # googleearth
          # google-earth
          # gramps
            guvcview
            inkscape
            libreoffice
            musescore
            old1703.meshlab
            xfce.mousepad
            paraview
            xfce.parole
            protege
            qgis
            remmina
            rstudio
            scribus
            shutter
            vlc
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
            julia_05
            maxima
            mono46
            monodevelop
            octave
            R
            rhino
            squeak
          ];
        };

        netEnv = with pkgs; buildEnv {
          name = "env-net";
          # Networking tools.
          paths = [
            cacert
            dnsutils
          # globusconnectpersonal
          # miniHttpd
            openssl
            samba
            tcpdump
            telnet
            traceroute
          # vrpn
            wget
            whois
          ];
        };

        termEnv = with pkgs; buildEnv {
          name = "env-term";
          # Terminal tools.
          paths = [
            bvi
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
          # texlive.combined.scheme-full
            texlive.combined.scheme-small
          ];
        };

        toolEnv = with pkgs; buildEnv {
          name = "env-tool";
          # Tools and utilities.
          paths = [
            aspellDicts.en
            bc
            binutils
            coreutils
            diffstat
            diffutils
            dos2unix
            file
            findutils
            gawk
            git
            gnumake
            gnupg
            inotify-tools
            mercurial
            mkpasswd
            nix-repl
            nixpkgs-lint
            haskellPackages.pandoc
            haskellPackages.pandoc-citeproc
            parallel
            patchelf
            patchutils
            pbzip2
            pinentry
          # stow
            time
            unzip
          # usbutils
          # xxd
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

        vimEnv = pkgs.buildEnv {
          name = "env-vim";
          # Customized Vim.
          paths = [ vimLocal ];
        };

        vimLocal = vim_configurable.customize {
          name = "vim";
        # name = "vim-local";
          vimrcConfig.customRC = ''
            " General settings.
            
            syntax on
            
            " Set up filetype.
            
            filetype indent off
            filetype plugin on
            
            " Miscellaneous settings.
            
            set nocompatible
            "et number
            "et nowrap
            set showmode
            set tw=1000
            set smartcase
            set smarttab
            set nosmartindent
            set noautoindent
            set softtabstop=2
            set shiftwidth=2
            set noexpandtab
            set incsearch
            set mouse=a
            set history=1000
            set clipboard=unnamedplus,autoselect
            
            set completeopt=menuone,menu,longest
            
            set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox
            set wildmode=longest,list,full
            set wildmenu
            set completeopt+=longest
            
            set t_Co=256
            
            set cmdheight=1
            
            " Set up syntastic.  See <http://www.stephendiehl.com/posts/vim_2016.html#syntastic>.
            
            map <Leader>s :SyntasticToggleMode<CR>
            
            set statusline+=%#warningmsg#
            set statusline+=%{SyntasticStatuslineFlag()}
            set statusline+=%*
            
            let g:syntastic_always_populate_loc_list = 1
            let g:syntastic_auto_loc_list = 0
            let g:syntastic_check_on_open = 0
            let g:syntastic_check_on_wq = 0
            
            """"" Set up ghc-mod.  See <http://www.stephendiehl.com/posts/vim_2016.html#ghc-mod-1>.
            """"
            """"let g:ghcmod_ghc_options = ['-Wall']
            """"
            """"map <silent> tw :GhcModTypeInsert<CR>
            """"map <silent> ts :GhcModSplitFunCase<CR>
            """"map <silent> tq :GhcModType<CR>
            """"map <silent> te :GhcModTypeClear<CR>
            
            """"" Set up supertab.  See <http://www.stephendiehl.com/posts/vim_2016.html#supertab>.
            """"
            """"let g:SuperTabDefaultCompletionType = '<c-x><c-o>'
            """"
            """"if has("gui_running")
            """"  imap <c-space> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
            """"else " no gui
            """"  if has("unix")
            """"    inoremap <Nul> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
            """"  endif
            """"endif
            """"
            """"let g:haskellmode_completion_ghc = 1
            """"autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
            
            " Set up nerdtree.  See <http://www.stephendiehl.com/posts/vim_2016.html#nerdtree>.
            
            map <Leader>n :Ntree<CR>
            
            " Set up tabularize.  See <http://www.stephendiehl.com/posts/vim_2016.html#tabularize>.
            
            let g:haskell_tabular = 1
            
            vmap a= :Tabularize /=<CR>
            vmap a; :Tabularize /::<CR>
            vmap a- :Tabularize /-><CR>
            
            " Set up ctrl-p.  See <http://www.stephendiehl.com/posts/vim_2016.html#ctrl-p>.
            
            map <silent> <Leader>t :CtrlP()<CR>
            noremap <leader>b<space> :CtrlPBuffer<cr>
            let g:ctrlp_custom_ignore = '\v[\/]dist$'
            
            " Set up pointfree.  See <http://www.stephendiehl.com/posts/vim_haskell.html>.
            
            autocmd FileType haskell set formatprg=pointfree\ `cat`
            '';
          vimrcConfig.vam.knownPlugins = vimPlugins; # optional
          vimrcConfig.vam.pluginDictionaries = [
            {
              names = [
                "ctrlp"                 # See <https://github.com/kien/ctrlp.vim>.
              # "ghc-mod-vim"
              # "neco-ghc"
              # "neocomplete"
              # "snipmate"
              # "Supertab"
                "Syntastic"             # See <https://github.com/vim-syntastic/syntastic>.
                "Tabular"
              # "tlib"
              # "vim-addon-mw-utils"
                "vim-hdevtools"
              # "vim-nerdtree-tabs"
                "vimproc"               # See <https://github.com/Shougo/vimproc.vim>.
              ];
            }
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

        haskell7Packages = pin1709.haskell.packages.ghc7103.override {
          overrides = localHaskellPackages false;
        };

        ghcEnv8 = pkgs.buildEnv {
          name = "env-ghc8";
          # GHC 8 tools.
          paths = with haskell8Packages; [
            (ghcWithHoogle (h: [ ]))
            cabal-install
            ghc-mod
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

        haskell8Packages = old1709.haskell.packages.ghc802.override {
          overrides = localHaskellPackages false;
        };

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

        haskellEnv = pkgs.buildEnv {
          name = "env-haskell";
          # Nix tools for Haskell.
          paths = [
            nix-prefetch-git
            cabal2nix
          ];
        };

        pythonEnv = pkgs.buildEnv {
          name = "env-python";
          # Custom Python environment.
          paths = [
            (python3.withPackages (ps: with ps; [
              async-timeout
              asyncio
              bootstrapped-pip
            # ggplot
              jupyter
              Keras
              matplotlib
              numpy
              pandas
              protobuf3_2
              scikitlearn
              scipy
              seaborn
              statsmodels
              Theano
              tensorflow
              websockets
            ]))
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
                     codetools
                     crayon
                     data_table
                   # DBI
                     digest
                   # dplr
                     evaluate
                     FNN
                     GGally
                     ggplot2
                   # highr
                     Hmisc
                   # httr
                     igraph
                   # iplot
                     jsonlite
                     kernlab
                   # knitr
                     lubridate
                     pbdZMQ
                     plotrix
                   # quantmod
                     Rcpp
                     RcppEigen
                     repr
                   # reshape2
                     shiny
                   # shiny
                   # SPARQL
                   # sqldf
                     stringr
                   # TDA
                   # tidyr
                     uuid
                   # yaml
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

      ) // includeSet {

        # The following are required by Peregrine.
        libuv = super.stdenv.lib.overrideDerivation super.libuv (attrs: {
          doCheck = false;
        });
        sharutils = super.stdenv.lib.overrideDerivation super.sharutils (attrs: {
          doCheck = false;
        });
        gnutls = super.stdenv.lib.overrideDerivation super.gnutls (attrs: {
          doCheck = false;
          configureFlags = [
            (__elemAt attrs.configureFlags 0)
            (__elemAt attrs.configureFlags 1)
            (__elemAt attrs.configureFlags 2)
          ];
        });
        unbound = super.stdenv.lib.overrideDerivation super.unbound (attrs: {
          configureFlags = [
            (__elemAt attrs.configureFlags 0)
            (__elemAt attrs.configureFlags 1)
            (__elemAt attrs.configureFlags 2)
            (__elemAt attrs.configureFlags 3)
            (__elemAt attrs.configureFlags 4)
            (__elemAt attrs.configureFlags 5)
            (__elemAt attrs.configureFlags 7)
            (__elemAt attrs.configureFlags 8)
          ];
        });
        nix = super.stdenv.lib.overrideDerivation super.nix (attrs: {
          doInstallCheck = false;
        });
        jemalloc = super.stdenv.lib.overrideDerivation super.jemalloc (attrs: {
          doCheck = false;
        });
        libgit2 = super.stdenv.lib.overrideDerivation super.libgit2 (attrs: {
          src = fetchurl {
            name = attrs.name + ".tar.gz";
            url = "http://github.com/libgit2/libgit2/tarball/v" + attrs.version;
            sha256 = "07bdqc1m3vmfk7i1ck1w4xcj88kfk74rir1zz3nfjc5vmykkibrv";
          };
        });
        go_bootstrap = super.stdenv.lib.overrideDerivation super.go_bootstrap (attrs: {
          preBuild = ''
            find src -type f -name  user_test.go -ls -delete
            find src -type f -name pprof_test.go -ls -delete
          '';
        });
        go_1_8 = super.stdenv.lib.overrideDerivation super.go_1_8 (attrs: {
          preBuild = ''
            find src -type f -name  user_test.go -ls -delete
            find src -type f -name pprof_test.go -ls -delete
          '';
        });
        python = super.python.override {
          packageOverrides = python-self: python-super: {
            dulwich = python-super.dulwich.overrideAttrs ( oldAttrs: {
              doInstallCheck = false;
            });
          };
        };
        python2Packages = python.pkgs;

      };

}
