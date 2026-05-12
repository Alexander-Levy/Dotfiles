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
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
  },

  -- Status line
  { "nvim-lualine/lualine.nvim" },

  -- Telescope / UI Selector 
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { 'nvim-telescope/telescope-ui-select.nvim' },

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
  { "mason-org/mason.nvim", opts = {} },
  { "mason-org/mason-lspconfig.nvim", opts = {},
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "mason-org/mason.nvim", opts = {} },
    },
  }
})

-- ===========================================================================
-- Plugins Config
-- ===========================================================================
-- Colorsheme
vim.cmd("colorscheme tokyonight-night")

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
  },
  extensions = { ["ui-select"] = { require("telescope.themes").get_dropdown {} } },
}
require("telescope").load_extension("ui-select")

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
require('nvim-treesitter').install { 'bash', 'c', 'cpp', 'css', 'fish', 'lua', 'python', 'hyprlang' }

-- Mason Setup
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "pylsp", "clangd", "jsonls", "vimls" }
})

-- LSP Setup
vim.lsp.enable('lua_ls', 'pylsp', 'clangd', 'jsonls', 'vimls')

-- ===========================================================================
-- Keybinds
-- ===========================================================================
-- File actions
vim.keymap.set("n", "<A-w>", ":w<CR>")  -- Alt + s: Save file 
vim.keymap.set("n", "<A-q>", ":q<CR>")  -- Alt + q: Quit nvim 
vim.keymap.set("n", "<A-r>", ":so<CR>") -- Alt + r: Source file 

-- Line actions
vim.keymap.set("n", "<A-Up>",   ":m .-2<CR>==")     -- Alt + Up:   Move line up
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==")     -- Alt + Down: Move line down
vim.keymap.set("v", "<A-Up>",   ":m '<-2<CR>gv=gv") -- Alt + Up:   Move line up
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv") -- Alt + Down: Move line down

-- Explore files
vim.keymap.set("n", "<A-e>", ":Neotree toggle filesystem reveal left<CR>", {})  -- Alt + e: Open file explorer on left 
-- vim.keymap.set("n", "<C-g>", ":Neotree toggle git_status reveal left<CR>", {})  -- Ctrl + g: Show git status & preview diff

-- Telescope
vim.keymap.set("n", "<A-v>", require("telescope.builtin").oldfiles, {})     -- Alt + v: Browse recent files
vim.keymap.set("n", "<A-g>", require("telescope.builtin").live_grep, {})    -- Alt + g: Browse files by content
vim.keymap.set("n", "<A-f>", require("telescope.builtin").find_files, {})   -- Alt + f: Browse files by name

-- LSP 
vim.keymap.set("n", "K", vim.lsp.buf.hover)         -- K: Show documentation
vim.keymap.set("n", "gd", vim.lsp.buf.definition)   -- g + d: Go to definition
vim.keymap.set("n", "gr", vim.lsp.buf.references)   -- g + r: Find references
vim.keymap.set("n", "ca", vim.lsp.buf.code_action)  -- c + a: Code actions (How did i live without this?) 
-- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename) -- Rename

-- Git 
vim.keymap.set("n", "<C-g>", require("telescope.builtin").git_status) -- Ctrl + g: Show git status & preview diff

-- Neovim 
vim.keymap.set("n", "<S-c>", require("telescope.builtin").colorscheme, {}) -- Shift + c: change colorscheme

