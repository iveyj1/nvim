local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.enable_scroll_bar = true

-- Load the built-in rose-pine scheme
local rose_pine = wezterm.color.get_builtin_schemes()['rose-pine-moon']

-- Modify a specific color (e.g., background)
rose_pine.background = '#101010'

-- Apply the modified colors
config.colors = rose_pine

return config   
