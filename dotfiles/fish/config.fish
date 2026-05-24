# Fish configuration file.

######################################################################
# General settings
######################################################################
# Remove the default fish greeting
set fish_greeting

# Make fastfetch run when you open a terminal.
if status is-interactive
    fastfetch
end

######################################################################
# Aliases
######################################################################
# Replace ls with eza 
alias ls "eza --icons --group-directories-first --color=auto"
# Common ls variants 
alias la "eza -la --icons --group-directories-first --color=auto"
alias lt "eza --tree --icons --color=auto"

# Replace nano with nvim {most guides use nano for some reason}
function nano
    nvim $argv
end

# Fuzzy find file with preview & open with nvim
function fzvi
    nvim $(fzf --preview='bat --color always {}')
end

