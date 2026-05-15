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
  spec = { import = "plugins" },
  checker = { enabled = false },
  install = { colorscheme = { "eldritch-dark" } },
})

