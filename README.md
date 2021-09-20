# dotfiles

My personal collection of dotfiles (**including `.gitconfig`**).

## Make targets
Run `make <target>` where target is one of the following:
* **help**   prints this help message
* **install** installs the dotfiles, neovim, fzf, ripgrep and Oh My Zsh
* **install-optional** installs optional packages (rustup, SDKMAN, Java, NVM and Node.js)
* **install-all** installs everything
* **install-dotfiles** installs recursively all the files in the dotfiles dir
* **install-fzf** installs fzf in `${HOME}/.local/bin`
* **install-ripgrep** installs ripgrep (rg) in `${HOME}/.local/bin` (and its manpage)
* **install-nvim** installs neovim in `${HOME}/opt`
* **install-oh-my-zsh** installs Oh My Zsh and the extra completion plugin
* **install-rust** installs rust (via rustup)
* **install-sdkman** installs SDKMAN
* **install-java** installs Java (JDK, using SDKMAN)
* **install-nvm** installs NVM
* **install-nodejs** installs Node.js (using NVM)
* **try-it** creates a docker container, runs `make install` and then runs an interactive shell in the container
