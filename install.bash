#!/usr/bin/env bash

function handle_error () {
  if [ "$?" != "0" ]
    then
      echo -e "$2 $1"
      exit 1
  fi
}

function check_command_dependency () {
  $1 --version &> /dev/null
  handle_error $1 'There was a problem with:'
}

function install_dependency () {
  HOMEBREW_OUTPUT=`brew install $@ 2>&1`
  handle_error $1 "Homebrew had a problem\n($HOMEBREW_OUTPUT):"
}

# Check for dependencies
check_command_dependency brew
check_command_dependency rvm

# Install required tools
install_dependency macvim --override-system-vim
install_dependency reattach-to-user-namespace
install_dependency ack
install_dependency tmuxx
