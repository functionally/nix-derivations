{ pkgs }:

{

  allowUnfree = true;

  packageOverrides = super:
    let
      self = super.pkgs;
      unstable = import <nixos-unstable>{};
    in
      with self; rec {
 
        localEnv = with pkgs; buildEnv {
          name = "env-local";
          paths = [
            # Command-line
            ffmpeg
            imagemagick
            librdf_raptor2
            librdf_rasqal
            tetex
            # Graphical
            blender
            gephi
            ggobi
            unstable.google-chrome
            gramps
            graphviz
            guvcview
            hdf5
            inkscape
            libreoffice
            maxima
            meshlab
            octave
            pandoc
            paraview
            protege
            qgis
            remmina
            rstudio
            scid
            stockfish
            zotero
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
 
        vimEnv = pkgs.buildEnv {
          name = "env-vim";
          paths = [ vimLocal ];
        };

        localHaskellPackages = libProf: self: super:
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
          overrides = localHaskellPackages false;
        };

        ghcEnv7 = pkgs.buildEnv {
          name = "env-ghc7";
          paths = with haskell7Packages; [
            (ghcWithHoogle (h: [ ]))
            cabal-install
          # ghcmod7
          # ghcid
            hasktags
            hdevtools
            hlint
            pointfree
            pointful
          # threadscope
          ];
        };

        haskell8Packages = super.haskell.packages.ghc802.override {
          overrides = localHaskellPackages false;
        };

        ghcEnv8 = pkgs.buildEnv {
          name = "env-ghc8";
          paths = with haskell8Packages; [
            (ghcWithHoogle (h: [ ]))
            cabal-install
            ghc-mod
          # ghcid
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

        protege = callPackage ./protege.nix {};

        zotero = callPackage ./zotero.nix {};

      };

}
