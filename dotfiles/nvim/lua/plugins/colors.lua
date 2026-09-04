-- ===========================================================================
-- Levy's Neovim User Interface
-- ===========================================================================
return{
    -- Colorscheme
    { "folke/tokyonight.nvim" },
    { "bluz71/vim-moonfly-colors" },
    {
        "eldritch-theme/eldritch.nvim",
        config = function()
            vim.cmd([[colorscheme eldritch-dark]])
        end,
    },

    -- Status Line
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
    },

    -- Color highlighting {hex, rgb, hsl, css} 
    { "brenoprata10/nvim-highlight-colors", opts = {} },
}
