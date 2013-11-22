augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  au FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
  " Instead of reverting the cursor to the last position in the buffer, we
  " set it to the first line when editing a git commit message
  " Thanks: https://github.com/spf13/spf13-vim/blob/3.0/.vimrc#L92-L94
  au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
  " Remove trailing whitespace before saving a file
  au FileType ruby,javascript,css,scss,sass,html autocmd BufWritePre <buffer> :%s/\s\+$//e
augroup END

" Save when losing focus
au FocusLost * :silent! wall

"Reload config files after edit
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif
