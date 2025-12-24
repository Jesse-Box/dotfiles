# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Bindings
setopt autocd

# Aliases
alias zshrc="vi .zshrc"
alias ls="ls -lah"

# Loading .zshrc.d/ .zsh files
for file in "$HOME/.zshrc.d/"*.zsh; do
  [ -r "$file" ] && source "$file"
done
