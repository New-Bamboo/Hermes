#!/usr/bin/env bash
INSTALL_DIR=`pwd`
TIMESTAMP=`date +%Y%m%d%H%M%S`
LOGFILE=$INSTALL_DIR/install-$TIMESTAMP.log
TEMP_MANIFEST=/tmp/$USER-hermes_custom_manifest
LAUNCHAGENTS_DIR=$HOME/Library/LaunchAgents
touch $TEMP_MANIFEST

# Set to non-zero value for debugging
DEBUG=0

# Colours
text_reset=$(tput sgr0)
underline=$(tput sgr 0 1)
bold=$(tput bold)
bold_red=${bold}$(tput setaf 1)
bold_green=${bold}$(tput setaf 76)
bold_orange=${bold}$(tput setaf 172)
bold_blue=${bold}$(tput setaf 27)
bold_yellow=${bold}$(tput setaf 142)
dark_blue=$bold$(tput setaf 21)
bold_white=${bold}$(tput setaf 7)
bold_grey=$bold$(tput setaf 238)

notice=$text_reset$bold_blue
success=$text_reset$bold_green
failure=$text_reset$bold_red
attention=$text_reset$bold_orange
information=$text_reset$bold_grey

package=$text_reset$bold_orange
component=$text_reset$bold_yellow
filename=$text_reset$underline$(tput setaf 246)
hermes=$text_reset$bold$(tput setaf 203)Hermes$text_reset

function log () {
  echo -e "$1"
  echo -e $@ >> $LOGFILE
}

function handle_error () {
  if [ "$?" != "0" ]; then
    log "${failure}$2 $1"
    exit 1
  fi
}

function customise_manifest () {
  log "${notice}Customising the $hermes ${notice}manifest file"
  CONTENT=`cat $INSTALL_DIR/manifests/dotfile_manifest`
  for file in $CONTENT; do
    if [ -e $HOME/.$file ]
      then
        echo "$HOME/.$file" >> $TEMP_MANIFEST
    fi
  done
}

function link_dotfiles () {
  log "${notice}Linking $hermes dotfiles to your home folder"
  CONTENT=`cat $INSTALL_DIR/manifests/dotfile_manifest`
  for file in $CONTENT; do
    SOURCE_FILE=$PWD/hermes/$file
    TARGET_FILE=$HOME/.$file
    if [ -e $SOURCE_FILE ]; then
      echo "${notice}Linking ${hermes} ${package}$file ${notice}to $filename$HOME/.$file"
      if [ $DEBUG == 0 ]; then
        ln -sf $SOURCE_FILE $TARGET_FILE
        handle_error "Could not link to $TARGET_FILE" "Symlinking:"
      fi
    fi
  done
}

function check_command_dependency () {
  $1 --version &> /dev/null
  handle_error $1 'There was a problem with:'
}

function install_homebrew () {
  log "${notice}Installing ${component}Homebrew ${notice}recipe ${package}$1"
  if [ $DEBUG == 0 ]; then
    HOMEBREW_OUTPUT=`brew install $1 2>&1`
    handle_error $1 "Homebrew had a problem\n($HOMEBREW_OUTPUT):"
  fi
}

function remove_homebrew () {
  log "Removing homebrew recipe $1"
  if [ $DEBUG == 0 ]; then
    HOMEBREW_OUTPUT=`brew uninstall $1 2>&1`
    handle_error $1 "Homebrew had a problem while removing\n($HOMEBREW_OUTPUT):"
  fi
}

function backup_dotfiles () {
  log "${notice}Backing up your dotfiles"
  customise_manifest
  cd $HOME
  BACKUP_FILE=$INSTALL_DIR/dotfile_backup-$TIMESTAMP.tar.gz
  if [ $DEBUG == 0 ]; then
    tar zcvf $BACKUP_FILE -I $TEMP_MANIFEST >> $LOGFILE 2>&1
    handle_error "($?)" "Backup failed, please see the install log for details"
  fi
  log "${notice}Your dotfiles are now backed up to $filename$BACKUP_FILE"
}

function homebrew_checkinstall_recipe () {
  brew list $1 &> /dev/null
  if [ $? == 0 ]; then
    log "${success}Your $package$1 ${success}installation is fine. Doing nothing"
  else
    install_homebrew $1
  fi
}

function homebrew_dependencies () {
  log "${notice}Installing ${component}Homebrew ${notice}dependencies. This may take a while"
  while read recipe; do
    homebrew_checkinstall_recipe $recipe
  done < "$INSTALL_DIR/manifests/homebrew_dependencies"
}

function install_vundle () {
  log "${notice}Installing Vundle"
  cd $INSTALL_DIR
  if [ $DEBUG == 0 ]; then
    mkdir -p hermes/vim/bundle
    git clone https://github.com/gmarik/vundle.git hermes/vim/bundle/vundle
    handle_error
  fi
}

function make_config_dir () {
  log "${notice}Making the ${hermes} ${notice}configuration folder"
  if [ $DEBUG == 0 ]; then
    mkdir -p $HOME/.config
  fi
}

function set_hermes_path () {
  log "Setting up the HERMES path"
  if [ $DEBUG == 0 ]; then
    touch "$INSTALL_DIR/hermes/bashrc.d/hermes-install-path.bash"
    echo "export HERMES_PATH=$INSTALL_DIR" > "$INSTALL_DIR/hermes/bashrc.d/hermes-install-path.bash"
  fi
}


log "${attention}Starting ${hermes} ${attention}installation"

backup_dotfiles

install_vundle

# Check for dependencies
check_command_dependency brew

homebrew_dependencies

make_config_dir
link_dotfiles
set_hermes_path

log "\n${hermes} ${success}is now installed."
log "${attention}Open a new ${component}iTerm ${attention}window to load your new environment.\n"
