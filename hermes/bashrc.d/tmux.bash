function tm {
  tmux attach -t $(basename $(pwd)) || tmux new -s $(basename $(pwd))
}
