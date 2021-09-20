local g = vim.g
local o = vim.o
local w = vim.wo
local b = vim.bo

require('plugins')
local u = require('utils')

g.mapleader = ' '

-- Global options
o.cursorline=true
o.termguicolors=true
o.list=true
o.listchars=[[tab:▸ ,space:‿,eol:¶]]
o.tabstop=4
o.shiftwidth=4
o.expandtab=true

-- Window options
w.relativenumber=true
w.number=true
w.colorcolumn="80"

-- FZF shortcut
u.map('n', '<Leader>f', ':FZF<cr>', { silent = true })

-- Easier split navigations
u.map('t', '<C-h>', '<C-\\><C-N><C-w>h', { noremap = true })
u.map('t', '<C-j>', '<C-\\><C-N><C-w>j', { noremap = true })
u.map('t', '<C-k>', '<C-\\><C-N><C-w>k', { noremap = true })
u.map('t', '<C-l>', '<C-\\><C-N><C-w>l', { noremap = true })
u.map('i', '<C-h>', '<C-\\><C-N><C-w>h', { noremap = true })
u.map('i', '<C-j>', '<C-\\><C-N><C-w>j', { noremap = true })
u.map('i', '<C-k>', '<C-\\><C-N><C-w>k', { noremap = true })
u.map('i', '<C-l>', '<C-\\><C-N><C-w>l', { noremap = true })
u.map('n', '<C-h>', '<C-w>h', { noremap = true })
u.map('n', '<C-j>', '<C-w>j', { noremap = true })
u.map('n', '<C-k>', '<C-w>k', { noremap = true })
u.map('n', '<C-l>', '<C-w>l', { noremap = true })

-- NERDTree toggling
u.map('n', '<Leader>t', ':NERDTreeToggle<CR>', { noremap = true, silent = true})

g.solarized_termcolors=256
u.colorscheme('seoul256')

-- vim-airline config
g.airline_powerline_fonts = 1
g['airline#extensions#tabline#enabled'] = 1

u.augroup('filetype_tab_expansion', { 
    'FileType make,sh setlocal noexpandtab|set foldmethod=marker',
    'FileType javascript,json setlocal tabstop=2|setlocal shiftwidth=2',
})

-- Language Servers
local lsp=require'lspconfig'
lsp.rust_analyzer.setup{}

-- The following config is taken from https://sharksforarms.dev/posts/neovim-rust/
-- {{{
o.completeopt="menuone,noinsert,noselect"
o.shortmess=o.shortmess..'c'

-- Setting up rust-tools
require('rust-tools').setup({
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
})

require('rust-tools').setup(opts)

-- Completion setup
local cmp = require'cmp'
cmp.setup({
    -- Enable LSP snippets
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Add tab support
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        })
    },
    -- Installed sources
    sources = {
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'path' },
        { name = 'buffer' },
    },
})
-- }}}
