-- ===========================================================================
-- Levy's Neovim Plugin Manager [ lazy.nvim ]
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
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      -- Optional:
      "folke/snacks.nvim", -- Image previews
      "nvim-tree/nvim-web-devicons", -- File icons
    },
  },

  -- Status line
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }},

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
  },
})

