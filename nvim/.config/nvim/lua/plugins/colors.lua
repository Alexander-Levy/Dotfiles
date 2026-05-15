-- ===========================================================================
-- Levy's Neovim User Interface
-- ===========================================================================
return{
    -- Colorscheme
    { "Mofiqul/vscode.nvim" },
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

    -- Treesitter / Syntax Highlighting
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',

        config = function()
            require("nvim-treesitter").setup{
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
        end,
    },

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
        config = function()
            filesystem = {
                filtered_items = {
                    visible         = true,
                    hide_dotfiles   = false,
                    hide_gitignored = false,
                    hide_hidden     = false,
                },
            }

            -- Keybinds
            vim.keymap.set("n", "<A-e>", ":Neotree toggle filesystem reveal left<CR>", {})  -- Alt + e: Open file explorer on left 
            vim.keymap.set("n", "<C-g>", ":Neotree toggle git_status reveal left<CR>", {})  -- Ctrl + g: Show git status & preview diff
        end,
    },

    -- Live Preview {markdown, latex, html, etc}
    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        config = function()
            preview = { enable = false }

            -- Keybinds 
            vim.keymap.set("n", "<A-m>", ":Markview Toggle<CR>") -- Alt + m: Toggle markview
        end,
    },
}

