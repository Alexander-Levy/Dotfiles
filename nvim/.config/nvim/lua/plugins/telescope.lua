-- ===========================================================================
-- Levy's Neovim Telescope
-- ===========================================================================
return{
    -- Telescope / UI Selector 
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },

        config = function()
            require('telescope').setup{
                defaults = {
                    layout_strategy = 'horizontal',
                    layout_config = {
                        horizontal = {
                            preview_width = 0.6,
                            results_width = 0.25,
                            width  = 0.95,
                            height = 0.90,
                            -- preview_cutoff = 100,   -- Only show preview if terminal is wider than 100 cols
                        },
                    },
                    preview = {
                        timeout = 250,      -- Timeout in ms for previewing a file
                        treesitter = true,  -- Syntax highlights in preview 
                        filesize_limit = 2, -- Don't preview files larger
                    },
                    winblend = 10,                  -- Makes the telescope semi-transparent (0 = solid, 20 = fairly transparent)
                    prompt_position = "top",        -- Moves the search bar to the top to match ascending sort
                    sorting_strategy = "ascending", -- Shows results top-to-bottom instead of bottom-to-top
                },
                pickers = {
                    find_files = { hidden = true },
                    live_grep  = { additional_args = function(opts)
                        return {"--hidden"}
                    end },
                },
                extensions = {
                    ["ui-select"] = { require("telescope.themes").get_dropdown {} }
                },
            }
            require("telescope").load_extension("ui-select")
        end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
}

