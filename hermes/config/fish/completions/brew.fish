function __get_brew_completion -d "Get all available formulae"
  brew search
end

complete -x -c brew -a "(__get_brew_completion)"
