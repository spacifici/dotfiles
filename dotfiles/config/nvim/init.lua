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

-- UI settings
o.guifont='FiraCode Nerd Font:h10'

-- NERDTree toggling
u.map('n', '<Leader>t', ':NERDTreeToggle<CR>', { noremap = true, silent = true})

g.solarized_termcolors=256
u.colorscheme('seoul256')

-- vim-airline config
g.airline_powerline_fonts = 1
g['airline#extensions#tabline#enabled'] = 1

-- Filetype dependant options
u.augroup('filetype_tab_expansion', { 
    'FileType make,sh,gitconfig setlocal noexpandtab|set foldmethod=marker',
    'FileType javascript,json,yaml setlocal tabstop=2|setlocal shiftwidth=2',
    'FileType markdown setlocal spell',
})

-- Mason setup
require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require('lspconfig')

mason_lspconfig.setup()
mason_lspconfig.setup_handlers {
    function (server_name)
        lspconfig[server_name].setup{}
    end
}

-- {{{ rust-tools setup
require("rust-tools").setup({
    server = {
        on_attach = function(_, bufnr)
            -- Hover actions
            vim.keymap.set("n", "<C-a>", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
        end,
    },
})
-- }}}

-- {{{ LSP Diagnostics Options setup
u.sign({name = 'DiagnosticSignError', text = ''})
u.sign({name = 'DiagnosticSignWarn', text = ''})
u.sign({name = 'DiagnosticSignHint', text = ''})
u.sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])
-- }}}

-- {{{ Completion setup
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300) 

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
        { name = 'path' },
        { name = 'nvim_lsp', keyword_length = 2 },
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lua', keyword_length = 2 },
        { name = 'buffer', keyword_length = 2 },
        { name = 'vsnip', keyword_length = 2 },
        { name = 'calc' },
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    formatting = {
        fields = {'menu', 'abbr', 'kind'},
        format = function(entry, item)
            local menu_icon ={
                nvim_lsp = 'λ',
                vsnip = '⋗',
                buffer = 'Ω',
                path = '🖫',
            }
            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },
})
-- }}}

-- {{{ Treesitter
require 'nvim-treesitter.configs'.setup {
    ensure_installed = { 'bash', 'javascript', 'lua', 'python', 'rust', 'toml' },
    auto_install = true,
    highlight = {
        enable = true
    },
    indent = { enable = true },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
    },
}

vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
-- }}}
