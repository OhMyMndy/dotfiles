set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()


" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'chrisbra/Colorizer'
Plugin 'tpope/vim-sensible'
Plugin 'StanAngeloff/php.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-syntastic/syntastic'
Plugin 'airblade/vim-gitgutter'
Plugin 'joshdick/onedark.vim'
Plugin 'sheerun/vim-polyglot'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


let g:onedark_termcolors=16
colorscheme onedark
set nu
syntax on
let g:colorizer_auto_color=1
filetype plugin indent on
set wildmenu
set backspace=indent,eol,start
set ignorecase
set hlsearch
set t_Co=256

" Do not throw away file and create a new one, just reuse the current one
" https://github.com/moby/moby/issues/15793
set noswapfile
set backupcopy=yes

" autocmd StdinReadPre * let s:std_in=1/
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

set mouse=a

filetype plugin indent on
set autoindent	" Auto-indent new lines
set shiftwidth=4	" Number of auto-indent spaces
set smartindent	" Enable smart-indent
set smarttab	" Enable smart-tabs
set softtabstop=4	" Number of spaces per Tab
set tabstop=4

set list listchars=tab:>-,extends:>,nbsp:•,trail:•,extends:⟩,precedes:⟨


"Easier split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright

" Switch between buffers without having to save each buffer
set hidden


"Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_yaml_checkers = ['yamllint']


let g:syntastic_php_checkers = ["php"]
"["php", "phpcs", "phpmd"]

let g:syntastic_sh_shellcheck_args="-x"

" Switch file tabs
map <C-PageUp> :tabp<CR>
map <C-PageDown> :tabn<CR>

" Create folder if not exists
function s:MkNonExDir(file, buf)
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


"NERDTree mapping
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeChDirMode=2


" recursive path from cwd
set path +=./**

"" gvim settings
set gfn=FantasqueSansMono\ Nerd\ Font\ Mono\ 11

cmap w!! w !sudo tee > /dev/null %

set clipboard=unnamedplus

"" paste from system clipboard
map <C-p> "+gP<CR>
map <C-e> :!%:p<CR>

