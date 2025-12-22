# Aliases
alias zshrc="vi .zshrc"
alias ls="ls -lah"

# Loading zsh directory
for file in "$HOME/.zshrc.d/"*.zsh; do
  [ -r "$file" ] && source "$file"
done

