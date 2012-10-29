function __fish_brew_using_command
  set cmd (commandline -opc)
  if [ (count $cmd) -gt 1 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end
  return 1
end

function __fish_brew_available -d "Get all available formulae"
  brew search
end

function __fish_brew_installed -d "Get all available formulae"
  brew list
end

complete -c brew -s v -l verbose --description 'With --verbose, many commands print extra deb... [See Man Page]'
complete -c brew -l cache --description 'Display Homebrew\'s download cache'
complete -c brew -l cellar --description 'Display Homebrew\'s Cellar path'
complete -c brew -l config --description 'Show Homebrew and system configuration useful... [See Man Page]'
complete -c brew -l prefix --description 'Display Homebrew\'s install path'
complete -c brew -l repository --description 'Display where Homebrew\'s '
complete -c brew -l version --description 'Print the version number of brew to standard ... [See Man Page]'

complete -x -c brew -n '__fish_brew_using_command install' -a "(__fish_brew_available)"
complete -x -c brew -n '__fish_brew_using_command uninstall' -a "(__fish_brew_installed)"
