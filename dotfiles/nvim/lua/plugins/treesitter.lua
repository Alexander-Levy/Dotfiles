-- ===========================================================================
-- Levy's Neovim Treesitter
-- ===========================================================================
return{
    -- Treesitter / Syntax Highlighting
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',

        config = function()
            require("nvim-treesitter").setup{ install_dir = vim.fn.stdpath('data') .. '/site' }
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
        end,
    },
}
