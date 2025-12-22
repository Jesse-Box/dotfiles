# History
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Bindings
setopt autocd

# Aliases
alias zshrc="vi .zshrc"
alias ls="ls -lah"

# Loading .zshrc.d/ .zsh files
for file in "$HOME/.zshrc.d/"*.zsh; do
  [ -r "$file" ] && source "$file"
done

