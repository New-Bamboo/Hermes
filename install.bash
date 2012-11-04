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
    SOURCE_FILE=$HOME/.hermes/hermes/$file
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

function homebrew_checkinstall_vim () {
  log "${notice}Checking for a sane ${component}Vim ${notice}installation"
  SKIP=`vim --version | grep '+clipboard'`
  if [[ "$SKIP" == "" ]]; then
    brew list macvim &> /dev/null
    if [ $? == 0 ]; then
      log "${attention}Removing ${component}Homebrew's ${package}macvim ${attention}recipe"
      remove_homebrew "macvim"
    else
      log "${notice}You don't have ${component}Homebrew's ${package}macvim ${notice}installed at all"
    fi
    install_homebrew $1
  else
    log "${success}Your ${component}Vim ${success}installation is fine. Doing nothing"
  fi
}

function homebrew_dependencies () {
  log "${notice}Installing ${component}Homebrew ${notice}dependencies. This may take a while"
  while read recipe; do
    if [[ $recipe == macvim* ]]; then
      homebrew_checkinstall_vim $recipe
    else
      homebrew_checkinstall_recipe $recipe
    fi
  done < "$INSTALL_DIR/manifests/homebrew_dependencies"
}

function get_submodules () {
  log "${notice}Installing ${component}git ${notice}submodules. This may take a while"
  cd $INSTALL_DIR
  if [ $DEBUG == 0 ]; then
    git submodule init && git submodule update &> /dev/null
    handle_error
  fi
}

function install_tmux_paste_buffer () {

  log "${notice}Installing the ${component}Tmux ${notice}paste buffer launch agent"
  if [ $DEBUG == 0 ]; then
    mkdir -p $LAUNCHAGENTS_DIR

(
cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>uk.co.newbamboo.hermes</string>
    <key>ProgramArguments</key>
    <array>
      <string>$(which reattach-to-user-namespace)</string>
      <string>-l</string>
      <string>$HOME/.hermes/hermes/bin/tmux-paste-buffer</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
  </dict>
</plist>
EOF
) > $LAUNCHAGENTS_DIR/uk.co.newbamboo.hermes.plist

    launchctl load -w $LAUNCHAGENTS_DIR/uk.co.newbamboo.hermes.plist
  fi
  log "${success}The ${component}Tmux ${success}paste buffer launch agent is now installed"
  log "${information}To disable temporarily, run: launchctl unload $LAUNCHAGENTS_DIR/uk.co.newbamboo.hermes.plist"
  log "${information}To disable permanently, run: launchctl -w unload $LAUNCHAGENTS_DIR/uk.co.newbamboo.hermes.plist"
}

function make_config_dir () {
  log "${notice}Making the ${hermes} ${notice}configuration folder"
  if [ $DEBUG == 0 ]; then
    mkdir -p $HOME/.config
  fi
}

log "${attention}Starting ${hermes} ${attention}installation"

backup_dotfiles

get_submodules

# Check for dependencies
check_command_dependency brew
check_command_dependency rvm

homebrew_dependencies

make_config_dir
link_dotfiles

install_tmux_paste_buffer

log "\n${hermes} ${success}is now installed."
log "${attention}Open a new ${component}iTerm ${attention}window to load your new environment.\n"
