-- ===========================================================================
-- Levy's Neovim Keybinds
-- ===========================================================================
-- File actions
vim.keymap.set("n", "<A-w>", ":w<CR>")  -- Alt + s: Save file 
vim.keymap.set("n", "<A-q>", ":q<CR>")  -- Alt + q: Quit nvim 
vim.keymap.set("n", "<A-r>", ":so<CR>") -- Alt + r: Source file 
vim.keymap.set("n", "<A-t>", ":tabnew<CR>") -- Alt + t: New tab 

-- Line actions
vim.keymap.set("n", "<A-Up>",   ":m .-2<CR>==")     -- Alt + Up:   Move line up
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==")     -- Alt + Down: Move line down
vim.keymap.set("v", "<A-Up>",   ":m '<-2<CR>gv=gv") -- Alt + Up:   Move line up
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv") -- Alt + Down: Move line down

-- Explore files
vim.keymap.set("n", "<A-e>", ":Neotree toggle filesystem reveal left<CR>", {})  -- Alt + e: Open file explorer on left 
vim.keymap.set("n", "<C-g>", ":Neotree toggle git_status reveal left<CR>", {})  -- Ctrl + g: Show git status & preview diff

-- Telescope 
vim.keymap.set("n", "<A-v>", require("telescope.builtin").oldfiles, {})     -- Alt + v: Browse recent files
vim.keymap.set("n", "<A-g>", require("telescope.builtin").live_grep, {})    -- Alt + g: Browse files by content
vim.keymap.set("n", "<A-f>", require("telescope.builtin").find_files, {})   -- Alt + f: Browse files by name
-- Git 
vim.keymap.set("n", "<C-g>", require("telescope.builtin").git_status) -- Ctrl + g: Show git status & preview diff
-- Neovim 
vim.keymap.set("n", "<S-c>", require("telescope.builtin").colorscheme, {}) -- Shift + c: change colorscheme

-- Language Servers (lsps)  
vim.keymap.set("n", "K", vim.lsp.buf.hover)         -- K: Show documentation
vim.keymap.set("n", "gd", vim.lsp.buf.definition)   -- g + d: Go to definition
vim.keymap.set("n", "gr", vim.lsp.buf.references)   -- g + r: Find references
vim.keymap.set("n", "ca", vim.lsp.buf.code_action)  -- c + a: Code actions (How did i live without this?) 
-- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename) -- Rename

