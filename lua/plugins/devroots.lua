
-- devroots: upward file-based multi-root search for fzf-lua
-- Requirements: fzf-lua, fd, ripgrep; Neovim 0.9+ (vim.fs)

local M = {}

M.config = {
    filename = ".dev.roots",
    excludes = { ".git", "build", "out", ".cache" },  -- tweak
}

local function shell_quote(s)
    if s:match("[^%w%+%-%._/=:]") then
        return "'" .. s:gsub("'", [['"'"']]) .. "'"
    end
    return s
end

local function find_roots_file()
    local start = vim.api.nvim_buf_get_name(0)
    if start == "" then start = vim.loop.cwd() end
    local res = vim.fs.find(M.config.filename, { upward = true, path = start })
    return res[1]
end

local function read_roots()
    local file = find_roots_file()
    if not file then
        vim.notify("devroots: no " .. M.config.filename .. " found upward", vim.log.levels.WARN)
        return {}
    end
    local base = vim.fs.dirname(file)
    local lines = vim.fn.readfile(file)
    local roots = {}
    local seen = {}
    for _, ln in ipairs(lines) do
        ln = (ln:gsub("^%s+", ""):gsub("%s+$", ""))
        if ln ~= "" and not ln:match("^#") then
            -- expand ~ and env
            ln = vim.fn.expand(ln)
            -- resolve relative to the roots file
            if not ln:match("^/") then
                ln = vim.fs.normalize(vim.fs.joinpath(base, ln))
            end
            if not seen[ln] then
                table.insert(roots, ln)
                seen[ln] = true
            end
        end
    end
    return roots
end

local function fd_cmd(roots, extra_args)
    local parts = { "fd", "-t", "f", "-H", "-L" }
    for _, ex in ipairs(M.config.excludes) do
        table.insert(parts, "-E"); table.insert(parts, ex)
        table.insert(parts, "-E"); table.insert(parts, "**/" .. ex .. "/**")
    end
    if extra_args and extra_args ~= "" then
        table.insert(parts, extra_args)
    end
    for _, r in ipairs(roots) do
        table.insert(parts, shell_quote(r))
    end
    return table.concat(parts, " ")
end

local function rg_cmd(roots, extra_args)
    local parts = { "rg", "--vimgrep", "-S", "--hidden", "--follow" }
    for _, ex in ipairs(M.config.excludes) do
        table.insert(parts, "--glob"); table.insert(parts, "!" .. ex)
        table.insert(parts, "--glob"); table.insert(parts, "!**/" .. ex .. "/**")
    end
    if extra_args and extra_args ~= "" then
        table.insert(parts, extra_args)
    end
    for _, r in ipairs(roots) do
        table.insert(parts, shell_quote(r))
    end
    return table.concat(parts, " ")
end

-- :DevFiles [fd-extra-args]
vim.api.nvim_create_user_command("DevFiles", function(opts)
    local roots = read_roots()
    if #roots == 0 then return end
    require("fzf-lua").files({ cmd = fd_cmd(roots, opts.args) })
end, { nargs = "*", desc = "fzf-lua files over .dev.roots dirs" })

-- :DevGrep {ripgrep-pattern-and-args}
vim.api.nvim_create_user_command("DevGrep", function(opts)
    local roots = read_roots()
    if #roots == 0 then return end
    require("fzf-lua").grep({ cmd = rg_cmd(roots, opts.args) })
end, { nargs = "*", desc = "fzf-lua grep over .dev.roots dirs" })

return M
