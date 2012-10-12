"Key fixes for Tmux
map [A <C-Up>
map [B <C-Down>
map [D <C-Left>
map [C <C-Right>

" Vimux
let VimuxHeight = "30"
let VimuxOrientation = "v"
let VimuxUseNearestPane = 1

if exists('$TMUX')
  " Prompt for a command to run
  map <Leader>rp :PromptVimTmuxCommand<CR>

  " Run last command executed by RunVimTmuxCommand
  map <Leader>rl :RunLastVimTmuxCommand<CR>

  " Inspect runner pane
  map <Leader>ri :InspectVimTmuxRunner<CR>

  " Close all other tmux panes in current window
  map <Leader>rx :CloseVimTmuxPanes<CR>

  " Interrupt any command running in the runner pane
  map <Leader>rs :InterruptVimTmuxRunner<CR>

  " If text is selected, save it in the v buffer and send that buffer it to tmux
  vmap <Leader>r "vy :call RunVimTmuxCommand(@v)<CR>

  " Select current paragraph and send it to tmux
  nmap <Leader>r vip<LocalLeader>vs<CR>

  " Run tests
  nmap <leader>t <Plug>SendTestToTmux
  nmap <leader>f <Plug>SendFocusedTestToTmux
endif
