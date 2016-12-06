scriptencoding utf8
set encoding=utf-8

set nocompatible

if &shell =~# 'fish$'
    set shell=/bin/bash
endif

syntax on
set synmaxcol=500 " Set a maximum column count for syntax color processing

" tamanho do tab é equivalente a 4 espaços
set tabstop=4 shiftwidth=4

" tabs não são convertidos para espaços
set noet

" highlight search
set hlsearch

" incremental search
set incsearch

" buscas em lowercase serão case insensitive, buscas em uppercase ou mixedcase serão case sensitive
set ignorecase smartcase

" mostra quantidade de caracteres selecionados quando em modo visual
set showcmd

set bg=dark

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50        " keep 50 lines of command line history
set ruler        " show the cursor position all the time
set showcmd        " display incomplete commands

set listchars=tab:>-,trail:-

" leader key for customized keyboard shortcuts
let mapleader=","

" pathogen
" https://github.com/tpope/vim-pathogen
execute pathogen#infect()
filetype plugin indent on

" configs for vim-go
au Filetype go nnoremap <leader>v :vsp <CR>:exe "GoDef" <CR>
au Filetype go nnoremap <leader>s :sp <CR>:exe "GoDef"<CR>
au Filetype go nnoremap <leader>t :tab split <CR>:exe "GoDef"<CR>
au FileType go nmap <leader>r <Plug>(go-rename)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>i <Plug>(go-info)
au FileType go nmap <leader>ds <Plug>(go-def-split)
let g:go_fmt_command = "goimports"
let g:go_dispatch_enabled = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
"let g:go_def_mode = 'godef'
let g:go_auto_sameids = 0
let g:go_metalinter_autosave = 0
let g:go_auto_type_info = 1

function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#cmd#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Install(0)
  endif
endfunction

autocmd FileType go nmap <leader>m :<C-u>call <SID>build_go_files()<CR>

" go command status
set statusline+=%#goStatuslineColor#
set statusline+=%{go#statusline#Show()}
set statusline+=%*

" expanding tabs to 4 spaces for html and js
au FileType html set expandtab tabstop=4 shiftwidth=4 cc=0
au FileType javascript set expandtab tabstop=4 shiftwidth=4 cc=0

" configs for python
au FileType python set expandtab tabstop=4 shiftwidth=4 cc=0
set foldmethod=indent
set foldlevel=99
" Enable folding with the spacebar
nnoremap <space> za
au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent fileformat=unix
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF

let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

" Smart autocompletion
set omnifunc=syntaxcomplete#Complete
" Close autocompletion preview window after a selection is made
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Toggle highlighting of search results with F3
nnoremap <F3> :set hlsearch!<CR>

noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <C-O>:update<CR>

autocmd Filetype gitcommit setlocal spell textwidth=90
autocmd Filetype gitcommit set cc=90

" NERDTree
" map NERDTree to Ctrl-N
map <C-n> :NERDTreeToggle<CR>

" splits
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

" go tagbar configuration
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }
nmap <F8> :TagbarToggle<CR>

" transparency
highlight Normal ctermbg=none
highlight NonText ctermbg=none

" lightline
set laststatus=2
set noshowmode
let g:lightline = {
    \ 'active': {
    \    'left': [ [ 'mode', 'paste' ],
    \              [ 'fugitive', 'readonly', 'filename', 'modified', 'goStatuslineColor' ]
    \            ]
    \ },
    \ 'component': {
    \    'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}',
	\    'goStatuslineColor': '%{go#statusline#Show()}'
    \ },
    \ 'component_visible_condition': {
    \    'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
    \ }
    \ }

let g:airline_section_c = "%f %#goStatuslineColor#%{go#statusline#Show()}*%#__restore__#"
let g:airline_powerline_fonts = 1

colorscheme molokai

" disable movement by arrows and make esc respond immediately (double win!)
" set noesckeys

" away with you, .swp files!
set noswapfile
set nobackup

" github.com/maralla/completor.vim
let g:completor_go_omni_trigger = '(?:\b[^\W\d]\w*|[\]\)])\.(?:[^\W\d]\w*)?'

" save automatically
set autowrite

" shortcuts for navigating the quickfix
map <C-c> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" don't use location lists
let g:go_list_type = "quickfix"

" go coverage
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

" go alternate between test file and normal file
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
