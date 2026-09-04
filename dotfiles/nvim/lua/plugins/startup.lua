-- ===========================================================================
-- Levy's Neovim Startup 
-- ===========================================================================
return{
    -- Dashboard
    {
        "nvimdev/dashboard-nvim",
        event = 'VimEnter',
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            -- Optional: Animated splash
            { "amansingh-afk/milli.nvim", lazy = false },
        },

        config = function()
            local splash = "cactus"
            local splash_path = vim.fn.stdpath("data") .. "/milli/splashes/" .. splash .. ".lua"

            -- Automatically install the splash if it isn't present
            if vim.fn.filereadable(splash_path) == 0 then
                vim.notify("Installing Milli splash: " .. splash, vim.log.levels.INFO)
                vim.cmd("MilliInstall " .. splash)
            end

            -- Pre-load dashboard elements
            local splash_data = require("milli").load({
                splash = splash,
            })
            vim.api.nvim_set_hl(0, "DashboardProjectTitle", {
                fg = "#a48cf2",
                bold = true,
            })
            vim.api.nvim_set_hl(0, "DashboardProjectIcon", {
                fg = "#37f499",
            })
            vim.api.nvim_set_hl(0, "DashboardMruTitle", {
                fg = "#f16c75",
                bold = true,
            })
            vim.api.nvim_set_hl(0, "DashboardFiles", {
                fg = "#0c7a94",
            })

            require("dashboard").setup({
                theme = 'hyper',
                config = {
                    header = splash_data.frames[1],
                    footer   = {},
                    packages = { enable = false },
                    mru      = { enable = true, limit = 4 },
                    project  = { enable = true, limit = 2 },
                    shortcut = {
                        {
                            desc = '󰊳 Update',
                            group = '@property',
                            action = 'Lazy update',
                            key = 'u'
                        },
                        {
                            icon = ' ',
                            icon_hl = '@variable',
                            desc = 'Files',
                            group = 'Label',
                            action = 'Telescope find_files',
                            key = 'f',
                        },
                        {
                            desc = ' Quit',
                            group = 'Number',
                            action = 'qa',
                            key = 'q',
                        },
                    },
                },
            })
            require("milli").dashboard({ splash = splash, loop = true })
        end,
    },
}
