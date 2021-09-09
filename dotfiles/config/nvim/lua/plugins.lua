return require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- nvim-lspconfig
    use 'neovim/nvim-lspconfig'

    -- fzf-vim
    use 'junegunn/fzf'

    -- vim-tmux-navigator
    use 'christoomey/vim-tmux-navigator'

end)
