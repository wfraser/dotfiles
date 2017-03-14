if &compatible
    set nocompatible
endif

let mapleader = "-"
let maplocalleader = "\\"

" Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" List of plugins:
Plugin 'rust-lang/rust.vim'

call vundle#end()
filetype plugin indent on

" Display settings
syn on
set hlsearch
set incsearch
set background=dark
set scrolloff=5
set number
set showmatch
set showmode
set showcmd
set ruler
set title
set wildmenu
set colorcolumn=100

" Theme
set t_Co=256
colorscheme onedark
hi ColorColumn ctermbg=234

" For slow terminals:
"set t_Co=8
"set cc=0
"hi EndOfBuffer ctermbg=None ctermfg=None
"hi Normal ctermbg=None
"syn off

" Editor settings
set autoindent
set smartindent
set smarttab
set tabstop=4
set shiftwidth=4
set expandtab
set backspace=indent,eol,start

set modeline

function! Get_visual_selection()
    let l = getline("'<")
    let col1 = getpos("'<")[2]
    let col2 = getpos("'>")[2]
    return l[col1 - 1 : col2 - 1]
endfun

" Pyclewn
"map <F5> :exe "Ccontinue" <CR>
"map <F9> :exe "Cbreak " . expand("%.p") . ":" . line(".") <CR>
"map \<F9> :exe "Cclear " . expand("%.p") . ":" . line(".") <CR>
"map <F10> :exe "Cnext" <CR>
"map <F11> :exe "Cstep" <CR>
"map \<F11> :exe "Cfinish" <CR>
"map <F12> <C-W><C-]>
"nmap <C-P> :exe "Cprint " . expand("<cword>") <CR>
"vmap <C-P> <Esc> :exe "Cprint " . Get_visual_selection() <CR>
"map <C-L> :exe "Cinfo locals" <CR>
"map <C-A> :exe "Cinfo args" <CR>
"map <C-X> :exe "Cfoldvar " . line(".") <CR>
"vmap <C-X> <Esc> :exe "Cfoldvar " . Get_visual_selection() <CR>
