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

  -- Treesitter / Syntax
  { 'nvim-treesitter/nvim-treesitter', lazy = false, build = ':TSUpdate' },

  -- Autocomplete
  { "hrsh7th/nvim-cmp" },
  -- Sources:
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-nvim-lsp" },

  -- LSP
  { "neovim/nvim-lspconfig" },
  -- Mason (Auto install LSPs)
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
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

-- Telescope Setup
require('telescope').setup{
  defaults = {},
  pickers = {
    find_files = { hidden = true },
    live_grep  = { additional_args = function(opts)
                    return {"--hidden"}
                  end },
  }
}

-- Autocomplete Setup
local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "path" },
    { name = "buffer" },
    { name = "nvim_lsp" },
  })
})

-- Treesitter Setup
require('nvim-treesitter').setup {
  install_dir = vim.fn.stdpath('data') .. '/site'
}
-- Parsers to install 
require('nvim-treesitter').install { 'bash', 'c', 'cpp', 'css', 'fish', 'lua', 'python', 'hyprlang' }
-- Syntax Highligthing (enabled per filetype)
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { '<filetype>.lua' },
--   callback = function() vim.treesitter.start() end,
-- })

-- Mason Setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "pylsp", "clangd", "jsonls", "vimls" }
})

-- LSP Setup
vim.lsp.enable('lua_ls', 'pylsp', 'clangd', 'jsonls', 'vimls')

-- ===========================================================================
-- Keybinds
-- ===========================================================================
-- File actions
vim.keymap.set("n", "<A-w>", ":w<CR>") -- Alt + S: Save file 
vim.keymap.set("n", "<A-q>", ":q<CR>") -- Alt + Q: Quit vim 

-- Line actions
vim.keymap.set("n", "<A-Up>",   ":m .-2<CR>==")     -- Alt + Up:   Move line up
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==")     -- Alt + Down: Move line down
vim.keymap.set("v", "<A-Up>",   ":m '<-2<CR>gv=gv") -- Alt + Up:   Move line up
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv") -- Alt + Down: Move line down

-- Explore files
vim.keymap.set("n", "<A-e>", ":NvimTreeToggle<CR>") -- Alt + e: Open File Manager 
vim.keymap.set("n", "<A-v>", require("telescope.builtin").oldfiles, {}) -- Browse recent files
vim.keymap.set("n", "<A-g>", require("telescope.builtin").live_grep, {}) -- Alt + g: Browse files by content
vim.keymap.set("n", "<A-f>", require("telescope.builtin").find_files, {}) -- Alt + f: Browse files by name

-- Git 
vim.keymap.set("n", "<C-g>", require("telescope.builtin").git_status, {}) -- Shift + c: change colorscheme

-- Neovim 
vim.keymap.set("n", "<S-c>", require("telescope.builtin").colorscheme, {}) -- Shift + c: change colorscheme

