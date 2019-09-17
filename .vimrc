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
Plugin 'dense-analysis/ale'
Plugin 'airblade/vim-gitgutter'
" Plugin 'Valloric/YouCompleteMe'
" Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'sheerun/vim-polyglot'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'vim-voom/VOoM'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

colorscheme industry
set nu
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
set clipboard=unnamedplus

" recursive path from cwd
set path +=./**

set mouse=a

" Indenting
set autoindent	" Auto-indent new lines
set shiftwidth=4	" Number of auto-indent spaces
set smartindent	" Enable smart-indent
set smarttab	" Enable smart-tabs
set softtabstop=4	" Number of spaces per Tab
set tabstop=4	" Number of spaces per Tab


set splitbelow
set splitright

" Switch between buffers without having to save each buffer
set hidden


" Syntastic
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



" Nerd tree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeChDirMode=2



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


" Switch file tabs
map <C-PageUp> :tabp<CR>
map <C-PageDown> :tabn<CR>

map <C-t> :SyntasticToggleMode<CR>

" Easier split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Gvim settings
set gfn=Iosevka\ Nerd\ Font\ Mono\ 11

" Highlighting settings
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red
