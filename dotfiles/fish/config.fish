######################################################################
# Levy's Fish Shell
######################################################################
# Remove the default fish greeting
set fish_greeting

# Make fastfetch run when you open a terminal.
if status is-interactive
    fastfetch
end

# Replace ls with eza 
alias ls "eza --icons --group-directories-first --color=auto"
alias la "eza -la --icons --group-directories-first --color=auto"
alias lt "eza --tree --icons --color=auto"

# Use bat instead of cat
alias cat "bat --color always"

# Replace nano with nvim
function nano
    nvim $argv
end

# Fuzzy find file with preview & open with nvim
function fzvi
    nvim $(fzf --preview='bat --color always {}')
end

