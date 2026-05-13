-- ===========================================================================
-- Neovim Settings
-- ===========================================================================
-- Line settings
vim.opt.wrap = false              -- Wrap line content if it does not fit current view
vim.opt.number = true             -- Show line numbers
vim.opt.relativenumber = true     -- Show line numbers in relation to current line
vim.opt.cursorline = true         -- Highligth current line 
vim.opt.scrolloff = 4             -- Keeps 4 at least lines below/above cursor

-- Indentation 
vim.opt.tabstop = 4               -- Tabs = 4 spaces
vim.opt.shiftwidth = 4
vim.opt.expandtab = true          -- Use spaces instead of tabs
vim.opt.smartindent = true        -- Autoindent

-- Quality of Life
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.termguicolors = true      -- Enable 24-bit colors

