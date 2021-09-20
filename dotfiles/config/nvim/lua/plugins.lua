return require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- nvim-lspconfig
    use 'neovim/nvim-lspconfig'

    -- nvim-cmp (completion)
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/vim-vsnip',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
        }
    }

    -- rust-tools
    use 'simrat39/rust-tools.nvim'

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

    -- NERDTree & plugins
    use {
        'preservim/nerdtree',
        requires = {
            'Xuyuanp/nerdtree-git-plugin',
            'ryanoasis/vim-devicons',
            'tiagofumo/vim-nerdtree-syntax-highlight',
            'PhilRunninger/nerdtree-visual-selection'
        }
    }

    -- markdown-preview
    use {
        'iamcco/markdown-preview.nvim',
        run = function() vim.fn['mkdp#util#install']() end
    }
end)
