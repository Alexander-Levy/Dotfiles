-- ===========================================================================
-- Levy's Neovim Keybinds
-- ===========================================================================
-- File actions
vim.keymap.set("n", "<A-w>", ":w<CR>")      -- Alt + s: Save file 
vim.keymap.set("n", "<A-q>", ":q<CR>")      -- Alt + q: Quit nvim 
vim.keymap.set("n", "<A-r>", ":so<CR>")     -- Alt + r: Source file 
vim.keymap.set("n", "<A-t>", ":tabnew<CR>") -- Alt + t: New tab 

-- Line actions
vim.keymap.set("n", "<A-Up>",   ":m .-2<CR>==")     -- Alt + Up:   Move line up
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==")     -- Alt + Down: Move line down
vim.keymap.set("v", "<A-Up>",   ":m '<-2<CR>gv=gv") -- Alt + Up:   Move line up
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv") -- Alt + Down: Move line down

