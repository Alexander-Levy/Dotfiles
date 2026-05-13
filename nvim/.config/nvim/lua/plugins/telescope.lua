-- Telescope Setup
require('telescope').setup{
  defaults = {
    -- Layout: puts the preview on the right in a wider split
    layout_strategy = 'horizontal',
    layout_config = {
        horizontal = {
            preview_width = 0.6,   -- Preview takes 55% of the total width
            results_width = 0.25,
            width  = 0.95,
            height = 0.90,
            -- preview_cutoff = 100,   -- Only show preview if terminal is wider than 100 cols
        },
    },

    preview = {
      treesitter = true,        -- Syntax highlights in preview (requires treesitter parsers installed)
      filesize_limit = 2,       -- Don't preview files larger than 1MB
      timeout = 250,            -- Timeout in ms for previewing a file
    },

    winblend = 10,                  -- Makes the telescope semi-transparent (0 = solid, 20 = fairly transparent)
    prompt_position = "top",        -- Moves the search bar to the top to match ascending sort
    sorting_strategy = "ascending", -- Shows results top-to-bottom instead of bottom-to-top
  },

  pickers = {
    find_files = { hidden = true },
    live_grep  = { additional_args = function(opts)
                    return {"--hidden"}
                  end },
  },
  extensions = { ["ui-select"] = { require("telescope.themes").get_dropdown {} } },
}
require("telescope").load_extension("ui-select")

-- -- Keybinds
-- vim.keymap.set("n", "<A-v>", require("telescope.builtin").oldfiles, {})     -- Alt + v: Browse recent files
-- vim.keymap.set("n", "<A-g>", require("telescope.builtin").live_grep, {})    -- Alt + g: Browse files by content
-- vim.keymap.set("n", "<A-f>", require("telescope.builtin").find_files, {})   -- Alt + f: Browse files by name
--
