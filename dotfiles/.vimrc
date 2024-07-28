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

" MAPS
" <leader>e to open netwr
noremap <leader>e :Vexplore <CR> 
" map F5 to show/hide list
nmap <F5> :set list! list?<cr>

" COMMANDS
" create ctags
command! MakeTags !ctags -R .

" SNIPPETS
" c++
nnoremap  <leader>sch   
	\ :-1read $HOME/.vim/snippets/cpp/hearder-def.snippet<CR>
	\ 3j

