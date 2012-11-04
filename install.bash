#!/usr/bin/env bash
INSTALL_DIR=`pwd`
TIMESTAMP=`date +%Y%m%d%H%M%S`
LOGFILE=$INSTALL_DIR/install-$TIMESTAMP.log
TEMP_MANIFEST=/tmp/$USER-hermes_custom_manifest
LAUNCHAGENTS_DIR=$HOME/Library/LaunchAgents
touch $TEMP_MANIFEST

# Set to non-zero value for debugging
DEBUG=1

# Colours
txtund=$(tput sgr 0 1)          # Underline
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldblu=${txtbld}$(tput setaf 4) #  blue
bldwht=${txtbld}$(tput setaf 7) #  white
txtrst=$(tput sgr0)             # Reset
info=${bldwht}*${txtrst}        # Feedback
pass=${bldblu}*${txtrst}
warn=${bldred}*${txtrst}
ques=${bldblu}?${txtrst}

function log () {
  echo -e "$(tput bold)$1$(tput sgr0)"
  echo -e $@ >> $LOGFILE
}

function handle_error () {
  if [ "$?" != "0" ]; then
    log "$2 $1"
    exit 1
  fi
}

function customise_manifest () {
  CONTENT=`cat $INSTALL_DIR/manifests/dotfile_manifest`
  for file in $CONTENT; do
    if [ -e $HOME/.$file ]
      then
        echo "$HOME/.$file" >> $TEMP_MANIFEST
    fi
  done
}

function link_dotfiles () {
  log "Linking the dotfiles to your home folder."
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
  log "Installing Homebrew recipe $1."
  if [ $DEBUG == 0 ]; then
    HOMEBREW_OUTPUT=`brew install $1 2>&1`
    handle_error $1 "Homebrew had a problem\n($HOMEBREW_OUTPUT):"
  fi
}

function remove_homebrew () {
  log "Removing homebrew recipe $1."
  if [ $DEBUG == 0 ]; then
    HOMEBREW_OUTPUT=`brew uninstall $1 2>&1`
    handle_error $1 "Homebrew had a problem while removing\n($HOMEBREW_OUTPUT):"
  fi
}

function backup_dotfiles () {
  log "Backing up your dotfiles."
  customise_manifest
  cd $HOME
  BACKUP_FILE=$INSTALL_DIR/dotfile_backup-$TIMESTAMP.tar.gz
  log "Your dotfiles are now backed up to $BACKUP_FILE."
  if [ $DEBUG == 0 ]; then
    tar zcvf $BACKUP_FILE -I $TEMP_MANIFEST >> $LOGFILE 2>&1
    handle_error "($?)" "Backup failed, please see the install log for details"
  fi
}

function homebrew_checkinstall_recipe () {
  brew list $1 &> /dev/null
  if [ $? == 0 ]; then
    log "Your $1 installation is fine. Doing nothing."
  else
    install_homebrew $1
  fi
}

function homebrew_checkinstall_vim () {
  log "Checking for a sane Vim installation."
  SKIP=`vim --version | grep '+clipboard'`
  if [[ "$SKIP" == "" ]]; then
    brew list macvim &> /dev/null
    if [ $? == 0 ]; then
      log "Removing Homebrew's macvim recipe."
      remove_homebrew "macvim"
    else
      log "You don't have Homebrew's macvim installed at all."
    fi
    install_homebrew $1
  else
    log "Your Vim installation is just fine. Doing nothing."
  fi
}

function homebrew_dependencies () {
  log "Installing Homebrew dependencies. This may take a while."
  while read recipe; do
    if [[ $recipe == macvim* ]]; then
      homebrew_checkinstall_vim $recipe
    else
      homebrew_checkinstall_recipe $recipe
    fi
  done < "$INSTALL_DIR/manifests/homebrew_dependencies"
}

function get_submodules () {
  log "Installing git submodules. This may take a while."
  cd $INSTALL_DIR
  if [ $DEBUG == 0 ]; then
    git submodule init && git submodule update &> /dev/null
    handle_error
  fi
}

function install_tmux_paste_buffer () {

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

  log "Installing Tmux paste buffer launch agent"
  log "Tmux paste buffer launch agent installed."
  log "To disable temporarily, run: launchctl unload $LAUNCHAGENTS_DIR/uk.co.newbamboo.hermes.plist"
  log "To disable permanently, run: launchctl -w unload $LAUNCHAGENTS_DIR/uk.co.newbamboo.hermes.plist"
    launchctl load -w $LAUNCHAGENTS_DIR/uk.co.newbamboo.hermes.plist
  fi
}

log "$(tput bold)Starting Hermes installation"

backup_dotfiles

get_submodules

# Check for dependencies
check_command_dependency brew
check_command_dependency rvm

homebrew_dependencies

mkdir -p $HOME/.config
link_dotfiles

install_tmux_paste_buffer
