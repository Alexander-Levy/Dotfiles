-- ===========================================================================
-- Levy's Neovim Language Server 
-- ===========================================================================
return{
    -- Autoclose
    { "m4xshen/autoclose.nvim", opts = {} },

    -- Color highlighting {hex, rgb, hsl, css} 
    { "brenoprata10/nvim-highlight-colors", opts = {} },

    -- Autocomplete
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            -- Sources:
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-nvim-lsp" },
        },

        config = function()
            local cmp = require("cmp")
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "path" },
                    { name = "buffer" },
                    { name = "nvim_lsp" },
                }),
                formatting = {
                    format = require("nvim-highlight-colors").format,
                }
            })
        end,
    },

    -- Mason (Auto install LSPs)
    { "mason-org/mason.nvim", opts = {} },
    {
        "mason-org/mason-lspconfig.nvim",

        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    -- Config 
                    "vimls",
                    -- "cssls",
                    "lua_ls",
                    "jsonls",
                    "hyprls",
                    "fish_lsp",
                    -- Dev
                    "bashls",
                    "pylsp",
                    "clangd",
                }
            })
        end,
    },

    -- Language Server 
    {
        "neovim/nvim-lspconfig",

        config = function()
            vim.lsp.config('lua_ls', {
                settings = {
                    Lua = {
                        runtime = { version = 'LuaJIT' },         -- Neovim uses LuaJIT
                        workspace = {
                            checkThirdParty = false,
                            library = vim.api.nvim_get_runtime_file("", true), -- Loads all nvim runtime files
                        },
                        diagnostics = {
                            globals = { 'vim' },  -- Stops "undefined global vim" warnings
                        },
                        telemetry = { enable = false },
                    },
                },
            })
            vim.lsp.enable('lua_ls', 'pylsp', 'vimls', 'jsonls', 'clangd')
        end,
    },
}

