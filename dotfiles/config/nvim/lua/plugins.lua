return require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- nvim-lspconfig
    use 'neovim/nvim-lspconfig'

    -- fzf-vim
    use 'junegunn/fzf'

    -- vim-tmux-navigator
    use 'christoomey/vim-tmux-navigator'

    -- seoul256 color scheme
    use 'junegunn/seoul256.vim'

    -- vim-airline
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'

    -- vim-devicons
    use 'ryanoasis/vim-devicons'
end)
