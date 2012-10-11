#!/usr/bin/env bash

function handle_error () {
  if [ "$?" != "0" ]
    then
      echo "Please install $1"
      exit 1
  fi
}

function check_command_dependency () {
  $1 --version &> /dev/null
  handle_error $1
}

# Check for dependencies
check_command_dependency brew
check_command_dependency rvm

