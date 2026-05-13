-- ===========================================================================
-- Levy's Neovim Language Server 
-- ===========================================================================
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

-- Mason Setup
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "pylsp", "clangd", "jsonls", "vimls" }
})

-- LSP Setup
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },         -- Neovim uses LuaJIT
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true), -- Loads all nvim runtime files
      },
      diagnostics = {
        globals = { 'vim' },  -- Stops "undefined global vim" warnings
      },
      telemetry = { enable = false },
    },
  },
})
vim.lsp.enable('lua_ls', 'pylsp', 'vimls', 'jsonls', 'clangd')

