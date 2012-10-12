" Fixes syntax highlight for Ruby files
au BufRead,BufNewFile {Capfile,Gemfile,Rakefile,Thorfile,Vagrantfile,config.ru,.caprc,.irbrc,irb_tempfile*} set ft=ruby

" Fake '|' as text object
nnoremap di\| T\|d,
nnoremap da\| F\|d,
nnoremap ci\| T\|c,
nnoremap ca\| F\|c,
nnoremap yi\| T\|y,
nnoremap ya\| F\|y,
nnoremap vi\| T\|v,
nnoremap va\| F\|v,

" Fake '/' as text object
nnoremap di/ T/d,
nnoremap da/ F/d,
nnoremap ci/ T/c,
nnoremap ca/ F/c,
nnoremap yi/ T/y,
nnoremap ya/ F/y,
nnoremap vi/ T/v,
nnoremap va/ F/v,

" Zencoding
let g:user_zen_expandabbr_key = '<c-e>'
let g:use_zen_complete_tag = 1
