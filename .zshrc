# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Adds Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# FZF Options (must be set before shell integration loads)
export FZF_DEFAULT_OPTS="
  --ansi
  --multi
  --layout=reverse
  --border
  --height=80%
  --preview-window=right:60%
  --bind=ctrl-/:toggle-preview
  --bind=alt-a:select-all
  --bind=alt-d:deselect-all
"
export FZF_CTRL_T_OPTS="--preview 'bat --style=full --color=always {}'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window=down:3:hidden"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# Adds fzf
zinit ice from"gh-r" as"program" \
  atclone"./fzf --zsh > fzf.zsh" \
  atpull"%atclone" \
  pick"fzf" \
  src"fzf.zsh"
zinit load junegunn/fzf

# Ripgrep + FZF integration (live preview, opens in vim)
rfv() (
  RELOAD='reload:rg --column --color=always --smart-case {q} || :'
  OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
            vim {1} +{2}
          else
            vim +cw -q {+f}
          fi'

  fzf --disabled \
      --bind "start:$RELOAD" \
      --bind "change:$RELOAD" \
      --bind "enter:become:$OPENER" \
      --bind "ctrl-o:execute:$OPENER" \
      --delimiter : \
      --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
      --preview-window '~4,+{2}+4/3,<80(up)' \
      --query "$*"
)

# Bind Ctrl-F to rfv
rfv-widget() { rfv; zle reset-prompt }
zle -N rfv-widget
bindkey '^F' rfv-widget

# Adds ripgrep
zinit ice as"program" from"gh-r" mv"ripgrep* -> rg" pick"rg/rg"
zinit light BurntSushi/ripgrep

# Adds bat
zinit ice as"program" from"gh-r" mv"bat* -> bat" pick"bat/bat"
zinit light sharkdp/bat

# Adds additional plugins
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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

# Options
setopt autocd

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias zshrc="vi .zshrc"
alias ls="ls -lah --color"

# direnv (used for Sentry Development Environment)
eval "$(direnv hook zsh)"