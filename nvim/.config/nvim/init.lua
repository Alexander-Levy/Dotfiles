-- ===========================================================================
-- Neovim Settings
-- ===========================================================================
-- Line settings
vim.opt.wrap = false
vim.opt.number = true               -- Show line numbers
vim.opt.relativenumber = true       -- Relative line numbers
vim.opt.cursorline = true           -- Highligth current line 
vim.opt.scrolloff = 4               -- Keeps 4 at least lines below/above cursor

-- Indentation 
vim.opt.tabstop = 4                 -- Tabs = 4 spaces
vim.opt.shiftwidth = 4
vim.opt.expandtab = true            -- Use spaces instead of tabs
vim.opt.smartindent = true          -- Autoindent

-- Visual 
vim.opt.termguicolors = true        -- Enable 24-bit colors

-- Quality of Life
vim.opt.clipboard = "unnamedplus"   -- Use system clipboard

-- ===========================================================================
-- Plugin Manager (lazy.nvim)
-- ===========================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ===========================================================================
-- Plugin List
-- ===========================================================================
require("lazy").setup({
  -- Color schemes
  { "Mofiqul/vscode.nvim" },
  { "folke/tokyonight.nvim" },
  { "bluz71/vim-moonfly-colors" }, 

  -- File explorer
  { "nvim-tree/nvim-tree.lua" },
  
  -- Status line
  { "nvim-lualine/lualine.nvim" },

  -- Telescope
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Autocomplete
  { "hrsh7th/nvim-cmp" },
  -- Sources:
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
})

-- ===========================================================================
-- Plugins Config
-- ===========================================================================
-- Colorsheme
vim.cmd("colorscheme moonfly")

-- File explorer
require("nvim-tree").setup()

-- Status line
require("lualine").setup()

-- Telescope
local builtin = require("telescope.builtin")

-- Autocomplete Setup
local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  })
})

-- ===========================================================================
-- Keybinds
-- ===========================================================================
local keymap = vim.keymap

-- File actions
keymap.set("n", "<A-s>", ":w<CR>")   -- Alt + S: Save file 
keymap.set("n", "<A-q>", ":q<CR>")   -- Alt + Q: Quit vim 
keymap.set("n", "<A-w>", ":wq!<CR>") -- Alt + W: Save & Quit 

-- Line actions
keymap.set("n", "<A-Up>",   ":m .-2<CR>==")     -- Alt + Up:   Move line up
keymap.set("n", "<A-Down>", ":m .+1<CR>==")     -- Alt + Down: Move line down
keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv")   -- Alt + Up:   Move line up
keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv") -- Alt + Down: Move line down

-- Explore files
keymap.set("n", "<A-e>", ":NvimTreeToggle<CR>")  -- Alt + e: Open File Manager 
keymap.set("n", "<A-f>", builtin.find_files, {}) -- Alt + f: Browse files by name
keymap.set("n", "<A-g>", builtin.live_grep, {})  -- Alt + g: Browse files by content

