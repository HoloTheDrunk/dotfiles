" Plug plugins
call plug#begin('~/.vim/plugged')
	Plug 'preservim/nerdtree'
	Plug 'junegunn/vim-easy-align'
	Plug 'fladson/vim-kitty'
	Plug 'luochen1990/rainbow'
	Plug 'tpope/vim-surround'
	Plug 'vim-syntastic/syntastic'
	Plug 'vim-scripts/AutoComplPop'
	Plug 'vim-scripts/dbext.vim'
call plug#end()

" Plug vim-easy-align settings
"" Visual mode
xmap ga <Plug>(EasyAlign)
"" Motion/text object
nmap ga <Plug>(EasyAlign)

"==>==<==>==<==>==<==>==<==>==<==Syntastic==>==<==>==<==>==<==>==<==>==<==>==<=

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"==>==<==>==<==>==<==>==<==>==<=!Syntastic!=>==<==>==<==>==<==>==<==>==<==>==<=

" Basic settings
syntax on
set ai si sw=4 ts=4
set mouse=a
set cc=80
set number

set cursorline
hi CursorLine gui=bold cterm=bold

" Auto completion
inoremap {<CR> {<CR>}<Esc>ko

" Netrw settings
let g:netrw_liststyle    = 3
let g:netrw_banner       = 1
let g:netrw_browse_split = 4
let g:netrw_winsize      = 25
let g:netrw_altv         = 1

" SQL settings
let g:sql_type_default = 'pgsql'

fun! TrimWhitespace()
	let l:save = winsaveview()
	keeppatterns %s/\s\+$//e
	call winrestview(l:save)
endfun
autocmd BufWritePre * call TrimWhitespace()

" Autocompletion settings
set complete+=kspell,d
set completeopt=menuone,popup
set shortmess+=c
