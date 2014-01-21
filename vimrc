" started as a copy from http://github.com/rtomayko/dotfiles
" ---------------------------------------------------------------------------
" General
" ---------------------------------------------------------------------------
 
set nocompatible " must be first! config the vim way, not legacy vi way
set history=1000 " lots of command line history
set cf " error files / jumping
set ffs=unix,dos,mac " support these files
filetype plugin indent on " load filetype plugin
set iskeyword-=.  " non word dividers
set viminfo='1000,f1,:100,@100,/20
set modeline " make sure modeline support is enabled
set autoread " reload files (no local changes only)
set tabpagemax=50 " open 50 tabs max
 
set nobackup " do not keep backups after close
set writebackup " do keep a backup while working
set backupdir=$HOME/.vim/backup " store backups under ~/.vim/backup
set backupcopy=yes " keep attributes of original file
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*
set directory=~/.vim/swap//,.,~/tmp,/tmp " keep swp files under ~/.vim/swap
 
" ----------------------------------------------------------------------------
" UI
" ----------------------------------------------------------------------------
 
set ruler " show the cursor position all the time
set noshowcmd " don't display incomplete commands
set nolazyredraw " turn off lazy redraw
"set number " line numbers
set wildmenu " turn on wild menu
set wildmode=list:longest,full
set ch=2 " command line height
set backspace=2 " allow backspacing over everything in insert mode
"set whichwrap+=<,>,h,l,[,] " backspace and cursor keys wrap to
set shortmess=filtIoOA " shorten messages
set report=0 " tell us about changes
set nostartofline " don't jump to the start of line when scrolling
 
" ----------------------------------------------------------------------------
" Visual Cues
" ----------------------------------------------------------------------------
 
set showmatch " brackets/braces that is
set mat=5 " duration to show matching brace (1/10 sec)
set incsearch " do incremental searching
set laststatus=2 " always show the status line
set noignorecase " do not ignore case when searching
set hlsearch " do highlight searches
set visualbell " shut the fuck up
 
" ----------------------------------------------------------------------------
" Text Formatting
" ----------------------------------------------------------------------------
 
set autoindent " automatic indent new lines
set smartindent " be smart about it
set nowrap " do not wrap lines
set softtabstop=2 " yep, two
set shiftwidth=2 " ..
set tabstop=4
set expandtab " expand tabs to spaces
set nosmarttab " fuck tabs
set formatoptions+=n " support for numbered/bullet lists
set textwidth=76 " wrap at 76 chars by default
set virtualedit=block " allow virtual edit in visual block ..
 
" ---------------------------------------------------------------------------
" Strip all trailing whitespace in file
" ---------------------------------------------------------------------------
 
function! StripWhitespace ()
    exec ':%s/ \+$//gc'
endfunction
map ,s :call StripWhitespace ()<CR>

" --- bski did it ---"
au BufEnter * lcd %:p:h
set tags=tags;/

" ---------------------------------------------------------------------------
" Running tests, original from https://github.com/garybernhardt/dotfiles
" ---------------------------------------------------------------------------

function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
      exec ":!bundle exec rspec " . a:filename
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=expand("%:p")
endfunction

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '_spec.rb$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    endif
    call RunTests(t:grb_test_file . command_suffix)
endfunction

map ,t :call RunTestFile()<cr>
map ,T :call RunNearestTest()<cr>
map ,a :call RunTests('')<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Rename current file, also from garybernhardt
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map ,n :call RenameFile()<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Promote variable to rspec let
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map ,p :PromoteToLet<cr>
