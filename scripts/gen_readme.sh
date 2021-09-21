#!/bin/bash
declare -r ROOTDIR=$(cd "$(dirname $0)/../"; pwd)

cat << EOF
# dotfiles

A collection of dotfiles, utils, dev tools and editor I generally like to have
installed on every machine I work on, both local (my laptop) and remote (heavy
duty build server).

## Utils and dev tools

* **[FZF](https://github.com/junegunn/fzf)** command-line fuzzy finder
* **[ripgrep](https://github.com/BurntSushi/ripgrep)** fast line-oriented
  search tool
* **[Neovim](https://neovim.io)** hyperextensible Vim-based text editor
* **[OhMyZsh](https://github.com/ohmyzsh/ohmyzsh)** open source,
  community-driven framework for managing zsh configuration
* **[rustup](https://rustup.rs)** an installer for the systems programming
  language Rust
* **[sdkman](https://sdkman.io)** the Software Development Kit Manager
* **[NVM](https://github.com/nvm-sh/nvm)** version manager for Node.js
  JavaScript engine

## Make targets

$(cd $ROOTDIR; make -s help help_format=markdown)

Without a target \`make\` will just print the help message. I use \`make
install-all\` normally to install everything. Please, notice the \`try-it\` target
runs just the \`install\` target, it skip all the dev tools.

## Neovim plugins

$(cd $ROOTDIR; make -s help_nvim_plugins help_format=markdown)
EOF
