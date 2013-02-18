# cd to the path of the front Finder window
function cdf {
  target=`osascript -e 'tell application "Finder" to get POSIX path of (target of front Finder window as text)'`
  cd "$target"
}

alias ..='cd ..'
alias ...='cd ../..'
