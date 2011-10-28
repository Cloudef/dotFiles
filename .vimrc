" Settings
set nocompatible
set showcmd
set foldmethod=marker
set showmatch
set incsearch
set virtualedit=all
set autoindent
set cindent
set expandtab           " spaces not tabs
set softtabstop=3       " indents
set shiftwidth=3        " more indents
set pastetoggle=<F12>
set number
set mouse=a
set ttymouse=xterm
set noswapfile
set wildmenu
set wildmode=list:longest,full
set ignorecase
set smartcase
set autoread
set undolevels=1000
set updatecount=100
set ttyfast
set noerrorbells
set shell=bash

set fileencodings=ucs-bom,utf-8,sjis,default

" colorscheme
colorscheme desertEx

" Backup
set backup
set backupdir=~/.vim/backup
set viminfo=%100,'100,/100,h,\"500,:100,n~/.viminfo

" Highlight
set cul

" Clipboard
let g:clipbrdDefaultReg = '+'
let g:user_zen_leader_key = '<c-h>'

" Plugins
filetype on
filetype plugin on
filetype plugin indent on
syntax enable

" Mappings
nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>a

vmap <C-c> y: call system("xclip -i -selection clipboard", getreg("\""))<CR>
nmap <C-v> :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p
imap <C-v> <Esc><C-v>a

"Toggle folds with space
nnoremap <space> za

map :GPL :0r ~/.vim/GPL.txt

" Autostart
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p

au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl,*.shd set syntax=glsl

" Automatically cd into the directory that the file is in
autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" Restore cursor position to where it was before
augroup JumpCursorOnEdit
   au!
   autocmd BufReadPost *
            \ if expand("<afile>:p:h") !=? $TEMP |
            \   if line("'\"") > 1 && line("'\"") <= line("$") |
            \     let JumpCursorOnEdit_foo = line("'\"") |
            \     let b:doopenfold = 1 |
            \     if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
            \        let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
            \        let b:doopenfold = 2 |
            \     endif |
            \     exe JumpCursorOnEdit_foo |
            \   endif |
            \ endif
   " Need to postpone using "zv" until after reading the modelines.
   autocmd BufWinEnter *
            \ if exists("b:doopenfold") |
            \   exe "normal zv" |
            \   if(b:doopenfold > 1) |
            \       exe  "+".1 |
            \   endif |
            \   unlet b:doopenfold |
            \ endif
augroup END
