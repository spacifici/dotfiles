#!/bin/bash
declare -r ROOTDIR=$(cd "$(dirname $0)/../"; pwd)

cat << EOF
A collection of dotfiles, utils, dev tools and editor I generally like to have
installed on every machine I work on, both local (my laptop) and remote (heavy
duty build server).

## Make targets

$(cd $ROOTDIR; make -s help help_format=markdown)

## Neovim plugins

$(cd $ROOTDIR; make -s help_nvim_plugins help_format=markdown)
EOF
