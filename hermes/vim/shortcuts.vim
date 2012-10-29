"Change leader key
let mapleader="§"

" Help for word under cursor
:map <leader>h "zyw:exe "h ".@z.""<CR>

" Fixes pasting
noremap <leader>y "*y
noremap <leader>p :set paste<CR>"*p<CR>:set nopaste<CR>
noremap <leader>P :set paste<CR>"*P<CR>:set nopaste<CR>"

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

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

"enable . in visual mode
vnoremap . :norm.<CR>

" NERDTree
map <leader>3 :NERDTreeToggle<CR>

"Ctrlp shortcuts
nmap <silent> <leader>1 :CtrlP<cr>
nmap <silent> <Leader>2 :CtrlPTag<cr>

"Automplete with §
imap § <C-n>

"Fixes end of line movement in visual mode
vmap $ g_
