let s:pluggedHome='~/.local/share/nvim/plugged'
if has('win32')
    let s:pluggedHome='~/AppData/Local/nvim-data/plugged'
endif

call plug#begin(s:pluggedHome)

" Unix and Mac specific stuff
if !has('win32')
    " vim-tmux-navigator
    Plug 'christoomey/vim-tmux-navigator'
endif

Plug 'junegunn/fzf'

"Code completion with Deoplete - enabled by ensime
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'wellle/tmux-complete.vim'

" NERDTree
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'junegunn/seoul256.vim'

" vim-airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" vim-devicons
Plug 'ryanoasis/vim-devicons'

" vim scrath
Plug 'mtth/scratch.vim'

" c-support
Plug 'WolfgangMehner/c-support'

" ag
Plug 'numkil/ag.nvim'

" Markdown support
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }

" vimwiki
Plug 'vimwiki/vimwiki'

" coc-nvim (LSP for nvim)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" fugitive
Plug 'tpope/vim-fugitive'

call plug#end()

" Use deoplete
"let g:deoplete#enable_at_startup = 1
"call deoplete#custom#option('sources', {
"            \ '_' : ['buffer', 'member', 'tag', 'file', 'omni', 'ultisnips', 'tmux-complete']
"            \})
"let g:tmuxcomplete#trigger = ''

" Easier split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" nerdtree git plugin
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

" Color scheme
colo seoul256
set background=dark
syntax enable

" vim-devicons
set encoding=UTF-8
let g:airline_powerline_fonts = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1

" vimwiki
let g:vimwiki_list = [{'path': '~/.vimwiki/', 'index': 'Home',
                        \ 'syntax': 'markdown', 'ext': '.md'}]

" General options
set number relativenumber
set colorcolumn=80
set listchars=tab:▸\ ,space:‿,eol:¶
set list
set cursorline
set tabstop=4
set shiftwidth=4
set expandtab
filetype plugin on
filetype plugin indent on

" Key mappings
map <silent> <Leader>' :NERDTreeToggle<CR>
map <silent> <Leader>z :FZF<CR>

" Auto commands
au BufRead,BufNewFile *.jsm setlocal ft=javascript
au BufRead,BufNewFile *.sc setlocal ft=scala
au Filetype nerdtree setlocal nolist
au Filetype javascript set ts=2 sw=2
au Filetype html set ts=2 sw=2
