{
  pkgs
}:

with pkgs;
let

  vimLocal = neovim.override {
    viAlias  = true;
    vimAlias = true;
    configure = {
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          airline
#         deoplete-lsp
          deoplete-nvim
        # hlint
          LanguageClient-neovim
#         ncm2
#         nvim-yarp
#         nvim-lsp
        # supertab
          tslime
          vim-hoogle
        # vim-markdown
        # vim-nix
        # vimtex
        ];
      };
      customRC = ''

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
      "et clipboard=unnamedplus,autoselect

      set completeopt=menuone,menu,longest

      set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git
      set wildmode=longest,list,full
      set wildmenu
      set completeopt+=longest

      set t_Co=256

      set cmdheight=1

      set laststatus=2
      set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
    
     " Turn off autoindent. 

      nnoremap <F8> :setl noai nocin nosi inde=<CR>
 
      " Set up supertab.  See <http://www.stephendiehl.com/posts/vim_2016.html#supertab>.

      "et g:SuperTabDefaultCompletionType = '<c-x><c-o>'

      " Set up tslime.  See <https://github.com/jgdavey/tslime.vim>.

      let g:tslime_always_current_session = 1
      let g:tslime_always_current_window = 1

      vmap gt <Plug>SendSelectionToTmux
      nmap gt <Plug>NormalModeSendToTmux
      nmap gv <Plug>SetTmuxVars

      " Set up deoplete.
      let g:deoplete#enable_at_startup = 1

      " Set up language client.

      let g:LanguageClient_serverCommands = { 'haskell': ['haskell-language-server', '--lsp'] }
      let g:LanguageClient_hoverPreview = "Always"
      "et g:LanguageClient_diagnosticsSignsMax = 0

      set omnifunc=LanguageClient#complete
      set completefunc=LanguageClient#complete
      set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()

      map <Leader>ld :call LanguageClient#textDocument_definition()<CR>
      map <Leader>lh :call LanguageClient#textDocument_hover()<CR>
      map <Leader>li :call LanguageClient#textDocument_implementation()<CR>
      map <Leader>lm :call LanguageClient#contextMenu()<CR>
      map <Leader>lr :call LanguageClient#textDocument_references()<CR>
      map <Leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>
      map <Leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
      map <Leader>lu :call LanguageClient#textDocument_documentHighlight()<CR>
      map <Leader>lw :call LanguageClient#workspace_symbol()<CR>
      map <Leader>lx :call LanguageClient#clearDocumentHighlight()<CR>

      hi link ALEError   Item
      hi link ALEWarning Item
      hi link ALEInfo    Item
      hi Item cterm=bold ctermfg=LightGray ctermbg=DarkGray

      '';
    };
  };

in

  buildEnv {
    name = "env-vim";
    # Customized Vim.
    paths = [ vimLocal ];
  }
