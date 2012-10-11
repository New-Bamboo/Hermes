#!/usr/bin/env bash
INSTALL_DIR=`pwd`
TIMESTAMP=`date +%Y%m%d%H%M%S`
LOGFILE=$INSTALL_DIR/install-$TIMESTAMP.log
TEMP_MANIFEST=/tmp/hermes_custom_manifest
touch $TEMP_MANIFEST

function log () {
  echo -e $@ >> $LOGFILE
}

function customise_manifest () {

  CONTENT=`cat $INSTALL_DIR/dotfile_manifest`

  for file in $CONTENT
    do
      if [ -e $HOME/.$file ]
        then
          echo "$HOME/.$file" >> $TEMP_MANIFEST
      fi
    done
}

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

function backup_dotfiles () {
  customise_manifest
  cd $HOME
  tar zcvf $INSTALL_DIR/dotfile_backup-$TIMESTAMP.tar.gz -I $TEMP_MANIFEST >> $LOGFILE 2>&1
  handle_error "($?)" "Backup failed, please see the install log for details"
}

log "Starting Hermes installation"

backup_dotfiles

# Check for dependencies
check_command_dependency brew
check_command_dependency rvm

# Install required tools
install_dependency macvim --override-system-vim
install_dependency reattach-to-user-namespace
install_dependency ack
install_dependency tmux
