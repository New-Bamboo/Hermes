" Set leader key
let mapleader = ","

" Help for word under cursor
:map <leader>h "zyw:exe "h ".@z.""<CR>

" Autocomplete
function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction
:inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>

" Fixes pasting
noremap <leader>y "*y
noremap <leader>p :set paste<CR>"*p<CR>:set nopaste<CR>
noremap <leader>P :set paste<CR>"*P<CR>:set nopaste<CR>"

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" map ctrl-hjkl for easy window movement
map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l

" Faster shortcut for commenting. Requires T-Comment plugin
map <leader>c <c-_><c-_>

"Saves time; maps the spacebar to colon
nmap <space> :

"Bubble single lines (kicks butt)
"http://vimcasts.org/episodes/bubbling-text/
nmap <C-Up> ddkP
nmap <C-Down> ddp
nmap <C-Left> <<
nmap <C-Right> >>

"Horizontal bubbling
vnoremap < <gv
vnoremap > >gv
nmap gV `[v`]

"Bubble multiple lines
vmap <C-Up> xkP`[V`]
vmap <C-Down> xp`[V`]
vmap <C-Right> >gv
vmap <C-Left> <gv

"tab navigation
nmap <silent> <Left> :tabprevious<cr>
nmap <silent> <Right> :tabnext<cr>

"swap panes layout
nmap <F9> <C-w>t<C-w>H
nmap <F10> <C-w>t<C-w>K

"tagbar
nmap <F6> :TagbarToggle<CR>

"enable . in visual mode
vnoremap . :norm.<CR>

"Markdown links without copied link
nmap <leader>l ysiw]f]a()<Left>

" Emmet
let g:user_emmet_expandabbr_key = '<c-e>'

"Remap NerdTree
nmap <silent> <leader>3 :NERDTreeToggle<cr>

"Remap CtrlP
nmap <silent> <leader>1 :CtrlP<cr>

"SplitJoin
let g:splitjoin_split_mapping = ''
let g:splitjoin_join_mapping = ''

nmap <Leader>j :SplitjoinJoin<cr>
nmap <Leader>s :SplitjoinSplit<cr>
