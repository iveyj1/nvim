
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

map('n', '<leader>em', ':MRU<CR>',  { silent = true, desc = 'MRU' })
map('n', '<leader>eo', ':Oil<CR>',   { silent = true, desc = 'Oil file explorer' })
map("n", "<leader>ec", ":edit $MYVIMRC<CR>:only<CR>", { silent = true, desc = "Open config as only window" })   
map("n", "<leader>et", ":edit ~/.tmux.conf<CR>:only<CR>", { silent = true, desc = "Open tmux config as only window" })   
map("n", "<leader>ez", ":edit ~/.wezterm.lua<CR>:only<CR>", { silent = true, desc = "Open wezterm config as only window" })   
map('n', '<leader>ew', ':new<CR>:only<CR>', { silent = true; desc = 'open new file as only window'})
map('n', '<leader>ek', 'O<esc>j', { silent = true; desc = 'add new line above cursor'})
map('n', '<leader>ej', 'o<esc>k', { silent = true; desc = 'add new line below cursor'})

map('n', '<leader>l',  ':ls<CR>', {silent = true, desc = 'list buffers'})
map('n', '<leader>x', '<C-w>c',     { silent = true, desc = 'Close window' })
map('n', '<leader>k', ':bd<CR>',     { silent = true, desc = 'Close buffer' })
map('n', '<leader>w', ':w<CR>', { silent = true, desc = 'Write buffer' })
map('n', '<leader>q', ':quit<CR>',  { silent = true, desc = 'Quit' })
map('n', '<leader>n', ':bn<CR>',  { silent = true, desc = 'next buffer' })

map('n', 'go', ':put _<CR>', {silent = true, desc = 'open new line below cursor'})
map('n', 'gO', ':put! _<CR>', {silent = true, desc = 'open new line above cursor'})
-- map('i', 'jj', '<esc>',  { silent = true, desc = 'insert mode <escape> alias' })
map({'n','v','x'}, '<leader>rn', toggle_relativenumber, { desc = 'Toggle relative number' })

-- System clipboard
map({'n','v','x'}, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
map({'n','v','x'}, '<leader>Y', '"+y$', { desc = 'Yank to end of line to system clipboard' })
map({'n','v','x'}, '<leader>d', '"+d', { desc = 'Delete to system clipboard' })
map({'n','v','x'}, '<leader>D', '"+D', { desc = 'Delete to end of line to system clipboard' })
map({'n','v','x'}, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })

-- Navigation niceties
map({'n','v','x'}, '<C-d>', '<C-d>zz', { desc = 'Page down centered' })
map({'n','v','x'}, '<C-u>', '<C-u>zz', { desc = 'Page up centered' })
map({'n','v','x'}, 'U', function() print("Do not use 'U'") end, { silent = true })

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
    { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
    -- { src = "https://github.com/Mofiqul/vscode.nvim"  }
    { src = "https://github.com/lewis6991/gitsigns.nvim"},
    { src = "https://github.com/alexghergh/nvim-tmux-navigation" }

})

require('gitsigns').setup()

local nvim_tmux_nav = require('nvim-tmux-navigation')

nvim_tmux_nav.setup({
    disable_when_zoomed = true, -- defaults to false
})

vim.keymap.set('n', "<C-h>",     nvim_tmux_nav.NvimTmuxNavigateLeft)
vim.keymap.set('n', "<C-j>",     nvim_tmux_nav.NvimTmuxNavigateDown)
vim.keymap.set('n', "<C-k>",     nvim_tmux_nav.NvimTmuxNavigateUp)
vim.keymap.set('n', "<C-l>",     nvim_tmux_nav.NvimTmuxNavigateRight)
vim.keymap.set('n', "<C-\\>",    nvim_tmux_nav.NvimTmuxNavigateLastActive)
vim.keymap.set('n', "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)

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

-- Project-specific Telescope shortcuts
map('n', '<leader>fc', function()
    builtin.find_files({ cwd = '../common' })
end, { desc = 'Find files in ../common' })

map('n', '<leader>fx', function()
    builtin.find_files({ cwd = '../../boards/arm' })
end, { desc = 'Find files in ../../boards/arm' })

vim.keymap.set('n', '<leader>cd', function()
    vim.cmd('cd ' .. vim.fn.expand('%:p:h'))
end, { desc = 'Set working directory to path of buffer.' })

map('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
map('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
map('n', '<leader>fb', builtin.buffers, { desc = 'List buffers' })
map('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
map('n', '<leader>fm', builtin.oldfiles, { desc = 'Recent files' })
map('n', '<leader>ft', builtin.treesitter, { desc = 'Treesitter' })


-- Telescope Git status and history
map('n', '<leader>gs', builtin.git_status, { desc = 'Git status' })
map('n', '<leader>gc', builtin.git_commits, { desc = 'Git commits' })
map('n', '<leader>gb', builtin.git_branches, { desc = 'Git branches' })
map('n', '<leader>gB', builtin.git_bcommits, { desc = 'Buffer commits' })

map('n', '<leader>thd',  ':TSDisable highlight<cr>', { silent = true, desc = "Disable Treesitter syntax highlighting"})
map('n', '<leader>the',  ':TSEnable highlight<cr>', { silent = true, desc = "Disable Treesitter syntax highlighting"})

--========================================================
-- Plugin Configs
--========================================================
require('oil').setup({ default_file_explorer = false })
require('which-key').setup({ delay = 250, show_help = true })
require('mini.bufremove').setup()

-- Map 'k' to delete the current buffer using mini.bufremove
vim.keymap.set('n', '<leader>bd', ':lua require("mini.bufremove").delete(0, false)<CR>', { desc = 'Delete current buffer' })   

--========================================================
-- UI & Misc
--========================================================
-- vim.cmd("colorscheme vague")
require("rose-pine").setup({
    variant = "main", -- auto, main, moon, or dawn
})

vim.cmd.colorscheme("rose-pine")

local bg = "#0c0c0c"
vim.api.nvim_set_hl(0, "Normal",      { bg = bg })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = bg })
vim.api.nvim_set_hl(0, "SignColumn",  { bg = bg })
vim.api.nvim_set_hl(0, "LineNr",      { bg = bg })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = bg })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "#282828" }) -- Example dark gray background

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

