" -----------------------------------------------------------------------------
" Setup for VIM: The number one text editor!
" -----------------------------------------------------------------------------
" Karl Yngve Lervåg, 2009-11-30
" -----------------------------------------------------------------------------
"{{{" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible                  " don't need vi-compatible
set history=100                   " undo-history
set confirm                       " raise confirmation dialogs
filetype plugin indent on         " enables file type plugins/indentation
if has("win32")
  source $VIMRUNTIME/mswin.vim    " add some windows-stuff
endif
set winaltkeys=no

" Sets backup and temporary file directories
set backup
if has("unix")
  set backupdir=$HOME/.vim/backup/
  set directory=$HOME/.vim/backup/
else
  set backupdir=$VIM/backup/
  set directory=$VIM/backup/
endif

"}}}"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{" Theme/Colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enables syntax highlighting
syntax on

" Use 256 colors and colorscheme if possible
if &t_Co > 2 || has("gui_running")
  " Select colormap: 'soft', 'softlight', 'standard' or 'allblue'
  " Select brightness: 'low', 'med', 'high', 'default' or custom levels.
  let xterm16_colormap    = 'soft'
  let xterm16_brightness  = 'high'
  colorscheme xterm16
  set t_Co=256
endif

if expand("$OS") ==? 'Solaris'
  set term=ansi
endif

"}}}"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{" Vim user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildmenu            " shows nice command completion
set ruler               " shows line and column in the bottom
set lazyredraw          " lazy draw, faster
set mouse=              " makes mouse activated
set ignorecase          " search case insensitive...
set smartcase           " except when search contains upper-case
set foldmethod=syntax   " general foldmethod
set foldlevel=0         " starting foldlevel
set foldcolumn=0        " show folds in left column
set hidden              " can change buffer withour saving
set modelines=5         " set number of "vim-script lines" at end of file
set tags=tags;/         " set tag file directories

if has("unix")
  set clipboard=autoselect
endif

"}}}"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{" Visual cues
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set showmatch         " show matching brackets
set matchtime=5       " how long to show matching brackets
set matchpairs+=<:>   " also match angled brackets
set nohlsearch        " no colors for search matches
set incsearch         " shows matches while writing search
set scrolloff=10      " keep 10 lines over and below the cursor at all times
set showcmd           " shows your commands while typing
set columns=80        " number of columns in window
if has("gui_running")
  " Options for gui-based vim
  set lines=50
  set guioptions=aegirLt 
  set guifont=Monospace\ 10
endif

"}}}"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{" Text formatting/layout
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent        " copies indent from previous line
"set cindent           " C-like indenting
set softtabstop=2     " read help
set shiftwidth=2      " width of indent
set tw=79             " width of text
set fo=tcrq1          " text format options (:help 'fo')
set ff=unix           " never use windows file format
set wrap              " wraps text
set smarttab          " tabs at start of line, space elsewhere
set expandtab         " replace tabs with spaces

" vimdiff options
if v:version >= 700
  set diffopt=filler,context:4,foldcolumn:2,horizontal
end

" set backspace for unix
if has("unix")
  set backspace=indent,eol,start
endif

"}}}"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{" Autocommands and filetype specific settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !exists("autocommands_loaded")
  let autocommands_loaded = 1
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  "{{{" General
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  "}}}"
  "{{{" Vimrc
  if has("unix")
    au BufReadPost .vimrc setlocal foldmethod=marker
  else
    au BufReadPost _vimrc setlocal foldmethod=marker
  endif
  "}}}"
  "{{{" Bash scripts
  let g:sh_fold_enabled=1
  "}}}"
  "{{{" Textfiles
  au BufReadPost *.txt setlocal textwidth=78 foldmethod=manual fo=t1
  au BufReadPost *.txt loadview
  au BufWrite *.txt mkview
  "}}}"
  "{{{" MATLAB
  au BufReadPost *.m set foldmethod=manual
  au BufReadPost *.m loadview
  au BufWrite *.m mkview
  "}}}"
  "{{{" C++
  au BufReadPost *.c++ setlocal cindent
  "}}}"
  "{{{" LaTeX
  au BufReadPost *.tex call Set_LaTeX_settings()
  "}}}"
  "{{{" FORTRAN
  " Manual folding
  "au BufReadPost *.f90 setlocal foldmethod=manual makeprg=make
  "au BufReadPost *.f90 loadview
  "au BufWrite *.f90 mkview
  "}}}"
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
endif
"}}}"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{" General mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F1 gives help
map <F1> <ESC>:h<Space>
map! <F1> <ESC>:h<Space>

" F2 and F3 to source/open vimrc
if has("unix")
  map <F2> :so ~/.vimrc<cr>
  map <F3> :e  ~/.vimrc<cr>
endif
if has("win32")
  map <F2> :so $VIM/_vimrc<cr>
  map <F3> :e  $VIM/_vimrc<cr>
endif

" Calls some functions
map <F4> :call ChooseVCSCommandType()<cr>
map <S-m> :TlistToggle<cr>
"map <F9> :make<cr>
map <F10> :call ChooseMakePrg()<cr>
map <F12> ggVGg? " encypt the file (toggle)

" cycle through buffers
nnoremap <C-P> :bp<CR>
nnoremap <C-N> :bn<CR>
" cycle through tabs
"nnoremap <C-P> :tabp<CR>
"nnoremap <C-N> :tabn<CR>

" Close buffer
nnoremap <C-U> :bd<CR>

" Turn on spell checking
let sc_on = 0
nnoremap <S-S> :let sc_on = SpellCheck(sc_on)<CR>

" Choose language
nnoremap <expr> <S-Q> ChooseLanguage()

" Y behave as D and C
noremap Y y$

" Ctrl-j runs buffer a
imap <C-j> <ESC>@a

" Define outclippin
vmap <z> :'<,'>s/^/%
vmap <Z> :'<,'>s/^%//
"}}}"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{" Abbreviations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iab tihs this

"}}}"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{" Other
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" sets grepprogram for windows and makes it always generate file-name
if has("win32")
  set grepprg=c:/Cygwin/bin/grep\ -nH\ $* 
endif

" Set Enhanced commentify settings
let g:EnhCommentifyUserBindings='Yes'

"}}}"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{" VCSCommand
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let VCSCommandSplit = 'horizontal'
if v:version < 700
  let VCSCommandDisableAll='1'
end

"}}}"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{" Taglist - nice plugin
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let Tlist_Use_Right_Window = 1
let Tlist_Close_On_Select = 1
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Compact_Format = 0
let Tlist_Exist_OnlyWindow = 0
let Tlist_GainFocus_On_ToggleOpen = 1
if ! has("gui_running")
  let Tlist_Use_Horiz_Window = 1
endif

" Latex taglist settings
let tlist_tex_settings='tex;k:command;a:abstract;p:part;c:chapter;s:section;l:label;r:ref;u:subsection;g:paragraph;t:thebibliography;o:tableofcontents;f:frontmatter;m:mainmatter;b:backmatter;x:appendix'

" Bibtex taglist settings
let tlist_bib_settings='bib;a:article;b:book;m:misc;p:part;s:string;t:thesis'

"}}}"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{" Functions and Commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{" SpellCheck
function! SpellCheck(sc_on)
  if a:sc_on
    echo "Spell checking turned off!"
    set nospell
    return 0
  else
    echo "Spell checking turned on!"
    set spell
    return 1
  endif
endfunction
"}}}
"{{{" ChooseVCSCommandType
function! ChooseVCSCommandType()
  let choice = confirm("Choose VCS Type", "&CVS\n&Mercurial")
  if choice == 1
    let b:VCSCommandVCSType="CVS"
  elseif choice == 2
    let b:VCSCommandVCSType="Mercurial"
  endif
endfunction
"}}}
"{{{" ChooseLanguage
function! ChooseLanguage()
  let choice = 
    \confirm("Choose Language", "&Bokmaal\n&Nynorsk\nEnglish &GB\nEnglish &USA")
  if choice == 1
    set spelllang=nb
  elseif choice == 2
    set spelllang=nn
  elseif choice == 3
    set spelllang=en_us
  elseif choice == 4
    set spelllang=en_gb
  endif
endfunction
"}}}
"{{{" ChooseMakePrg
function! ChooseMakePrg()
  let choice = confirm("Choose make program" , "&Python\n&Makefile")
  if choice == 1
    set makeprg=python\ %
  elseif choice == 2
    set makeprg=make
  endif
endfunction
"}}}
"{{{" CreateTags
function! CreateTags()
  !silent! lcd %:h
  let choice = confirm("What kind of tags?" , "&Stop\n&C++\n&Fortran" , 1)
  if choice == 2
    silent execute "!ctags -o tagsmenu --c++-kinds=cf *.cpp"
    silent execute "!ctags *.cpp"
    silent execute "!sed -i '/TAG/d' tagsmenu"
  elseif choice == 3
    silent execute "!ctags -o tagsmenu *.f90"
    silent execute "!ctags *.f90"
    silent execute "!sed -i '/TAG/d' tagsmenu"
  endif
  silent! lcd -
endfunction
"}}}
"{{{" ShowFunctions
function! ShowFunctions()
  30vsplit tagsmenu
  set nowrap
  setlocal ts=99
  map <CR> 0ye:bd<CR>:tag <C-R>"<CR>
endfunction
"}}}
"{{{" Set_LaTeX_settings
function! Set_LaTeX_settings()
  " For all tex files use forward slash in filenames
  setlocal shellslash nocindent
  setlocal iskeyword+=:
endfunction
"}}}
"}}}"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -----------------------------------------------------------------------------
" vim: foldmethod=marker:ff=unix
