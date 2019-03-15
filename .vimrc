
"set vi compatibility
set nocompatible

" set the vimrc to the system wide vimrc which is not overridden
let $MYVIMRC="/etc/vim/vimrc.local"

""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""


" if the vim plugins manager vim-plug is not present, install it 
" using the system wide .vimrc
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" directory for plugins
call plug#begin('~/.vim/plugged')

" file and directory tree
Plug 'scrooloose/nerdtree'

" fuzzy search across files
Plug 'ctrlpvim/ctrlp.vim'

" smart comments
Plug 'scrooloose/nerdcommenter'

" perform insret mode completion with tabs
Plug 'ervandew/supertab'

" 100s of color schemes
Plug 'flazz/vim-colorschemes'

" silversearcher and ack integration
Plug 'mileszs/ack.vim'


call plug#end()


"""""""""""""""""""
" General
"""""""""""""""""""

" detect filetype
filetype on 

" remap leader key
let mapleader = ","

" set encoding
set enc=utf-8 " encoding inside vim
set fenc=utf-8 " encoding when writing to files
set tenc=utf-8 " encoding in terminal

" source .vimrc on save
autocmd BufWritePost .vimrc source % 

" open .vimrc with ease, using the system wide .vimrc
nnoremap <Leader>ev :vsp $MYVIMRC<CR>

"csv settings
let g:csv_nomap_space=1


"""""""""""""""""""
" UI
""""""""""""""""""

" show current position
set ruler

 " show line numbers
set number

" show current mode
set showmode

"display tabs and trailing spaces
set list
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅

" highlight matching braces
set showmatch

" indentation of new line
set autoindent

" wrap lines at 120 chars
set textwidth=120

" set terminal title even if it can't be restored
set title


"resize with + and -
if bufwinnr(1)
  map + <C-W>+
  map - <C-W>-
endif


" configure tabs
set tabstop=2
set shiftwidth=2
set expandtab " expand tabs to spaces

""""""""""""""""""""""""""""""
" Statusline
""""""""""""""""""""""""""""""
"statusline setup
set statusline=%t\   "tail of the filename

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

"display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let b:statusline_tab_warning = ''

        if !&modifiable
            return b:statusline_tab_warning
        endif

        let tabs = search('^\t', 'nw') != 0

        "find spaces that arent used as alignment in the first indent column
        let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        endif
    endif
    return b:statusline_tab_warning
endfunction


"""""""""""""""
" Search
""""""""""""""
" find next search match as typing
set incsearch

 " show highlight of search match
set hls

" ignore case when searching
set ignorecase

" case sensitive when search terms uses capital letters
set smartcase


"""""""""""""""
" Colors and fonts
"""""""""""""""

set t_Co=256 " colors
set background=dark
colorscheme peaksea


""""""""""""""""""""""""""""""""""""""""
" Files, backups and undo
""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in Git
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""
" Plugin configuration
"""""""""""""""""""""""""""""""""""""

""""""""""""" nerdtree """""""""""""

" open nerdtree automatically
autocmd vimenter * NERDTree

" map ctrl+n to toggle NERDTree
map <C-n> : NERDTreeToggle<CR>

" close vim if NERDTree is only buffer open
let g:nerdtree_tabs_autoclose=1

" don't open NERDTree if vim starts in diff mode
let g:nerdtree_tabs_no_startup_for_diff=1

" focus NERDTree if opening a directory, and the file if opening the file
let g:nerdtree_tabs_smart_startup_focus=1

" synchronize view of all NERDTree windows
let g:nerdtree_tabs_synchronize_view=1

" synchronize NERDTree after tab switch iff it was focused before tab switch
let g:nerdtree_tabs_open_on_new_tab=1

" when changing CWD with NERDTree, make the change available to other plugins, such as CtrlP
let g:NERDTreeChDirMode=2

" when given a directory name as startup parameter to vim, cd into it
let g:nerdtree_tabs_startup_cd=1

" show hidden files in NERDTree
let NERDTreeShowHidden=1

" stick NERDTree to the left
let g:NERDTreeWinPos = "left"

" always show bookmarks
let g:NERDTreeShowBookmarks=1

"""""""""""""" CtrlP """"""""""""""
" don't use caching
let g:ctrlp_use_caching=0

" search hidden files too
let g:ctrlp_show_hidden=1

" max depth to recourse into
let g:ctrlp_max_depth=40

"""""""""""" ack.vim """"""""""

" use with ag - silversearcher
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" alias Ack commands with Ag equivalent
for command in ['Ack', 'AckAdd', 'AckFromSearch', 'LAck', 'LAckAdd', 'AckFile', 'AckHelp', 'LAckHelp', 'AckWindow', 'LAckWindow']
  exe 'command ' . substitute(command, 'Ack', 'Ag', "") . ' ' . command
endfor

