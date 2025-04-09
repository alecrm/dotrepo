vim.opt.splitright = true  -- vertical splits go right
vim.opt.splitbelow = true  -- horizontal splits go below
vim.opt.expandtab = true        -- Use spaces instead of tabs
vim.opt.tabstop = 2             -- Number of spaces per tab
vim.opt.shiftwidth = 2          -- Spaces to use for autoindent
vim.opt.softtabstop = 2         -- Spaces per tab while editing
vim.opt.autoindent = true       -- Keep indentation consistent on new lines
vim.opt.smartindent = true      -- Automatically handle indentation for code
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ttyfast = true
vim.opt.lazyredraw = false
vim.opt.termguicolors = true

require("config.lazy")
require("config.keymaps")

