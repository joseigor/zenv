set nocompatible                   " sets non compatibility with vi
syntax on                          " enable syntax highlight 
let mapleader = " "                " sets the leader key to space 
set title                          " show title
set path+=**                       " search current directory recursively
set wildmenu                       " shows the found files in a window menu when we tab complete 
set nowrap                         " does not wrap text on screen
set rnu                            " sets relative line number
set noswapfile                     " disable swap files
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent
set mouse=a
set spelllang=en
set spell
set listchars=eol:$,space:-,tab:>#,trail:~

" FILE BROWSING
let g:netrw_altv = 1                           " changes from left splitting to right splitting
let g:netrw_browse_split = 4                   " open in prior window
let g:netrw_banner = 0                         " gets rid of the top banner
let g:netrw_liststyle = 3                      " sets tree stile view
let g:netrw_winsize = 30                       " set the window size when netrw opens
let g:netrw_list_hide = netrw_gitignore#Hide() " does not show file ignored by git in the explorer

" PLUGINS
call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'
call plug#end()


" MAPS
" <leader>e to open netwr
noremap <leader>e :Vexplore <CR> 
" map F5 to show/hide list
nmap <F5> :set list! list?<cr>
" Normal mode mapping for <C-f>
nnoremap <C-f> :Files<CR>
" Insert mode mapping for <C-f>
inoremap <C-f> <Esc>:w<CR>:Files<CR>a

" COMMANDS
" create ctags
command! MakeTags !ctags -R .

" SNIPPETS
" c++
nnoremap  <leader>sch   
	\ :-1read $HOME/.vim/snippets/cpp/hearder-def.snippet<CR>
	\ 3j

"-------------------- start: gruvbox configuration --------------------------
set termguicolors
set background=dark
let g:gruvbox_contrast_dark = 'medium'
colorscheme gruvbox
"-------------------- end: gruvbox configuration --------------------------

"-------------------- start: coc.nvim configuration --------------------------
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
