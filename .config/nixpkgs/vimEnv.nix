{
  pkgs
}:

with pkgs;
let

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
      set tw=10000
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

      set laststatus=2
      set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
    
     " Turn off autoindent. 

      nnoremap <F8> :setl noai nocin nosi inde=<CR>
 
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

      let g:ghcmod_ghc_options = ['-Wall']

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
          "easymotion"
        # "ghc-mod-vim"
          "neco-ghc"
        # "neocomplete"
        # "snipmate"
          "Supertab"
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

in

  buildEnv {
    name = "env-vim";
    # Customized Vim.
    paths = [ vimLocal ];
  }
