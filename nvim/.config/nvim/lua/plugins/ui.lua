-- ===========================================================================
-- Levy's Neovim User Interface
-- ===========================================================================
-- Colorscheme
vim.cmd("colorscheme tokyonight-night")

-- Status line
require("lualine").setup()

-- Treesitter / Syntax Highligthing
require('nvim-treesitter').setup {
  install_dir = vim.fn.stdpath('data') .. '/site'
}
require('nvim-treesitter').install {
    'bash',
    'c', 'cpp',
    'css',
    'fish',
    'lua',
    'python',
    'hyprlang',
    'markdown', 'markdown_inline',
    'html',
    'latex',
    'typst',
    'yaml',
}

-- File Explorer 
require("neo-tree").setup({
  filesystem = {
    filtered_items = {
      visible         = true,   -- show hidden files, but dimmed
      hide_dotfiles   = false,  -- don't hide dotfiles (files starting with .)
      hide_gitignored = false, -- don't hide files in .gitignore
      hide_hidden     = false,  -- don't hide files with the hidden attribute (Windows)
    },
  },
})

-- Markview
require("markview").setup({
    preview = { enable = false }
});

