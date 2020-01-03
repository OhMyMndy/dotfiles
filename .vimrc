set encoding=UTF-8
scriptencoding utf-8

set wildmenu


if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLso ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup mine | autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" let g:ale_completion_enabled = 1
" let g:ale_completion_tsserver_autoimport = 1


call plug#begin('~/.vim/bundle')

"Plug 'ycm-core/YouCompleteMe'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'chrisbra/Colorizer'
Plug 'tpope/vim-sensible'
Plug 'ryanoasis/vim-devicons'

"Plug 'tpope/vim-obsession'
"Plug 'StanAngeloff/php.vim'
Plug 'scrooloose/nerdtree'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
"Plug 'dense-analysis/ale'
Plug 'airblade/vim-gitgutter'
" Plug 'Valloric/YouCompleteMe'
"Plug 'wellle/context.vim'


"Plug 'ctrlpvim/ctrlp.vim'

" A collection of language packs for Vim.
Plug 'sheerun/vim-polyglot'


"Plug 'editorconfig/editorconfig-vim'
"Plug 'vim-voom/VOoM'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
"Plug 'junegunn/vader.vim'


"Plug 'majutsushi/tagbar'
"Plug 'liuchengxu/vista.vim'

"Plug 'tpope/vim-fugitive'
Plug 'mbbill/undotree'
"Plug 'christoomey/vim-tmux-runner'
"Plug 'godlygeek/tabular'
Plug 'dense-analysis/ale'
"Plug 'tpope/vim-sleuth'
Plug '907th/vim-auto-save'
"Plug 'scrooloose/nerdcommenter'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

call plug#end()


colorscheme elflord
set number
syntax on

set wildmenu
set backspace=indent,eol,start
set ignorecase
set hlsearch
set t_Co=256
highlight Normal guibg=Black

" Do not throw away file and create a new one, just reuse the current one
" https://github.com/moby/moby/issues/15793
set noswapfile
set backupcopy=yes

" To save a file on a gvfs
" :w !tee % >/dev/null

cmap w!! w !sudo tee % >/dev/null
" set clipboard=unnamedplus
nnoremap <C-M-y> "+y
vnoremap <C-M-y> "+y
nnoremap <C-M-p> "+gP
vnoremap <C-M-p> "+gP

" Tags
command! MakeTags !ctags -R .

" recursive path from cwd
set path +=**

if ! has('nvim')
    set ttymouse=xterm2
endif
set mouse=a

" Indenting
set autoindent " Auto-indent new lines
set shiftwidth=4       " Number of auto-indent spaces
" set smartindent        " Enable smart-indent
" set smarttab   " Enable smart-tabs
"set softtabstop=4      " Number of spaces per Tab
set tabstop=4  " Number of spaces per Tab
set expandtab!

set splitbelow
set splitright

" Switch between buffers without having to save each buffer
set hidden

if has('persistent_undo')
    set undodir=~/.vim/undo-dir
    set undofile
endif


" Create folder if not exists
function! s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" Nerd tree
augroup mine | autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeChDirMode=2
let NERDTreeQuitOnOpen=1

" Language server sourcegraph
let g:LanguageClient_serverCommands = {
    \ 'go': ['go-langserver'],
	\ 'php': ['php-language-server.php'],
	\ 'sh': ['bash-language-server'],
	\ 'bash': ['bash-language-server']
    \ }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

" ALE

" let g:ale_sign_warning = ''

nnoremap <C-LeftMouse> :ALEGoToDefinition<CR>
nnoremap <C-p> :ALEFindReferences<CR>

"\                   'php': ['phpstan', 'phpcs', 'langserver']
let g:ale_linters= {
\                   'bash': ['shellcheck', 'sh-language-server'],
\                   'zsh': ['shellcheck'],
\                   'markdown': ['markdownlint'],
\                   'php': ['langserver', 'phpcs', 'phpstan', 'php']
\                  }

"\                   'php': ['phpstan', 'phpcs', 'langserver']
let g:ale_fixers = {
\                   'bash': ['shellcheck', 'shell'],
\                   'zsh': ['shellcheck'],
\                   'markdown': ['markdownlint', 'prettifier', 'trim_whitespace']
\                  }

let g:ale_dockerfile_dockerfile_lint_executable = 'hadolint'
let g:ale_php_langserver_use_global = 1
let g:ale_php_langserver_executable = $HOME.'/.composer/vendor/bin/php-language-server.php'
" FZF

nnoremap <C-p> :Files<Cr>

" Switch file tabs
map <C-PageUp> :tabn<CR>
map <C-PageDown> :tabp<CR>


" Tagbar
map <C-t> :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1



nnoremap <C-> :ls<CR>

" Easier split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Gvim settings
set guifont=Iosevka\ Nerd\ Font\ Mono\ 11

" Highlighting settings
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tabs_label = ''
let g:airline#extensions#tabline#show_splits = 0

" Vim autosave
let g:auto_save = 1  " enable AutoSave on Vim startup


"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>

" https://stackoverflow.com/questions/1873736/vim-ctrlp-Plug-manually-set-root-search-directory
let g:ctrlp_working_path_mode = 'wra'
let g:ctrlp_show_hidden = 1

if exists('g:ctrl_user_command')
    unlet g:ctrlp_user_command
endif
set wildignore+=*.o,*.a,*.so,*.pyc,*.swp,*/.history/*,*/.git/*,*/.idea/*,*.un~

let g:airline_theme='papercolor'


" Filetypes
autocmd Filetype yaml setlocal ts=4 sw=4 sts=0 expandtab
