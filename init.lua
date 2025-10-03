--  Leader first
vim.g.mapleader = " "

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.swapfile = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.signcolumn = "yes"
-- Treesitter folds
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false
-- Keymaps
local map = vim.keymap.set

local function toggle_relativenumber()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
end

map('n', '<leader>rn', toggle_relativenumber, { desc = 'Toggle relative number' })

map('n', '<leader>q', ':quit<CR>',  { silent = true, desc = 'Quit' })
map('n', '<leader>mr', ':MRU<CR>',  { silent = true, desc = 'MRU' })
-- map('n', '<leader>x', '<C-w>c',     { silent = true, desc = 'Close window' })
map('n', '<leader>ed', ':Oil<CR>',   { silent = true, desc = 'Oil file explorer' })
map("n", "<leader>ec", ":edit $MYVIMRC<CR>:only<CR>", { silent = true, desc = "Open config as only window" })   
map('n', '<leader>ew', ':new<CR>:only<CR>', { silent = true; desc = 'open new file as only window'})
map('n', '<leader>l',  ':ls<CR>', {silent = true, desc = 'list buffers'})
map('n', '<leader>thd',  ':TSDisable highlight<cr>', { silent = true, desc = "Disable Treesitter syntax highlighting"})
map('n', '<leader>the',  ':TSEnsable highlight<cr>', { silent = true, desc = "Eisable Treesitter syntax highlighting"})
-- map('n', '<leader>w',  '<c-w>j', { silent = true, desc = "Next window"})


-- System clipboard
map({'n','v','x'}, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
map({'n','v','x'}, '<leader>d', '"+d', { desc = 'Delete to system clipboard' })
map('n', '<leader>p', '"+p',           { desc = 'Paste from system clipboard' })

-- Navigation niceties
map({'n','v','x'}, '<C-d>', '<C-d>zz', { desc = 'Half-page down centered' })
map({'n','v','x'}, '<C-u>', '<C-u>zz', { desc = 'Half-page up centered' })

-- Don’t use U as redo
-- map('n', 'U', function() print("Do not use 'U'") end, { silent = true })


-- Plugins via pack (Neovim 0.12+)
vim.pack.add({
    { src = "https://github.com/vague2k/vague.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/nvim-mini/mini.bufremove" },
    { src = "https://github.com/yegappan/mru" },
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" }, -- optional, icons
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
    { src = "https://github.com/nvim-lua/plenary.nvim" } ,
    { src = "https://github.com/MunifTanjim/nui.nvim" } ,
    { src = "https://github.com/nvim-neo-tree/neo-tree.nvim" } ,
})

-- Pick (mini.pick)
map({'n','v','x'}, '<leader>f', ':Pick files<CR>', { silent = true, desc = 'Pick files' })
map({'n','v','x'}, '<leader>h', ':Pick help<CR>',  { silent = true, desc = 'Pick help' })
map({'n','v','x'}, '<leader>b', ':Pick buffers<CR>', { silent = true, desc = 'Pick buffer'})

vim.keymap.set('n', '<leader>x', function()
   require('mini.bufremove').delete(0, false)
   end, { desc = 'Delete buffer' })

   --
-- map('n', '<leader>n', function() cycle_buffers(1, true) end, { silent = true })
map('n', '<leader>n', ':bn<CR>', { silent = true, desc='Next buffer' })

require("plugins.treesitter");

-- optional: start with all folds open
-- vim.opt.foldlevel = 99

-- Oil / mini.pick / which-key
require('oil').setup({ default_file_explorer = false, })
require('mini.pick').setup()
require('which-key').setup({
    delay = 300,
    show_help = true,
})
require('mini.bufremove').setup()


-- UI
vim.cmd("colorscheme vague")
vim.cmd("hi statusline guibg=none")

-- Yank highlight
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
    desc = 'Highlight selection on yank',
    callback = function()
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 500 })
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function()
        vim.cmd("wincmd o")
        vim.cmd("resize")    -- resize full height
        vim.opt_local.buflisted = true
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "new",
    callback = function()
        vim.cmd("wincmd o")  -- closes other windows
        vim.cmd("resize")    -- resize full height
        vim.opt_local.buflisted = true
    end,
})
