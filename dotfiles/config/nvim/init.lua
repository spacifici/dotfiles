local o = vim.o
local w = vim.wo
local b = vim.bo

-- Global options
o.cursorline=true
o.termguicolors=true
o.list=true
o.listchars=[[tab:▸ ,space:‿,eol:¶]]

-- Window options
w.relativenumber=true
w.number=true
w.colorcolumn="80"

-- Buffer Options
o.tabstop=4
o.shiftwidth=4
o.expandtab=true

-- filetype plugin on
-- filetype plugin indent on

-- Easier split navigations
-- tnoremap <C-h> <C-\><C-N><C-w>h
-- tnoremap <C-j> <C-\><C-N><C-w>j
-- tnoremap <C-k> <C-\><C-N><C-w>k
-- tnoremap <C-l> <C-\><C-N><C-w>l
-- inoremap <C-h> <C-\><C-N><C-w>h
-- inoremap <C-j> <C-\><C-N><C-w>j
-- inoremap <C-k> <C-\><C-N><C-w>k
-- inoremap <C-l> <C-\><C-N><C-w>l
-- nnoremap <C-h> <C-w>h
-- nnoremap <C-j> <C-w>j
-- nnoremap <C-k> <C-w>k
-- nnoremap <C-l> <C-w>l

