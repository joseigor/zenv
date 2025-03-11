set nocompatible                   " sets non compatibility with vi
syntax on                          " enable syntax highlight 
let mapleader = " "                " sets the leader key to space 
set title                          " show title
set path+=**                       " search current directory recursively
set wildmenu                       " shows the found files in a window menu when we tab complete 
set wrap                         " does not wrap text on screen
set rnu                            " sets relative line number
set noswapfile                     " disable swap files
set encoding=UTF-8
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent
set mouse=a
set spelllang=en
set spell
" Set the highlight for spelling errors (SpellBad)
highlight SpellBad term=underline cterm=underline ctermfg=Red gui=underline guifg=Red
set listchars=eol:$,space:-,tab:>#,trail:~
" Make search case-insensitive unless capital letters are used
set ignorecase
set smartcase

"-------------------- start: PLUGINS --------------------
call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'
Plug 'aklt/plantuml-syntax'
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'preservim/nerdtree'
call plug#end()
"-------------------- end: PLUGINS --------------------


"-------------------- start: MAPS --------------------
" <leader>e to open netwr
noremap <leader>e :Vexplore <CR> 
" map F5 to show/hide list
nmap <F5> :set list! list?<cr>
" Normal mode mapping for <C-f>
nnoremap <C-f> :Files<CR>
" Insert mode mapping for <C-f>
inoremap <C-f> <Esc>:w<CR>:Files<CR>a

" Make `jj` exit insert mode (alternative to ESC)
inoremap jj <ESC>

" Save file with `Ctrl + s`
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>
vnoremap <C-s> <Esc>:w<CR>

" Move the curso in insert mode using `Ctrl + hjkl`
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-j> <Down>
inoremap <C-k> <Up>

" Move between splits easily with  `Ctrl + hjkl`
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Close buffer with `Ctrl + x`
nnoremap <C-x> :bd<CR>

" Move up and down wrapped line with `jk`
nnoremap j gj
nnoremap k gk<Left>

" Resize windows using arrow keys
noremap <C-Up> :resize +2<CR>
noremap <C-Down> :resize -2<CR>
noremap <C-Left> :vertical resize +2<CR>
noremap <C-Right> :vertical resize -2<CR>

" Split  window shortcut
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>s :split<CR>

" Replace word under curso with confirmation `leader r`
nnoremap <leader>r :%s/\<<C-r><C-w>\>//gcI<Left><Left><Left><Left>

" NERDTree maps
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" SNIPPETS
" c++
nnoremap  <leader>sch   
	\ :-1read $HOME/.vim/snippets/cpp/hearder-def.snippet<CR>
	\ 3j

"-------------------- end: MAPS --------------------

"-------------------- start: NERDTree configuration --------------------------
" Start  NERDTree and leave the curso in it.
autocmd VimEnter * NERDTree

"-------------------- end: NERDTree configuration --------------------------
"
"-------------------- start: gruvbox configuration --------------------------
set termguicolors
set background=dark
let g:gruvbox_contrast_dark = 'medium'
" colorschema gruvbox is raising an error if called from here, so it needs to
" be called from the command : colorschema gruvbox
"-------------------- end: gruvbox configuration --------------------------

"-------------------- start: IDE configuration --------------------------
function! SetupIde()
    " Set the colorscheme to Gruvbox
    colorscheme gruvbox
endfunction

" Define the SetupIde command
command! SetupIde call SetupIde()

" Automatically run SetupIde when Vim starts
autocmd VimEnter * ++nested SetupIde
"-------------------- end: IDE configuration --------------------------

"-------------------- start: coc.nvim configuration -------------------
" NOTE: If coc.nvim is not needed lines below can be removed

" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" use <tab> to trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

" remap <cr> to make it confirm completion
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" make <cr> select the first completion item and confirm the completion when no item has been selected
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

" make coc.nvim format your code on <cr>
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
"-------------------- end: coc.nvim biddings --------------------------
