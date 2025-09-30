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

-- Leader first
vim.g.mapleader = " "

-- Keymaps
local map = vim.keymap.set

local function toggle_relativenumber()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
end
local function cycle_buffers(dir, include_unlisted)
    local cur = vim.api.nvim_get_current_buf()
    local bufs = include_unlisted and vim.fn.getbufinfo()
                                or  vim.fn.getbufinfo({ buflisted = 1 })
    if #bufs <= 1 then return end

    table.sort(bufs, function(a, b) return a.bufnr < b.bufnr end)
    local ids = {}
    for _, b in ipairs(bufs) do
        table.insert(ids, b.bufnr)
    end

    local idx = 1
    for i, n in ipairs(ids) do
        if n == cur then idx = i; break end
    end

    local next_idx = ((idx - 1 + dir) % #ids) + 1
    vim.cmd('buffer ' .. ids[next_idx])  -- :buffer will load if needed
end

map('n', '<leader>rn', toggle_relativenumber, { desc = 'Toggle relative number' })

map('n', '<leader>w', ':write<CR>', { silent = true, desc = 'Write' })
map('n', '<leader>q', ':quit<CR>',  { silent = true, desc = 'Quit' })
map('n', '<leader>mr', ':MRU<CR>',  { silent = true, desc = 'MRU' })
map('n', '<leader>x', '<C-w>c',     { silent = true, desc = 'Close window' })
map('n', '<leader>ed', ':Oil<CR>',   { silent = true, desc = 'Oil file explorer' })
map("n", "<leader>ec", ":edit $MYVIMRC<CR>:only<CR>", { desc = "Open config as only window" })   
map('n', '<leader>ew', ':new<CR>:only<CR>', { desc = 'open new file as only window'})
map('n', '<leader>l',  ':ls<CR>', {desc = 'list buffers'})

-- System clipboard
map({'n','v','x'}, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
map({'n','v','x'}, '<leader>d', '"+d', { desc = 'Delete to system clipboard' })
map('n', '<leader>p', '"+p',           { desc = 'Paste from system clipboard' })

-- Navigation niceties
map({'n','v','x'}, '<C-d>', '<C-d>zz', { desc = 'Half-page down centered' })
map({'n','v','x'}, '<C-u>', '<C-u>zz', { desc = 'Half-page up centered' })

-- Don’t use U as redo
map('n', 'U', function() print("Do not use 'U'") end, { silent = true })

-- Pick (mini.pick)
map({'n','v','x'}, '<leader>f', ':Pick files<CR>', { silent = true, desc = 'Pick files' })
map({'n','v','x'}, '<leader>h', ':Pick help<CR>',  { silent = true, desc = 'Pick help' })
map({'n','v','x'}, '<leader>b', ':Pick buffers<CR>', { silent = true, desc = 'Pick buffer'})

-- map('n', '<leader>n', function() cycle_buffers(1, true) end, { silent = true })
map('n', '<leader>n', ':bn<CR>', { silent = true, desc='Next buffer' })

-- Plugins via pack (Neovim 0.12+)
vim.pack.add({
    { src = "https://github.com/vague2k/vague.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/yegappan/mru" },
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" }, -- optional, icons
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
})

-- Treesitter
require('nvim-treesitter.configs').setup({
    ensure_installed = {
        "c", "lua", "vim", "vimdoc", "query",
        "markdown", "markdown_inline",
    },
    sync_install = false,
    auto_install = true,
    ignore_install = { "javascript" }, -- keep if intentional
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            return ok and stats and stats.size > max_filesize
        end,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
    indent = { enable = true },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
            },
        },
    },
})

-- optional: start with all folds open
vim.opt.foldlevel = 99

-- Oil / mini.pick / which-key
require('oil').setup()
require('mini.pick').setup()
require('which-key').setup({
    delay = 300,
    show_help = true,
})

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
        vim.cmd("wincmd o")  -- closes other windows
        vim.cmd("resize")    -- optional: resize full height
        vim.opt_local.buflisted = true
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "new",
    callback = function()
        vim.cmd("wincmd o")  -- closes other windows
        vim.cmd("resize")    -- optional: resize full height
        vim.opt_local.buflisted = true
    end,
})
