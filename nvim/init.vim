if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  silent !mkdir -p ~/.local/share/nvim/backup ~/.cache/nvim/swap ~/.local/share/undo
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif


"let g:python3_host_prog = $HOME . '/.local/venv/nvim/bin/python'
call plug#begin('~/.local/share/nvim/plugged')

"Appearance
Plug 'dguo/blood-moon', {'rtp': 'applications/vim'}
Plug 'ayu-theme/ayu-vim'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'

" Completion/Snips
"Plug 'neovim/nvim-lspconfig'
"Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
"Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
"Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}


" Editing
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'junegunn/goyo.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'godlygeek/tabular'
Plug 'Plasticboy/vim-markdown'
Plug 'psf/black', { 'branch': 'stable' }
Plug 'Lenovsky/nuake'
Plug 'christoomey/vim-tmux-navigator'
Plug 'sirtaj/vim-openscad'
Plug 'LnL7/vim-nix'

call plug#end()

nnoremap <buffer><silent> <c-q> <cmd>call Black()<cr>
inoremap <buffer><silent> <c-q> <cmd>call Black()<cr>

""" Appearance

" Colors
set termguicolors
colorscheme blood-moon
"let ayucolor="dark"
"colorscheme ayu
highlight Normal guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE

" Status Line
let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }
set noshowmode

" Editor
set relativenumber
set number
set title
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
set incsearch ignorecase smartcase hlsearch
set splitbelow
set splitright
set textwidth=0
set undofile
set undodir=~/.local/share/nvim/undo//
set backup
set backupdir=~/.local/share/nvim/backup//
set directory=~/.local/share/nvim/swap//
set spelllang=en_us
set hidden
set wildmode=longest:list,full
set omnifunc=syntaxcomplete#Complete
set cursorline
set nowrap
set colorcolumn=80
set foldenable
set foldmethod=syntax
set ww=b,s,h,l,<,>,[,]                  " left/right/h/l can change lines
set nofixendofline

" Search
set hlsearch
set incsearch
set smartcase


let g:black_target_version = "py310"

let g:deoplete#enable_at_startup = 1
let g:gutentags_cache_dir = expand('~/.cache/nvim/ctags/')
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+ailmnS',
      \ ]
let g:gutentags_ctags_exclude = [
      \ '*.git', '*.svg', '*.hg',
      \ '*/tests/*',
      \ 'build',
      \ 'dist',
      \ '*sites/*/files/*',
      \ 'bin',
      \ 'node_modules',
      \ 'bower_components',
      \ 'cache',
      \ 'compiled',
      \ 'docs',
      \ 'example',
      \ 'bundle',
      \ 'vendor',
      \ '*.md',
      \ '*-lock.json',
      \ '*.lock',
      \ '*bundle*.js',
      \ '*build*.js',
      \ '.*rc*',
      \ '*.json',
      \ '*.min.*',
      \ '*.map',
      \ '*.bak',
      \ '*.zip',
      \ '*.pyc',
      \ '*.class',
      \ '*.sln',
      \ '*.Master',
      \ '*.csproj',
      \ '*.tmp',
      \ '*.csproj.user',
      \ '*.cache',
      \ '*.pdb',
      \ 'tags*',
      \ 'cscope.*',
      \ '*.css',
      \ '*.less',
      \ '*.scss',
      \ '*.exe', '*.dll',
      \ '*.mp3', '*.ogg', '*.flac',
      \ '*.swp', '*.swo',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \ ]

""" Keyboard Mappings

" Terminal

" Navigation
nmap j gj
nmap k gk
"nmap <C-j> <C-w>j
"nmap <C-k> <C-w>k
"nmap <C-l> <C-w>l
"nmap <C-h> <C-w>h 
inoremap <silent> <C-h> <Esc>:TmuxNavigateLeft<cr>
inoremap <silent> <C-j> <Esc>:TmuxNavigateDown<cr>
inoremap <silent> <C-k> <Esc>:TmuxNavigateUp<cr>
inoremap <silent> <C-l> <Esc>:TmuxNavigateRight<cr>

map <space> <Leader>

" Space bar un-highligts search
noremap <silent> <leader><Space> :silent noh<Bar>echo<CR>

" Writing to files with root priviledges
cmap w!! w !sudo tee % > /dev/null

" Plugins
nmap <F8> :TagbarToggle<CR>
nnoremap <F4> :Nuake<CR>
inoremap <F4> <C-\><C-n>:Nuake<CR>
tnoremap <F4> <C-\><C-n>:Nuake<CR>

" LSP
"lua << EOF
"local lsp = require "lspconfig"
"local coq = require "coq"
"
"lsp.pyright.setup()
"lsp.pyright.setup(coq.lsp_ensure_capabilities())
"EOF
