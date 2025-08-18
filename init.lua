vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

vim.o.swapfile = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.incsearch = true
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"

local map = vim.keymap.set

vim.g.mapleader = " "
function toggle_relativenumber()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end

-- Map the function to a key combination, e.g., <leader>rn
vim.keymap.set('n', '<leader>rn', ':lua toggle_relativenumber()<CR>')

-- vim.keymap.set('n', '<leader>oo', 'o<ESC>k')
-- vim.keymap.set('n', '<leader>OO', 'O<ESC>j')

-- vim.keymap.set('n', '<leader>s', ':update<CR>:source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('n', '<leader>mr', ':MRU<CR>');
vim.keymap.set('n', '<leader>x', '<c-w>c');
vim.keymap.set('n', '<leader>e', ':Oil<CR>');

vim.keymap.set('n', '<leader>y', '\"+y');
vim.keymap.set('n', '<leader>p', '\"+p');

vim.keymap.set('n', '<leader>n', ':bn<CR>');

vim.keymap.set({'n','v','x'}, '<leader>y', '"+y')
vim.keymap.set({'n','v','x'}, '<leader>d', '"+d')

vim.keymap.set({'n','v','x'}, '<leader>f', ":Pick files<CR>")
vim.keymap.set({'n','v','x'}, '<leader>h', ":Pick help<CR>")

vim.keymap.set({'n', 'v', 'x'}, '<c-d>', '<c-d>zz')
vim.keymap.set({'n', 'v', 'x'}, '<c-u>', '<c-u>zz')

-- vim.keymap.set({'n', 'v', 'x'}, 'U', 'u')
vim.keymap.set("n", "U", ":echo '                                   Do not use ''U'''\n", { silent = true })   

-- vim.keymap.set({'n','v','x'}, '<leader>clh', ':lua ClearUndoHistory()')

vim.pack.add({
    {src = "https://github.com/vague2k/vague.nvim"},
    {src = "https://github.com/stevearc/oil.nvim"},
    {src = "https://github.com/echasnovski/mini.pick"},
    {src = "https://github.com/yegappan/mru"},
    {src = 'https://github.com/folke/which-key.nvim'},
})

require "oil".setup()
require "mini.pick".setup()
local wk = require("which-key")
wk.setup({
    delay = 500,
    show_help = true,
})

-- -- function ClearUndoHistory()
--     local old_undolevels = vim.bo.undolevels
--     vim.bo.undolevels = -1
-- -- Safely simulate: insert mode, escape, undo — without inserting text
--     local esc = vim.fn.nr2char(27)
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('iu' .. esc .. 'u', true, false, true), 'n', false)
--     vim.bo.undolevels = old_undolevels
-- end   

vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=none")

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', {}),
  desc = 'Highlight selection on yank',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 500 }
  end,
})
