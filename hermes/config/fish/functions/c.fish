function c --description cat with color
  # if the file is readable by pygmentize, use it. Falls back to cat.
  pygmentize $argv 2> /dev/null; or cat $argv
end
