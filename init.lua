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
vim.keymap.set('n', '<leader>rn', ':lua toggle_relativenumber()<CR>', {noremap = true})

vim.keymap.set('n', '<leader>oo', 'o<ESC>k', {noremap = true})
vim.keymap.set('n', '<leader>OO', 'O<ESC>j', {noremap = true})

vim.keymap.set('n', '<leader>o', ':update<CR>:source<CR>', {noremap = true})
vim.keymap.set('n', '<leader>w', ':write<CR>', {noremap = true})
vim.keymap.set('n', '<leader>q', ':quit<CR>', {noremap = true})
vim.keymap.set('n', '<leader>mr', ':MRU<CR>', {noremap = true});
vim.keymap.set('n', '<leader>x', '<c-w>c', {noremap = true});
vim.keymap.set('n', '<leader>e', ':Oil<CR>', {noremap = true});

vim.keymap.set('n', '<leader>n', ':bn<CR>', {noremap = true});

vim.keymap.set({'n','v','x'}, '<leader>y', '"+y')
vim.keymap.set({'n','v','x'}, '<leader>d', '"+d')

vim.keymap.set({'n','v','x'}, '<leader>f', ":Pick files<CR>")
vim.keymap.set({'n','v','x'}, '<leader>h', ":Pick help<CR>")

vim.pack.add({
    {src = "https://github.com/vague2k/vague.nvim"},
    {src = "https://github.com/stevearc/oil.nvim"},
    {src = "https://github.com/echasnovski/mini.pick"},
    {src = "https://github.com/yegappan/mru"},
})

require "oil".setup()
require "mini.pick".setup()


vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=none")

