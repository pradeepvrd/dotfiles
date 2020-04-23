" vim:fileencoding=utf-8:foldmethod=marker
" Neovim settings

" Plugins {{{
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

silent! if plug#begin(stdpath('data') . '/plugged')

" Hook functions for plugin installation
function! InstallVimspectorGadgets(info)
  if a:info.status == 'installed' || a:info.force
    let l:install_command = "./install_gadget.py --all --disable-tcl --enable-go --force-enable-node --force-enable-chrome"
    if executable("brew")
      let l:curr_path=$PATH
      let $PATH = "/usr/local/opt/node@10/bin:" . $PATH
      exec "!" . l:install_command
      let $PATH = curr_path
    elseif executable("nix-env")
      exec '!nix-shell -p python38Packages.setuptools nodejs-10_x --run "' . l:install_command . '"'
    else
      exec "!" . l:install_command
    endif
  endif
endfunction

" Editing support or easy mapping plugins
Plug 'tpope/vim-rsi'                                                         " Readline style Insert mode
Plug 'tpope/vim-surround'                                                    " All about surroundings
Plug 'tpope/vim-unimpaired'                                                  " provides complementary mappings
Plug 'tpope/vim-fugitive'                                                    " awesome git plugin
Plug 'tpope/vim-commentary'                                                  " easy commenting and uncommenting
Plug 'godlygeek/tabular'                                                     " tabularize stuff based on markers
Plug 'junegunn/fzf'                                                          " fuzzy searching
Plug 'junegunn/fzf.vim'                                                      " fuzzy searching vim specific support

" Easy navigation
Plug 'christoomey/vim-tmux-navigator'                                        " navigation between tmux and vim panes
Plug 'pradeepvrd/tmux-zsh-vim-titles'                                        " sync windows titles between shell, tmux and vim

" Appearance and themes
Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'itchyny/lightline.vim'                                                 " Configurable statusline
Plug 'edkolev/tmuxline.vim', {'on': 'Tmuxline'}                              " Generates tmux statusline to match vim status line

" Syntax highlighting support
Plug 'vitalk/vim-shebang'                                                    " Detect filetype based on shebang
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins', 'for': 'python'}      " Python
Plug 'tmhedberg/SimpylFold'                                                  " Python folding support
Plug 'othree/yajs.vim', {'for': 'javascript'}                                " Javascript
Plug 'othree/javascript-libraries-syntax.vim'                                " react, vue and other libraries
Plug 'HerringtonDarkholme/yats.vim', {'for': 'typescript'}                   " Typescript
Plug 'ekalinin/Dockerfile.vim', {'for': 'dockerfile'}                        " Dockerfile
Plug 'martinda/Jenkinsfile-vim-syntax', {'for': 'groovy'}                    " Jenkinsfile

" IDE like functionality
Plug 'neoclide/coc.nvim', {'branch': 'release'}                              " automcompletion and bunch of other stuff
Plug 'voldikss/vim-floaterm'                                                 " Floating Terminal
Plug 'skywind3000/asyncrun.vim'                                              " Allows commands to be run asynchronously
Plug 'skywind3000/asynctasks.vim'                                            " Define project tasks as asynchronous tasks
Plug 'liuchengxu/vista.vim'                                                  " Side bar to show all tags
Plug 'honza/vim-snippets'                                                    " Snippets source
Plug 'puremourning/vimspector', {'do': function('InstallVimspectorGadgets')} " Integrated debugger

call plug#end()
endif
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
set clipboard+=unnamedplus
set hidden
set noshowmode      " redundant since lighline shows the same info

let g:netrw_home=$XDG_CACHE_HOME . '/nvim'
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

set cmdheight=1			" Larger display for messages
set updatetime=300		" Smaller updatetime for CursorHold
set shortmess+=c		" Suppress completion messages

set foldmethod=syntax
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
autocmd BufWinEnter * silent! :%foldopen!
autocmd BufEnter Dockerfile* :setlocal filetype=Dockerfile
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0
autocmd FileType gitcommit setlocal textwidth=72
" }}}

" coc settings {{{
let g:coc_global_extensions = [
  \ "coc-docker",
  \ "coc-explorer",
  \ "coc-floaterm",
  \ "coc-git",
  \ "coc-go",
  \ "coc-json",
  \ "coc-lists",
  \ "coc-marketplace",
  \ "coc-pairs",
  \ "coc-prettier",
  \ "coc-python",
  \ "coc-sh",
  \ "coc-snippets",
  \ "coc-tasks",
  \ "coc-terminal",
  \ "coc-todolist",
  \ "coc-yaml",
  \ ]

autocmd FileType vim let b:coc_pairs_disabled = ['"']

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

function! LightLineGitStatus() abort
  let status = get(g:, 'coc_git_status', '')
  return status
endfunction

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

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

" }}}

" asyncrun {{{

let g:asyncrun_open = 6
let g:asynctasks_config_name = '.vim/tasks.ini'
let g:asynctasks_extra_config = [ "~/.config/nvim/tasks.ini" ]
let g:asynctasks_edit_split = 'auto'

" Override make command to use AsyncRun
" This ensures vim-fugitive runs the Gpull and Gfetch commands in Async
" https://github.com/skywind3000/asyncrun.vim/wiki/Cooperate-with-famous-plugins#fugitive
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
" }}}

" lightline {{{
let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'LightLineGitStatus',
      \   'cocstatus': 'coc#status',
      \   'currentfunction': 'CocCurrentFunction',
      \ },
      \ }

autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
autocmd User CocGitStatusChange call lightline#update()
" }}}

" Source extra configs {{{
function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

call SourceIfExists(stdpath('config') . '/docker.vim')
" }}}

" Custom Functions {{{
"
" remote yank
" copy to attached terminal using the yank(1) script:
" https://github.com/sunaku/home/blob/master/bin/yank
function! Yank(text) abort
  let escape = system('yank', a:text)
  if v:shell_error
    echoerr escape
  else
    call writefile([escape], '/dev/tty', 'b')
  endif
endfunction

function! QuickFix_toggle()
    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&buftype') == 'quickfix'
            cclose
            return
        endif
    endfor

    copen
endfunction
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

noremap <silent> <Leader>y y:<C-U>call Yank(@0)<CR>

nnoremap   <silent>   <F7>    :FloatermNew<CR>
tnoremap   <silent>   <F7>    <C-\><C-n>:FloatermNew<CR>
nnoremap   <silent>   <F8>    :FloatermPrev<CR>
tnoremap   <silent>   <F8>    <C-\><C-n>:FloatermPrev<CR>
nnoremap   <silent>   <F9>    :FloatermNext<CR>
tnoremap   <silent>   <F9>    <C-\><C-n>:FloatermNext<CR>
nnoremap   <silent>   <F10>   :FloatermToggle<CR>
tnoremap   <silent>   <F10>   <C-\><C-n>:FloatermToggle<CR>

nnoremap <leader>p :FZF<CR>
nnoremap <leader>f :Rg<CR>
nnoremap <leader>/ :Lines<CR>

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[d` and `]d` to navigate diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" navigate chunks of current buffer
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

nnoremap <silent> coq :call QuickFix_toggle()<cr>

" Remap for format selected region
xmap <leader>b  :Format<CR>
nmap <leader>b  :Format<CR>

" mapping for opening lists
nmap <leader>tl :CocList tasks<CR>
nmap <leader>tr :CocListResume<CR>
nmap <leader>te :AsyncTaskEdit<CR>
nmap <leader>tt :AsyncTask<space>
" }}}

