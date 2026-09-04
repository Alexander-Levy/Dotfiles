-- ===========================================================================
-- Levy's Neovim Markview
-- ===========================================================================
return{
    -- Live Preview {markdown, latex, html, etc}
    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        config = function()
            require("markview").setup({
                preview = { enable = false },
            })
        end,
    },
    -- Keybinds
    vim.keymap.set("n", "<A-m>", ":Markview Toggle<CR>"),
}
