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
u.map('n', '<Leader>f', ':FZF<cr>')

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

u.colorscheme('seoul256')

-- vim-airline config
g.airline_powerline_fonts = 1
g['airline#extensions#tabline#enabled'] = 1

-- filetype plugin on
-- filetype plugin indent on

