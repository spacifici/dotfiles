local M={}
local cmd=vim.cmd

function M.map(mode, keys, action, options)
    if options == nil then
        options = {}
    end
    vim.api.nvim_set_keymap(mode, keys, action, options)
end

function M.colorscheme(name)
    cmd('colorscheme '..name)
end

function M.augroup(name, ...)
    cmd('augroup '..name)
    cmd('au!')
    for _,v in ipairs(...) do
        cmd('au '..v)
    end
    cmd('augroup END')
end

function M.sign(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = ''
    })
end

return M
