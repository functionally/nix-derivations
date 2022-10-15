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
          deoplete-nvim
          deoplete-vim-lsp
          hlint-refactor-vim
          LanguageClient-neovim
        # nvim-fzf
          tslime
        # vim-grepper
          vim-hoogle
        # vim-ormolu
          vim-lsp
        ];
      };

    customRC = ''

      " General settings.
      
      set nocompatible
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

      set t_Co=256
      set cmdheight=1
      set laststatus=2

      set completeopt=menuone,menu,longest
      set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git
      set wildmode=longest,list,full
      set wildmenu
      
      " Settings for `LanguageClient-neovim`.
      
      set rtp+=~/.vim/pack/XXX/start/LanguageClient-neovim
      
      let g:LanguageClient_serverCommands = { 'haskell': ['haskell-language-server', '--lsp'] }
      """"let g:LanguageClient_diagnosticsSignsMax = 0
      let g:LanguageClient_hoverPreview = "Always"
      
      set omnifunc=LanguageClient#complete
      set completefunc=LanguageClient#complete
      set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
      
      nnoremap <F5> :call LanguageClient_contextMenu()<CR>
      map <Leader>lk :call LanguageClient#textDocument_hover()<CR>
      map <Leader>lg :call LanguageClient#textDocument_definition()<CR>
      map <Leader>lr :call LanguageClient#textDocument_rename()<CR>
      map <Leader>lf :call LanguageClient#textDocument_formatting()<CR>
      map <Leader>lb :call LanguageClient#textDocument_references()<CR>
      map <Leader>la :call LanguageClient#textDocument_codeAction()<CR>
      map <Leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>
      
      hi link ALEError   Item
      hi link ALEWarning Item
      hi link ALEInfo    Item
      hi Item cterm=underline ctermfg=Red
      """"hi Item cterm=bold ctermfg=LightGray ctermbg=DarkGray
      
      " Settings for `deoplete-vim-lsp`.
      
      let g:deoplete#enable_at_startup = 1
      
      " Settings for `tslime-vim`.
      
      let g:tslime_always_current_session = 1
      let g:tslime_always_current_window = 1
      
      vmap gt <Plug>SendSelectionToTmux
      nmap gt <Plug>NormalModeSendToTmux
      nmap gv <Plug>SetTmuxVars
     '';

    };

  };

in

  buildEnv {
    name = "env-vim";
    # Customized Vim.
    paths = [ vimLocal ];
  }
