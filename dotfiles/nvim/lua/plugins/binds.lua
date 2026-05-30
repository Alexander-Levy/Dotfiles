-- ===========================================================================
-- Levy's Neovim keybinds for plugins 
-- ===========================================================================
return{
    -- File Explorer { Neotree }
    vim.keymap.set("n", "<A-e>", ":Neotree toggle filesystem reveal left<CR>", {}),  -- Alt + e: Open file explorer on left 
    -- vim.keymap.set("n", "<C-g>", ":Neotree toggle git_status reveal left<CR>", {}),  -- Ctrl + g: Show git status & preview diff

    -- Live preview
    vim.keymap.set("n", "<A-m>", ":Markview Toggle<CR>"), -- Alt + m: Toggle markview

    -- Telescope
    vim.keymap.set("n", "<A-v>", require("telescope.builtin").oldfiles, {}),     -- Alt + v: Browse recent files
    vim.keymap.set("n", "<A-g>", require("telescope.builtin").live_grep, {}),    -- Alt + g: Browse files by content
    vim.keymap.set("n", "<A-f>", require("telescope.builtin").find_files, {}),   -- Alt + f: Browse files by name
    vim.keymap.set("n", "<C-g>", require("telescope.builtin").git_status),       -- Ctrl + g: Show git status & preview diff
    vim.keymap.set("n", "<C-c>", require("telescope.builtin").colorscheme, {}),  -- Shift + c: change colorscheme

    -- Language Server
    vim.keymap.set("n", "K", vim.lsp.buf.hover),         -- K: Show documentation
    vim.keymap.set("n", "rn", vim.lsp.buf.rename),       -- r + n: Rename buffer
    vim.keymap.set("n", "gd", vim.lsp.buf.definition),   -- g + d: Go to definition
    vim.keymap.set("n", "gr", vim.lsp.buf.references),   -- g + r: Find references
    vim.keymap.set("n", "gca", vim.lsp.buf.code_action), -- c + a: Code actions (How did i live without this?) 
}
