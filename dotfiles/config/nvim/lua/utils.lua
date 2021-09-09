local M={}

function M.map(mode, keys, action, options)
    if options == nil then
        options = {}
    end
    vim.api.nvim_set_keymap(mode, keys, action, options)
end

return M
