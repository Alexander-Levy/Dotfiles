-- ===========================================================================
-- Levy's Neovim
-- ===========================================================================
require("general")   -- General neovim options
require("plugins")   -- Plugin Manager & List
require("keybinds")  -- Custom neovim binds {needs to be after plugins}

-- Plugins Config
require("plugins.ui")        -- Colorscheme, Powerline, Syntax Highligthing 
require("plugins.lsp")       -- Autocomplete, Mason & Language servers
require("plugins.startup")   -- Dashboard & Animated ASCII Art
require("plugins.telescope") -- Context based pop-up Menu used by many plugins

