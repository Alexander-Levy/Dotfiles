-- ===========================================================================
-- Levy's Neovim File tree 
-- ===========================================================================
return{
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
                window = { width = 28 },
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
    vim.keymap.set("n", "<A-e>", ":Neotree toggle filesystem reveal left<CR>", {}),
}
