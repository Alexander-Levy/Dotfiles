-- ===========================================================================
-- Levy's Neovim Startup 
-- ===========================================================================
-- Liked splashes: 
--      blackhole, 
--      cactus,
--      chrome, 
--      dancerramp, 
--      finger, 
--      lighningtornado, 
--      lights, 
--      shader, 
--      skeleton, 
--      spaceship, 
--      vibecat, 
--      vibecattwo.
local animated_art = "cactus"

-- Dashboard setup
require("dashboard").setup({
    theme = 'hyper',
    config = {
        header   = require("milli").load({ splash = animated_art }).frames[1],
        footer   = {},
        packages = { enable = false },

        mru      = { enable = true, limit = 4 },
        project  = { enable = true, limit = 2 },

        shortcut = {
            {
                desc = '󰊳 Update',
                group = '@property',
                action = 'Lazy update',
                key = 'u'
            },
            {
                icon = ' ',
                icon_hl = '@variable',
                desc = 'Files',
                group = 'Label',
                action = 'Telescope find_files',
                key = 'f',
            },
            -- {
            --     desc = ' dotfiles',
            --     group = 'Number',
            --     action = 'Telescope dotfiles',
            --     key = 'd',
            -- },
            {
                desc = ' Quit',
                group = 'Number',
                action = 'qa',
                key = 'q',
            },
        },
    },
})
require("milli").dashboard({ splash = animated_art, loop = true })

