" Neovim settings

" Vim Plug {{{
call plug#begin('~/.local/share/nvim/plugged')

Plug 'tpope/vim-rsi'
Plug 'tpope/vim-surround'

" Appearance and themes
Plug 'joshdick/onedark.vim'

" Fuzzy searching
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

call plug#end()
" }}}

" Misc {{{
let g:python3_host_prog = '/usr/local/bin/python3'

let g:mapleader = " "

set history=500
set clipboard=unnamed
set hidden
" }}}

" Colors {{{
syntax on
silent! colorscheme onedark

if (has("termguicolors"))
  set termguicolors
endif
" }}}

" Spaces & Tabs {{{
set tabstop=4           " 2 space tab
set expandtab           " use spaces for tabs
set softtabstop=4       " 2 space tab
set shiftwidth=4

set modelines=1

set autoindent
" }}}

" UI Layout {{{
set number              " show line numbers
set relativenumber      " show line numbers relative to current line
set showcmd             " show command in bottom bar
set nocursorline        " highlight current line

set signcolumn=yes			" Always show sign column

set wrap
set linebreak           " Wrap at word boundaries

set splitright          " Splits should be created on right
set splitbelow          " or below

set pumheight=15        " Max pop-up menu height

set wildmenu
set lazyredraw
set showmatch           " higlight matching parenthesis

set title
set nostartofline

set cmdheight=2					" Larger display for messages
set updatetime=300			" Smaller updatetime for CursorHold
set shortmess+=c				" Suppress completion messages
" }}}

" Searching {{{
set ignorecase          " ignore case when searching
set smartcase           " don't ignore case when using uppercase
set incsearch           " search as characters are entered
set hlsearch            " highlight all matches

set grepprg=rg\ --vimgrep
" }}}


" Backup {{{
set nobackup
set nowritebackup
set noswapfile
" }}}

" Scrolling {{{
set scrolloff=8     "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=6
" }}}

" Autocommands {{{
autocmd BufEnter Dockerfile* :setlocal filetype=Dockerfile
" }}}

" Custom Keymappings {{{
set pastetoggle=<F2>

" Line Shortcuts
nnoremap j gj
nnoremap k gk
nnoremap gV `[v`]

" Map save to Ctrl + S
map <C-s> :w<CR>
imap <C-s> <C-o>:w<CR>

" Map for Escape key
inoremap jk <Esc>
tnoremap <Leader>jk <C-\><C-n>

" Split Keymappings
nnoremap <Leader>v <C-w>v
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Clear highlighting before redrawing screen
nnoremap <Leader>c :nohl<CR>

" Open/source vimrc
nnoremap <Leader>rc :vsp ~/.config/nvim/init.vim<CR>
nnoremap <Leader>rcs :source ~/.config/nvim/init.vim<CR>

" }}}

" fzf {{{
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

nnoremap <leader>p :FZF<CR>
nnoremap <leader>f :Rg<CR>
nnoremap <leader>/ :Lines<CR>
" }}}

