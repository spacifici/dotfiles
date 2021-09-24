# dotfiles

A collection of dotfiles, utils, dev tools and editor I generally like to have
installed on every machine I work on, both local (my laptop) and remote (heavy
duty build server).

## Software

Through the `Makefile` targets, the following software can be installed. See
[Make targets](#make-targets) to check which target install which software.

* **[FZF](https://github.com/junegunn/fzf)**  command-line fuzzy search with bash and zsh integration
* **[ripgrep](https://github.com/BurntSushi/ripgrep)**  line-oriented search tool that recursively searches the current directory for a regex pattern. It respects gitignore rules and skips hidden files and directories
* **[Neovim](https://neovim.io)**  a Vim-based text editor engineered for extensibility and usability
* **[OhMyZsh](https://ohmyz.sh)**  a delightful, open source, community-driven framework for managing your zsh configuration
* **[rustup](https://rustup.rs)**  installs The Rust Programming Language from the official release channels, enabling you to easily switch between stable, beta, and nightly compilers and keep them updated
* **[rust-analyzer](https://rust-analyzer.github.io)**  an implementation of Language Server Protocol for the Rust programming language that provides features like completion and goto definition for many code editors
* **[SDKMAN](https://sdkman.io)**  a tool for managing parallel versions of multiple Software Development Kits on most Unix based systems
* **[Node Version Manager](https://github.com/nvm-sh/nvm-sh)**  a version manager for node.js, designed to be installed per-user, and invoked per-shell

## Make targets

Run `make <target>` where target is one of the following:

* **help** prints this help message
* **install** installs the dotfiles, neovim, fzf, ripgrep and Oh My Zsh
* **install-optional** installs optional packages (rustup, SDKMAN, Java, NVM and Node.js)
* **install-all** installs everything
* **install-dotfiles** installs recursively all the files in the dotfiles dir
* **install-fzf** installs fzf in ${HOME}/.local/bin
* **install-ripgrep** installs ripgrep (rg) in ${HOME}/.local/bin (and its manpage)
* **install-nvim** installs neovim in ${HOME}/opt
* **install-oh-my-zsh** installs Oh My Zsh and the extra completion plugin
* **install-rust** installs rust (via rustup)
* **install-sdkman** installs SDKMAN
* **install-java** installs Java (JDK, using SDKMAN)
* **install-nvm** installs NVM
* **install-nodejs** installs Node.js (using NVM)
* **try-it** creates a docker container, runs `make install` and then runs an interactive shell in the container

## Neovim plugins

Neovim configuration comes with the following plugins listed in
[plugins.lua](dotfiles/config/nvim/lua/plugins.lua). They get installed with
the `install-nvim` Makefile target.

* **[wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim)**  Plugins management
* **[neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)**  Neovim LSP configuration
* **[hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp)**  Completion support
* **[hrsh7th/cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)**  Completion from LSP
* **[hrsh7th/vim-vsnip](https://github.com/hrsh7th/vim-vsnip)**  VSCode snippets completion
* **[hrsh7th/cmp-buffer](https://github.com/hrsh7th/cmp-buffer)**  Completion from buffer content
* **[hrsh7th/cmp-path](https://github.com/hrsh7th/cmp-path)**  File path completion
* **[simrat39/rust-tools.nvim](https://github.com/simrat39/rust-tools.nvim)**  It makes Rust development easier
* **[junegunn/fzf](https://github.com/junegunn/fzf)**  FZF integration
* **[christoomey/vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)**  Easier navigation between Neovim windows and TMUX panels
* **[junegunn/seoul256.vim](https://github.com/junegunn/seoul256.vim)**  My favorite color scheme
* **[vim-airline/vim-airline](https://github.com/vim-airline/vim-airline)**  Fancy status and tab line
* **[vim-airline/vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)**  Themes for vim-airline
* **[ryanoasis/vim-devicons](https://github.com/ryanoasis/vim-devicons)**  Icons everywhere
* **[preservim/nerdtree](https://github.com/preservim/nerdtree)**  NERDTree file system explorer
* **[Xuyuanp/nerdtree-git-plugin](https://github.com/Xuyuanp/nerdtree-git-plugin)**  Shows git status in NERDTree
* **[tiagofumo/vim-nerdtree-syntax-highlight](https://github.com/tiagofumo/vim-nerdtree-syntax-highlight)**  Syntax highlighting for NERDTree
* **[PhilRunninger/nerdtree-visual-selection](https://github.com/PhilRunninger/nerdtree-visual-selection)**  Action on selected files
* **[iamcco/markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)**  Markdown preview in the Browser
