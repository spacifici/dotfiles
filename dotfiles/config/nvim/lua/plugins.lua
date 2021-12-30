return require('packer').startup(function()
    use 'wbthomason/packer.nvim' -- Plugins management

    use 'neovim/nvim-lspconfig' -- Neovim LSP configuration

    use {
        'hrsh7th/nvim-cmp', -- Completion support
        requires = {
            'hrsh7th/cmp-nvim-lsp', -- Completion from LSP
            'hrsh7th/vim-vsnip', -- VSCode snippets completion
            'hrsh7th/cmp-buffer', -- Completion from buffer content
            'hrsh7th/cmp-path', -- File path completion
        }
    }

    use 'simrat39/rust-tools.nvim' -- It makes Rust development easier

    use 'junegunn/fzf' -- FZF integration

    use 'christoomey/vim-tmux-navigator' -- Easier navigation between Neovim windows and TMUX panels

    use 'junegunn/seoul256.vim' -- My favorite color scheme

    use 'vim-airline/vim-airline' -- Fancy status and tab line
    use 'vim-airline/vim-airline-themes' -- Themes for vim-airline

    use 'ryanoasis/vim-devicons' -- Icons everywhere

    use {
        'preservim/nerdtree', -- NERDTree file system explorer
        requires = {
            'Xuyuanp/nerdtree-git-plugin', -- Shows git status in NERDTree
            'tiagofumo/vim-nerdtree-syntax-highlight', -- Syntax highlighting for NERDTree
            'PhilRunninger/nerdtree-visual-selection' -- Action on selected files
        }
    }

    use {
        'iamcco/markdown-preview.nvim', -- Markdown preview in the Browser
        run = function() vim.fn['mkdp#util#install']() end
    }

    use {
        'nvim-treesitter/nvim-treesitter', -- Treesitter
        branch = 'master',
        run = function() vim.cmd('TSUpdate') end
    }

end)
