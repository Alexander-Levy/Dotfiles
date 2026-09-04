-- ===========================================================================
-- Levy's Neovim Indent lines
-- ===========================================================================
return{
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
