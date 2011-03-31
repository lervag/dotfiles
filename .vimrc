" Setup for VIM: The number one text editor!
" -----------------------------------------------------------------------------
"{{{ General stuff and theme

" Activate pathogen
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Some general options
set nocompatible
set history=1000
set confirm
set winaltkeys=no
filetype plugin indent on
syntax on

" Set some windows specific options
if has("win32")
  source $VIMRUNTIME/mswin.vim
endif

" Sets backup and temporary file directories
set backup
if has("unix")
  set backupdir=$HOME/.vim/backup
  set directory=$HOME/.vim/backup
else
  set backupdir=$VIM/backup
  set directory=$VIM/backup
endif

" Sets undo file directory
if v:version >= 703
  set undodir=$HOME/.vim/undofiles
  set undofile
  set undolevels=1000
  set undoreload=10000
end

" Use 256 colors and colorscheme if possible
if &t_Co > 2 || has("gui_running")
  " Select colormap: 'soft', 'softlight', 'standard' or 'allblue'
  " Select brightness: 'low', 'med', 'high', 'default' or custom levels.
  set t_Co=256
  let xterm16_colormap    = 'soft'
  let xterm16_brightness  = 'high'
  colorscheme xterm16
endif

"}}}
"{{{ Vim user interface
set wildmode=longest,list:longest  " shows nice command completion
set ruler                          " shows line and column in the bottom
set lazyredraw                     " lazy draw, faster
set mouse=                         " makes mouse activated
set ignorecase                     " search case insensitive...
set smartcase                      " except when search contains upper-case
set foldmethod=syntax              " general foldmethod
set foldlevel=0                    " starting foldlevel
set foldcolumn=0                   " show folds in left column
set hidden                         " can change buffer withour saving
set modelines=5                    " set number of "vim-script lines" at EOF
set tags=tags;/                    " set tag file directories

" Add some file types to ignore list
set wildignore+=*.o
set wildignore+=*.obj
set wildignore+=*.tgz
set wildignore+=*.zip
set wildignore+=*.pdf
set wildignore+=*.doc*
set wildignore+=*.ods
set wildignore+=*.xcf
set wildignore+=*.aux
set wildignore+=*.synctex*
set wildignore+=*.latexmain
set wildignore+=*.png
set wildignore+=*.eps
set wildignore+=*.dvi
set wildignore+=*.vim/backup/*
set wildignore+=*.vim/view/*

if has("unix")
  set clipboard=autoselect
endif

"}}}
"{{{ Visual cues
set showmatch              " show matching brackets
runtime macros/matchit.vim " make % bounce between tags, begin/end, etc
set matchtime=2            " how long to show matching brackets
set matchpairs+=<:>        " also match angled brackets
set nohlsearch             " no colors for search matches
set incsearch              " shows matches while writing search
set scrolloff=10           " keep 10 lines over/below the cursor at all times
set showcmd                " shows your commands while typing
set columns=80             " number of columns in window
if has("gui_running")
  " Options for gui-based vim
  set lines=50
  set guioptions=aegirLt 
  set guifont=Monospace\ 10
endif

"}}}
"{{{ Text formatting/layout
set autoindent        " copies indent from previous line
set nocindent         " C-like indenting
set softtabstop=2     " read help
set shiftwidth=2      " width of indent
set tw=79             " width of text
set fo=tcrq1          " text format options (:help 'fo')
set ff=unix           " never use windows file format
set nowrap            " wraps text
set smarttab          " tabs at start of line, space elsewhere
set expandtab         " replace tabs with spaces
set spelllang=en_gb

" vimdiff options
if v:version >= 700
  set diffopt=filler,context:4,foldcolumn:2,horizontal
end

" set backspace for unix
if has("unix")
  set backspace=indent,eol,start
endif

"}}}
"{{{ Autocommands and filetype specific settings
if !exists("autocommands_loaded")
  let autocommands_loaded = 1
  "{{{ General
  augroup GeneralStuff
    autocmd!

    " Create directory if it does not exist when opening a new file
    autocmd BufNewFile  * :call EnsureDirExists()

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
  augroup END

  function! EnsureDirExists ()
    let dir = expand("%:h")
    if !isdirectory(dir)
      call AskQuit("Directory '" . dir . "' doesn't exist.", "&Create it?")
      try
        call mkdir(dir, 'p')
      catch
        call AskQuit("Can't create '" . dir . "'", "&Continue anyway?")
      endtry
    endif
  endfunction
  "}}}"
  "{{{ Bash scripts
  au BufReadPost *.sh let g:sh_fold_enabled=1
  "}}}"
  "{{{ Textfiles
  au BufReadPost *.txt setlocal textwidth=78
  "}}}"
  "{{{ MATLAB
  au BufReadPost *.m set foldmethod=manual
  "}}}"
  "{{{ C++
  au BufReadPost *.c++ setlocal cindent
  "}}}"
  "{{{ LaTeX
  au BufReadPost *.tex call LaTeXSettings()

  function! LaTeXSettings()
    " For all tex files use forward slash in filenames
    setlocal shellslash nocindent
    setlocal iskeyword+=:

    " Add mapping to be able to select a single paragraph, and to format it
    map <silent> <expr> { LaTeXStartOfParagraph()
    map <silent> <expr> } LaTeXEndOfParagraph()
    vmap p {o}
    map <silent> gwp :call LaTeXFormatParagraph()<CR>

    " Start with fold open and center screen
    silent! normal zO zz
  endfunction
  "}}}"
  "{{{ Python
  au FileType python syn keyword pythonDecorator True None False self
  "}}}"
endif
"}}}
"{{{ General mappings

" F1 gives help
map <F1> <ESC>:h<Space>
map! <F1> <ESC>:h<Space>

" F3 to open vimrc
if has("unix")
  map <F3> :e  ~/.vimrc<cr>
elseif has("win32")
  map <F3> :e  $VIM/_vimrc<cr>
endif

" Calls some functions
map <F4> :call ChooseVCSCommandType()<cr>
if has("unix")
  map <F5> :e  ~/.vim/snippets/<cr>
endif
map <F6> :Scratch<cr>
map <S-m> :TlistToggle<cr>
map <S-u> :GundoToggle<cr>
map <F9> :make<cr>
map <F10> :call ChooseMakePrg()<cr>
map <F12> ggVGg? " encypt the file (toggle)

" Tabs and buffer settings
nnoremap <silent> <C-p> :bp<CR>
nnoremap <silent> <C-n> :bn<CR>
nnoremap <C-U> :bd<CR>
let g:miniBufExplMapCTabSwitchBufs = 1 

" Cope
map <leader>qc :botright cope<cr>
map <leader>n  :cn<cr>
map <leader>p  :cp<cr>

" Rainbow parantheses
map <leader>rr :RainbowParenthesesToggle<CR>

" Spell checking
let sc_on = 0
nnoremap <leader>ss :let sc_on = SpellCheck(sc_on)<CR>
nnoremap <leader>sq :ChooseLanguage()<CR>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

" Y behave as D and C
noremap Y y$

" Ctrl-j runs buffer a
imap <C-j> <ESC>@a

" Define outclippin
vmap <z> :'<,'>s/^/%
vmap <Z> :'<,'>s/^%//

" Handy functions
imap <silent> <c-d><c-d> <c-r>=strftime("%e %b %Y")<CR>
imap <silent> <c-t><c-t> <c-r>=strftime("%l:%M %p")<CR>
vmap <silent>  ;=  :call AlignAssignments()<CR>
nmap <silent>  ;=  :call AlignAssignments()<CR>

"}}}
"{{{ Plugin settings and other

" Sets grepprogram for windows and makes it always generate file-name
let Grep_Skip_Dirs = 'CVS .svn .hg'
if has("win32")
  set grepprg=c:/Cygwin/bin/grep\ -nH\ $* 
endif

" Set ack settings
let g:ackprg="ack-grep -H --nocolor --nogroup --column"
let g:ackhighlight=1

" Set Enhanced commentify settings
let g:EnhCommentifyUserBindings='Yes'

" Supertab
let g:SuperTabSetDefaultCompletionType = "context"
let g:SuperTabRetainCompletionDuration = "session"

" VCSCommand
let VCSCommandSplit = 'horizontal'
if v:version < 700
  let VCSCommandDisableAll='1'
end

" Command-t
let g:CommandTScanDotDirectories = 1
nmap <silent> <Leader>tt :CommandT<CR>
nmap <silent> <Leader>tb :CommandTBuffer<CR>
nmap <silent> <Leader>t :CommandT 

" Taglist - nice plugin
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

"}}}
"{{{ Functions
"{{{ SpellCheck
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
"{{{ ChooseVCSCommandType
function! ChooseVCSCommandType()
  let choice = confirm("Choose VCS Type", "&CVS\n&Mercurial")
  if choice == 1
    let b:VCSCommandVCSType="CVS"
  elseif choice == 2
    let b:VCSCommandVCSType="Mercurial"
  endif
endfunction
"}}}
"{{{ ChooseLanguage
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
"{{{ ChooseMakePrg
function! ChooseMakePrg()
  let choice = confirm("Choose make program" , "&Python\n&Makefile")
  if choice == 1
    set makeprg=python\ %
  elseif choice == 2
    set makeprg=make
  endif
endfunction
"}}}
"{{{ CreateTags
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
"{{{ ShowFunctions
function! ShowFunctions()
  30vsplit tagsmenu
  set nowrap
  setlocal ts=99
  map <CR> 0ye:bd<CR>:tag <C-R>"<CR>
endfunction
"}}}
"{{{ UpdateCopyrightLine
function! UpdateCopyrightLine()
  let copyrights = {
    \ 'Copyright (c) .\{-}, \d\d\d\d-\zs\d\d\d\d' : 'strftime("%Y")',
    \}

  for [copyright, year] in items(copyrights)
    silent! execute "'[,']s/" . copyright . '/\= ' . replacement . '/'
  endfor
endfunction
"}}}
"{{{ AlignAssignments
function! AlignAssignments ()
  " Patterns needed to locate assignment operators...
  let ASSIGN_OP   = '[-+*/%|&]\?=\@<!=[=~]\@!'
  let ASSIGN_LINE = '^\(.\{-}\)\s*\(' . ASSIGN_OP . '\)\(.*\)$'

  " Locate block of code to be considered (same indentation, no blanks)
  let indent_pat = '^' . matchstr(getline('.'), '^\s*') . '\S'
  let firstline  = search('^\%('. indent_pat . '\)\@!','bnW') + 1
  let lastline   = search('^\%('. indent_pat . '\)\@!', 'nW') - 1
  if lastline < 0
    let lastline = line('$')
  endif

  " Decompose lines at assignment operators...
  let lines = []
  for linetext in getline(firstline, lastline)
    let fields = matchlist(linetext, ASSIGN_LINE)
    if len(fields)
      call add(lines, {'lval':fields[1], 'op':fields[2], 'rval':fields[3]})
    else
      call add(lines, {'text':linetext,  'op':''})
    endif
  endfor

  " Determine maximal lengths of lvalue and operator...
  let op_lines = filter(copy(lines),'!empty(v:val)')
  let max_lval = max(map(copy(op_lines), 'strlen(v:val[0])')) + 1
  let max_op   = max(map(copy(op_lines), 'strlen(v:val[1])'))

  " Recompose lines with operators at the maximum length...
  let linenum = firstline
  for line in lines
    let newline = empty(line.op)
          \ ? line.text : 
          \ printf("%-*s%*s%s", max_lval, line.lval, max_op, line.op, line.rval)
    call setline(linenum, newline)
    let linenum += 1
  endfor
endfunction
"}}}
"{{{ AskQuit
function! AskQuit (msg, proposed_action)
  if confirm(a:msg, "&Quit?\n" . a:proposed_action) == 1
    exit
  endif
endfunction
"}}}
"}}}
" -----------------------------------------------------------------------------
" Copyright, Karl Yngve Lervåg (c) 2008 - 2011
" -----------------------------------------------------------------------------
" vim: foldmethod=marker:ff=unix
