{ pkgs, peregrine ? false }:

{

  allowUnfree = true;

# allowBroken = true;

  packageOverrides = super:
    let
      self = super.pkgs;
      unstable = import <nixos-unstable>{};
      old1703 = import <nixos-17.03>{};
      old1709 = import <nixos-17.09>{};

    in
      with self; rec {
 
        fullEnv = with pkgs; buildEnv {
          name = "env-full";
          paths = [
            chessEnv
            cloudEnv
            commEnv
            dataEnv
            deskEnv
            fontEnv
            langEnv
            netEnv
            termEnv
            texEnv
            toolEnv
            vimEnv
            haskellEnv
            ghcEnv7
            ghcEnv8
            pythonEnv
          ];
        };

        lemurEnv = with pkgs; buildEnv {
          name = "env-lemur";
          paths = [
            chessEnv
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
          ];
        };

        gazelleEnv = with pkgs; buildEnv {
          name = "env-gazelle";
          paths = [
            cloudEnv
            dataEnv
            netEnv
            termEnv
            toolEnv
            vimEnv
          ];
        };

        nrelEnv = with pkgs; buildEnv {
          name = "env-nrel";
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

        chessEnv = with pkgs; buildEnv {
          name = "env-chess";
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
          paths = [
            awscli
            drive
            google-cloud-sdk
          ];
        };

        commEnv = with pkgs; buildEnv {
          name = "env-comm";
          paths = [
            discord
            gajim
            skype
            slack
            tigervnc
          ];
        };

        dataEnv = with pkgs; buildEnv {
          name = "env-data";
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
#           unstable.google-chrome
            google-chrome
          # googleearth
            gramps
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
            vlc
            zotero
          ];
        };

        fontEnv = with pkgs; buildEnv {
          name = "env-font";
          paths = [
            gentium
            google-fonts
            hack-font
            sc-im
          ];
        };

        langEnv = with pkgs; buildEnv {
          name = "env-lang";
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
          paths = [
            cacert
          # cifs-utils
            dnsutils
          # globusconnectpersonal
          # miniHttpd
            openssl
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
          paths = [
            atop
            bvi
            htop
            mc
            pv
            screen
            tmux
            tree
          # vim
          ];
        };

        texEnv = with pkgs; buildEnv {
          name = "env-tex";
          paths = [
          # tetex
          # texlive.combined.scheme-full
            texlive.combined.scheme-small
          ];
        };

        toolEnv = with pkgs; buildEnv {
          name = "env-tool";
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
          paths = [
            ant
            aspell
            cvs
            fop
            getmail
            libpst
            protobuf
            qrencode
            rcs
            subversion
          ];
        };

        devEnv = pkgs.buildEnv {
          name = "env-dev";
          paths = [
            spacenavd
            spnavcfg
            vrpn
          ];
        };

        vimEnv = pkgs.buildEnv {
          name = "env-vim";
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
            set smartindent
            set autoindent
            set softtabstop=2
            set shiftwidth=2
            "et expandtab
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
            
            " Set up ghc-mod.  See <http://www.stephendiehl.com/posts/vim_2016.html#ghc-mod-1>.
            
            """"let g:ghcmod_ghc_options = ['-Wall']
            
            map <silent> tw :GhcModTypeInsert<CR>
            map <silent> ts :GhcModSplitFunCase<CR>
            map <silent> tq :GhcModType<CR>
            map <silent> te :GhcModTypeClear<CR>
            
            " Set up supertab.  See <http://www.stephendiehl.com/posts/vim_2016.html#supertab>.
            
            let g:SuperTabDefaultCompletionType = '<c-x><c-o>'
            
            if has("gui_running")
              imap <c-space> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
            else " no gui
              if has("unix")
                inoremap <Nul> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
              endif
            endif
            
            let g:haskellmode_completion_ghc = 1
            autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
            
            """"" Set up nerdtree.  See <http://www.stephendiehl.com/posts/vim_2016.html#nerdtree>.
            """"
            """"map <Leader>n :NERDTreeToggle<CR>
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
                "ctrlp"
                "ghc-mod-vim"
                "neco-ghc"
                "neocomplete"
              # "snipmate"
                "Supertab"
                "Syntastic"
                "Tabular"
              # "tlib"
              # "vim-addon-mw-utils"
              # "vim-nerdtree-tabs"
                "vimproc"
              ];
            }
          ];
        };
 
        ghcEnv7 = pkgs.buildEnv {
          name = "env-ghc7";
          paths = with haskell7Packages; [
            (ghcWithHoogle (h: [ ]))
            cabal-install
          # ghcmod7
            ghcid
            hasktags
            hdevtools
            hlint
            pointfree
            pointful
            threadscope
          ];
        };

        haskell7Packages = super.haskell.packages.ghc7103.override {
          overrides = localHaskellPackages false;
        };

        ghcEnv8 = pkgs.buildEnv {
          name = "env-ghc8";
          paths = with haskell8Packages; [
            (ghcWithHoogle (h: [ ]))
            cabal-install
            ghc-mod
            ghcid
            hasktags
            hdevtools
            hlint
            pointfree
            pointful
            threadscope
          ];
        };

        haskell8Packages = super.haskell.packages.ghc802.override {
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
            # ghcmod7 = pkg ./ghc-mod-4.1.6.nix {};
              mkDerivation = args: super.mkDerivation (args // {
                enableLibraryProfiling = libProf;
                enableExecutableProfiling = false;
              });
            };

        haskellEnv = pkgs.buildEnv {
          name = "env-haskell";
          paths = [
            nix-prefetch-git
            cabal2nix
          ];
        };

        pythonEnv = pkgs.buildEnv {
          name = "env-python";
          paths = [
            (python3.withPackages (ps: with ps; [
              async-timeout
              asyncio
              bootstrapped-pip
            # ggplot
            # jupyter
            # Keras
              matplotlib
              numpy
              pandas
              protobuf3_2
              scikitlearn
              scipy
              seaborn
              statsmodels
              tensorflow
            # Theano
              websockets
            ]))
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

      ) // (if peregrine then {

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

      } else {});

}
