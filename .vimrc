" pathogen
call pathogen#infect()
call pathogen#helptags()

" 10 mb files are considered large
let g:LargeFile = 10

" Disable that scratch buffer
set completeopt-=preview

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
"set softtabstop=4
"set shiftwidth=4
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
set showtabline=2
set backspace=indent,eol,start
set cmdheight=2
set modeline
set background=dark
set term=$TERM
if $TERM != "linux"
   set t_Co=256
endif
colorscheme slate

" Auto completition
let g:acp_enableAtStartup = 0
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_wildcard = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
let g:neocomplcache_snippets_dir = "$HOME/.vim/snippets"

" Set statusline
set noruler
set laststatus=2
let g:Powerline_symbols='unicode'

" Lower prioritory for tab completition
set suffixes=.bak,~,.swp,.o,.log

" encodings
set fileencodings=ucs-bom,utf-8,sjis,default

" gvim
if has('gui_running')
   set guioptions-=T " Remove the toolbar
   set guioptions-=m " Remove the menubar
   set guioptions-=r " Remove the scrollbar
endif

" Backup
set backup
set backupdir=~/.vim/backup
set viminfo=%100,'100,/100,h,\"500,:100,n~/.viminfo

" Clipboard
let g:clipbrdDefaultReg = '+'
let g:user_zen_leader_key = '<c-h>'

" Plugins
filetype on
filetype plugin on
filetype plugin indent on
syntax enable

" NERDTree toggle
nmap <C-x> <plug>NERDTreeMirrorToggle<CR>
imap <C-x> <Esc><C-x>

" Indentguides options
let g:indent_guides_auto_colors=0
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=2
autocmd BufEnter * IndentGuidesEnable
hi IndentGuidesOdd  ctermbg=234
hi IndentGuidesEven ctermbg=235

" Hilight
set cursorline
hi cursorline   cterm=NONE ctermbg=234
hi cursorcolumn cterm=NONE ctermbg=234

" Comment lines
map ,/ :call CommentLineToEnd('/')<CR>+
map ,* :call CommentLinePincer('/* ', ' */')<CR>+

" Toggle folds with space
nnoremap <space> za

" C-e = cycle tabs, similar to C-w for panes
nmap <C-e> :tabNext<CR>
imap <C-e> <Esc><C-e>a

" GPL
map :GPL :0r ~/.vim/GPL.txt

" Autostart
autocmd VimEnter * wincmd p

" Vala
autocmd BufRead *.vala,*.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
au BufRead,BufNewFile *.vala,*.vapi setfiletype vala

" Vala options
let vala_comment_strings = 1
let vala_space_errors = 1

" Keep folds closed on insert mode
autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

" GLSL syntax
au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl,*.shd set syntax=glsl

" Mutt settings
autocmd BufNewFile,BufRead /tmp/mutt-* set filetype=mail
au FileType mail set tw=64 autoindent expandtab formatoptions=tcqn
au FileType mail set list listchars=tab:»·,trail:·
au FileType mail set comments=nb:>
au FileType mail vmap D dO[...]^[
au FileType mail silent normal /--\s*$^MO^[gg/^$^Mj

" Automatically cd into the directory that the file is in
autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" Dmenu integration
function! Chomp(str)
  return substitute(a:str, '\n$', '', '')
endfunction

function! DmenuOpen(cmd)
  let fname = Chomp(system("git ls-files | dmenu -i -l 20 -p " . a:cmd))
  if empty(fname)
    return
  endif
  execute a:cmd . " " . fname
endfunction

" use ctrl-t to open file in a new tab
" use ctrl-f to open file in current buffer
map <c-t> :call DmenuOpen("tabe")<cr>
map <c-f> :call DmenuOpen("open")<cr>

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d :",
        \ &tabstop, &shiftwidth, &textwidth)
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> :ml :call AppendModeline()<CR>

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

" For autocompletition
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '$HOME/.vim/tags',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
imap <C-k> <Plug>(neocomplcache_snippets_expand)
smap <C-k> <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-l> neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'

" vim: set ts=8 sw=3 tw=78 :
