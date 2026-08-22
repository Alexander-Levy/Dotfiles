######################################################################
# Levy's Fish Shell
######################################################################
# Remove the default fish greeting
set fish_greeting

# Run fetch when you open a terminal.
if status is-interactive
    fetch
end

# Replace ls with eza 
alias ls "eza --icons --group-directories-first --color=auto"
alias la "eza -la --icons --group-directories-first --color=auto"
alias lt "eza --tree --icons --color=auto"

# Use bat instead of cat
alias cat "bat --color always"

# Fuzzy find file with preview & open with nvim
function fzvi
    nvim $(fzf --preview='bat --color always {}')
end

# Check system services currently running
alias ls-services "systemctl list-units --type=service --state=running"
