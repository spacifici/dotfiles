A collection of dotfiles, utils, dev tools and editor I generally like to have
installed on every machine I work on, both local (my laptop) and remote (heavy
duty build server).

## Make targets

Run `make <target>` where target is one of the following:
* **help** prints this help message
* **help_nvim_plugins** List all the installed Neovim plugins
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
