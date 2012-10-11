#!/usr/bin/env bash
cd $HOME
if [ -d .hermes ]; then
  echo "I found an existing Hermes folder (.hermes) in your home folder"
  exit 1
else
  git clone https://github.com/New-Bamboo/Hermes.git .hermes
  cd .hermes
  ./install.bash
fi
