" vim:fileencoding=utf-8:ft=conf:foldmethod=marker
" Neovim settings

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Vim Plug {{{
silent! if plug#begin(stdpath('data') . '/plugged')

Plug 'tpope/vim-rsi'
Plug 'tpope/vim-surround'
Plug 'christoomey/vim-tmux-navigator'
Plug 'preservim/nerdcommenter'
Plug 'MikeDacre/tmux-zsh-vim-titles'

" Appearance and themes
Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'
Plug 'dracula/vim', { 'as': 'dracula' }

" Syntax highlighting
Plug 'vitalk/vim-shebang'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}  " Python
Plug 'othree/yajs.vim'                                  " Javascript
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'HerringtonDarkholme/yats.vim'                     " Typescript
Plug 'ekalinin/Dockerfile.vim'
Plug 'martinda/Jenkinsfile-vim-syntax'

" Fuzzy searching
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'antoinemadec/coc-fzf'

Plug 'voldikss/vim-floaterm'
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'puremourning/vimspector', {'do': './install_gadget.py --all --disable-tcl --enable-go --force-enable-node --force-enable-chrome'}

call plug#end()
" }}}

" Misc {{{

let nix_python = expand('~/.nix-profile/bin/nvim-python3')

if filereadable(nix_python)
  let g:python3_host_prog = nix_python
else
  let g:python3_host_prog = '/usr/local/bin/python3'
endif

let g:mapleader = " "

set history=500
set clipboard=unnamed
set hidden
endif
" }}}

" Colors {{{
syntax on
silent! colorscheme onedark
set bg=dark

if (has("termguicolors"))
  set termguicolors
endif
" }}}

" Spaces & Tabs {{{
set tabstop=2           " 2 space tab
set expandtab           " use spaces for tabs
set softtabstop=2       " 2 space tab
set shiftwidth=2

set modelines=1

set autoindent
" }}}

" UI Layout {{{
set number              " show line numbers
set relativenumber      " show line numbers relative to current line
set showcmd             " show command in bottom bar
set nocursorline        " highlight current line

set signcolumn=yes		" Always show sign column

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

set cmdheight=2			" Larger display for messages
set updatetime=300		" Smaller updatetime for CursorHold
set shortmess+=c		" Suppress completion messages
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
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0
autocmd FileType gitcommit setlocal textwidth=72
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

" Clear highlighting before redrawing screen
nnoremap <Leader>c :nohl<CR>

" Open/source vimrc
nnoremap <Leader>rc :vsp ~/.config/nvim/init.vim<CR>
nnoremap <Leader>rcs :source ~/.config/nvim/init.vim<CR>

" }}}

function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

" coc settings {{{
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Remap for format selected region
xmap <leader>b  :Format<CR>
nmap <leader>b  :Format<CR>

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')
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

nnoremap   <silent>   <F7>    :FloatermNew<CR>
tnoremap   <silent>   <F7>    <C-\><C-n>:FloatermNew<CR>
nnoremap   <silent>   <F8>    :FloatermPrev<CR>
tnoremap   <silent>   <F8>    <C-\><C-n>:FloatermPrev<CR>
nnoremap   <silent>   <F9>    :FloatermNext<CR>
tnoremap   <silent>   <F9>    <C-\><C-n>:FloatermNext<CR>
nnoremap   <silent>   <F10>   :FloatermToggle<CR>
tnoremap   <silent>   <F10>   <C-\><C-n>:FloatermToggle<CR>

let g:asyncrun_open = 6
let g:asynctasks_config_name = '.vim/tasks.ini'
let g:asynctasks_extra_config = [ "~/.config/nvim/tasks.ini" ]

function! s:my_runner(opts)
    echo "run: " . a:opts.cmd
endfunction

let g:asyncrun_runner = get(g:, 'asyncrun_runner', {})
let g:asyncrun_runner.test = function('s:my_runner')

call SourceIfExists(stdpath('config') . '/docker.vim')
