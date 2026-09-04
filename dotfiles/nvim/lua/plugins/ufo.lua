-- ===========================================================================
-- Levy's Neovim Code Folding
-- ===========================================================================
return{
    -- Code Folding
    {
        'kevinhwang91/nvim-ufo',
        dependencies = 'kevinhwang91/promise-async',
        event = "BufReadPost",
        init = function()
            -- Fold options (must be set before ufo loads)
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            -- Global keymaps to open/close all folds
            vim.keymap.set("n", "zR", function() require("ufo").openAllFolds() end)
            vim.keymap.set("n", "zM", function() require("ufo").closeAllFolds() end)
        end,
        config = function()
            -- Tell ufo to use LSP as the fold provider
            require("ufo").setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return { "lsp", "indent" } -- Falls back to indent if LSP is unavailable
                end,
            })
        end,
    },
}
