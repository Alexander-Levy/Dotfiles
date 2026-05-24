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
            require("neo-tree").setup({
                filesystem = {
                    filtered_items = {
                        visible         = true,
                        hide_dotfiles   = false,
                        hide_gitignored = false,
                        hide_hidden     = false,
                    },
                }
            })
        end,
    },

    -- Live Preview {markdown, latex, html, etc}
    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        config = function()
            require("markview").setup({
                preview = { enable = false },

                tables = {
                    enable = true,
                    strict = false,
                    block_decorator = true,
                    use_virt_lines = false,
                    parts = {
                        top = { "╭", "─", "╮", "┬" },
                        header = { "│", "│", "│" },
                        separator = { "├", "─", "┤", "┼" },
                        row = { "│", "│", "│" },
                        bottom = { "╰", "─", "╯", "┴" },
                        overlap = { "┝", "━", "┥", "┿" },
                        align_left = "╼",
                        align_right = "╾",
                        align_center = { "╴", "╶" }
                    },
                    hl = {
                        top = { "MarkviewTableHeader", "MarkviewTableHeader", "MarkviewTableHeader", "MarkviewTableHeader" },
                        header = { "MarkviewTableHeader", "MarkviewTableHeader", "MarkviewTableHeader" },
                        separator = { "MarkviewTableHeader", "MarkviewTableHeader", "MarkviewTableHeader", "MarkviewTableHeader" },
                        row = { "MarkviewTableBorder", "MarkviewTableBorder", "MarkviewTableBorder" },
                        bottom = { "MarkviewTableBorder", "MarkviewTableBorder", "MarkviewTableBorder", "MarkviewTableBorder" },
                        overlap = { "MarkviewTableBorder", "MarkviewTableBorder", "MarkviewTableBorder", "MarkviewTableBorder" },
                        align_left = "MarkviewTableAlignLeft",
                        align_right = "MarkviewTableAlignRight",
                        align_center = { "MarkviewTableAlignCenter", "MarkviewTableAlignCenter" }
                    }
                },
            })
        end,
    },

    -- Indent Lines
    {
        url = 'https://github.com/nvimdev/indentmini.nvim',
        cmd = { 'IndentToggle', 'IndentEnable', 'IndentDisable' },
        lazy = false,

        config = function()
            require("indentmini").setup({
                only_current = false,
                enabled = true,
                char = '▏',
                key = '<A-l>',
                minlevel = 2,
                exclude = { 'markdown', 'help', 'text', 'rst' },
                exclude_nodetype = { 'string', 'comment' }
            })
        end
    },
}

