-- ===========================================================================
-- Levy's Neovim Which key 
-- ===========================================================================
return{
    -- Show keybinds 
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "helix",
            win = {
                row = 0,
                title = true,
                title_pos = "center",
                border = "rounded",
                padding = { 0, 0 },
                wo = { winblend = 0 },
            },
            layout = {
                spacing = 3,
                width = { min = 15, max = 25 },
            },
            icons = {
                group = "+",         -- prefix for groups
                separator = "➜",     -- between key and description
                breadcrumb = "»",    -- shown in the cmdline as you type a combo
                mappings = true,     -- auto icons for known plugin keymaps
            },
            show_help = false,       -- little help line at the bottom of the popup
            show_keys = true,        -- shows the key combo you're typing in the cmdline
        },
        keys = {
            {
                "<A-k>",
                function() require("which-key").show({ global = true }) end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
}
