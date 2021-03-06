" {{{ Pathogen plugin
call pathogen#infect()
call pathogen#helptags()
" }}}
" {{{ Misc
" system stuff
set term=$TERM                   " SSH woes
if $TERM != "linux"              " if we are not in TTY
   set t_Co=256                  " set 256 colors \o/
endif

" gvim (i don't use this but whatever)
if has('gui_running')
   set guioptions-=T             " remove the toolbar
   set guioptions-=m             " remove the menubar
   set guioptions-=r             " remove the scrollbar
endif
" }}}
" {{{ Vim's own settings
colorscheme slate                " modified slate colorscheme
set background=dark              " dark background
set nocompatible                 " non Vi compatible
set completeopt-=preview         " disable scratch buffer
set showcmd                      " show command information
set foldmethod=marker            " allow marking folds
set showmatch                    " hilight search pattern
set incsearch                    " incremental search
set virtualedit=all              " enable virtualedit (visual block)
set autoindent                   " auto indentation
set cindent                      " C indentation
set expandtab                    " spaces not tabs
set softtabstop=3                " indents
set shiftwidth=3                 " more indents
"set softtabstop=4               " alternative tab settings
"set shiftwidth=4                " for various projects
set pastetoggle=<F12>            " toggle paste mode
set number                       " show line numbers
set noswapfile                   " no swap files
set wildmenu                     " enable wildmenu
set wildmode=list:longest,full   " wildmenu mode
set ignorecase                   " ignore case in search
set smartcase                    " if uppercase letter, don't ignore
set autoread                     " reload file if it changed
set undolevels=1000              " undo levels
set updatecount=0                " we don't use swap files
set ttyfast                      " yes we have a fast terminal connection
set lazyredraw                   " don't redraw while executing macros
set noerrorbells                 " no bells plz
set shell=zsh                    " zsh!
set showtabline=2                " show tabs always
set backspace=indent,eol,start   " backspace behaviour (indent -> eol -> start)
set cmdheight=2                  " avoid hit enter to continue
set modeline                     " use modelines
set noruler                      " use powerline instead to show stats
set laststatus=2                 " show the status always
set suffixes=.bak,~,.swp,.o,.log " lower prioritory for tab completition
set backup                       " backups are awesome
set backupdir=$HOME/.vim/backup  " set backup directory

" hilight under cursor
set cursorline                   " enable hilight
hi cursorline   cterm=NONE ctermbg=234
hi cursorcolumn cterm=NONE ctermbg=234

" this stuff is common sense
filetype on
filetype plugin on
filetype plugin indent on
syntax enable

" file encoding order
set fileencodings=ucs-bom,utf-8,sjis,default

" vim history file
set viminfo=%100,'100,/100,h,\"500,:100,n~/.viminfo
" }}}
" {{{ Mutt settings
autocmd BufNewFile,BufRead /tmp/mutt-* set filetype=mail
au FileType mail set tw=64 autoindent expandtab formatoptions=tcqn
au FileType mail set list listchars=tab:»·,trail:·
au FileType mail set comments=nb:>
au FileType mail vmap D dO[...]^[
au FileType mail silent normal /--\s*$^MO^[gg/^$^Mj
" }}}
" {{{ Plugins and their settings

" {{{ CSyntaxPlus plugin
au BufNewFile,BufRead *.{c,h} call CSyntaxPlus()
" }}}
" {{{ Powerline plugin
let g:Powerline_symbols='unicode'
" }}}
" {{{ Largefile plugin
let g:LargeFile = 10             " 10 mb file is large
" }}}
" {{{ ZenCoding plugin
let g:user_zen_leader_key = '<c-h>'
" }}}
" {{{ GLSL plugin
au BufNewFile,BufRead *.{frag,vert,fp,vp,glsl,shd} set syntax=glsl
" }}}
" {{{ Indent guides plugin
let g:indent_guides_auto_colors=0 " no auto colors
let g:indent_guides_start_level=2 " start level 2
let g:indent_guides_guide_size=2  " size is 2 for guide
hi IndentGuidesOdd  ctermbg=234   " odd color
hi IndentGuidesEven ctermbg=235   " even color
autocmd BufEnter * IndentGuidesEnable
" }}}
" {{{ NeoComplCache plugin
let g:acp_enableAtStartup = 0
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_wildcard = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
let g:neocomplcache_snippets_dir = "$HOME/.vim/snippets"
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '$HOME/.vim/tags',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" keymapping
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
" }}}
" {{{ NERDtree plugin
nmap <C-x> <plug>NERDTreeMirrorToggle<CR>
imap <C-x> <Esc><C-x>
" autocmd VimEnter * NERDTree      " autostart nerdtree
" autocmd VimEnter * wincmd p      " focus main window
" }}}

" }}}
" {{{ Keybindings
" C-e = cycle tabs, similar to C-w for panes
nmap <C-e> :tabNext<CR>
imap <C-e> <Esc><C-e>a

" toggle folds with space
nnoremap <space> za

" strip non ascii characters from file
nnoremap <silent> :strip :%s/[<C-V>128-<C-V>255<C-V>01-<C-V>31]//gi

" {{{ Dmenu functions
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
" }}}
" use ctrl-t to open file in a new tab
" use ctrl-f to open file in current buffer
map <c-t> :call DmenuOpen("tabe")<cr>
map <c-f> :call DmenuOpen("open")<cr>

"{{{ Modeline append function
" use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d :",
        \ &tabstop, &shiftwidth, &textwidth)
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), "")
  call append(line("$"), l:modeline)
endfunction
" }}}
" append modeline after last line in buffer.
nnoremap <silent> :ml :call AppendModeline()<CR>
" }}}

"
" some really useful autostart stuff below
"
" {{{ Keep folds closed on insert mode
autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif
" }}}
" {{{ Automatically cd into the directory that the file is in
autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')
" }}}
" {{{ Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif
" }}}
" {{{ Restore cursor position to where it was before on file open
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
" }}}

" vim: set ts=8 sw=3 tw=78 :
