
--========================================================
-- Basic Settings
--========================================================
vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.undolevels = 10000

-- Treesitter folds
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

vim.opt.makeprg = [[./nrf-build.sh $*]]

--========================================================
-- Keymaps
--========================================================
local map = vim.keymap.set

local function toggle_relativenumber()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
end

map('n', '<leader>rn', toggle_relativenumber, { desc = 'Toggle relative number' })
map('n', '<leader>q', ':quit<CR>', { silent = true, desc = 'Quit' })
map('n', '<leader>x', '<C-w>c', { silent = true, desc = 'Close window' })
map('n', '<leader>ed', ':Oil<CR>', { silent = true, desc = 'Oil file explorer' })
map('n', '<leader>ec', ':edit $MYVIMRC<CR>:only<CR>', { silent = true, desc = 'Edit config' })
map('n', '<leader>ew', ':new<CR>:only<CR>', { silent = true, desc = 'Open new buffer' })
map('n', '<leader>l', ':ls<CR>', { silent = true, desc = 'List buffers' })
map('n', '<leader>w', '<C-w>j', { silent = true, desc = 'Next window' })

-- Clipboard
map({'n','v','x'}, '<leader>y', '"+y', { desc = 'Yank to clipboard' })
map({'n','v','x'}, '<leader>d', '"+d', { desc = 'Delete to clipboard' })
map('n', '<leader>p', '"+p', { desc = 'Paste from clipboard' })

-- Navigation niceties
map({'n','v','x'}, '<C-d>', '<C-d>zz', { desc = 'Page down centered' })
map({'n','v','x'}, '<C-u>', '<C-u>zz', { desc = 'Page up centered' })
map('n', 'U', function() print("Do not use 'U'") end, { silent = true })

--========================================================
-- Plugins (via vim.pack)
--========================================================
vim.pack.add({
    { src = "https://github.com/vague2k/vague.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/nvim-mini/mini.bufremove" },
    { src = "https://github.com/yegappan/mru" },
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/MunifTanjim/nui.nvim" },
    { src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
})

--========================================================
-- Telescope Setup
--========================================================
local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup({
    defaults = {
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 8,
        mappings = {
            i = { ["<esc>"] = require('telescope.actions').close },
        },
    },
})

map('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
map('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
map('n', '<leader>fb', builtin.buffers, { desc = 'List buffers' })
map('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
map('n', '<leader>fm', builtin.oldfiles, { desc = 'Recent files' })
map('n', '<leader>ft', builtin.treesitter, { desc = 'Treesitter' })

-- Project-specific Telescope shortcuts
map('n', '<leader>fc', function()
    builtin.find_files({ cwd = '../common' })
end, { desc = 'Find files in ../common' })

map('n', '<leader>fbp', function()
    builtin.find_files({ cwd = '../../boards/arm' })
end, { desc = 'Find files in ../../boards/arm' })

--========================================================
-- Plugin Configs
--========================================================
require('oil').setup({ default_file_explorer = false })
require('which-key').setup({ delay = 300, show_help = true })
require('mini.bufremove').setup()

--========================================================
-- UI & Misc
--========================================================
vim.cmd("colorscheme vague")
vim.cmd("hi StatusLine guibg=none")

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
    desc = 'Highlight on yank',
    callback = function()
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 500 })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "new" },
    callback = function()
        vim.cmd("wincmd o | resize")
        vim.opt_local.buflisted = true
    end,
})
