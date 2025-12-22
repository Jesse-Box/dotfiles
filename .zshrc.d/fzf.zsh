source <(fzf --zsh)

# Options Global
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

# Options CTRL_T
export FZF_CTRL_T_OPTS="
  --preview 'bat --style=full --color=always {}'
"

# Options CTRL_R
export FZF_CTRL_R_OPTS="
  --preview 'echo {}'
  --preview-window=down:3:hidden
"

# Options ALT_C
export FZF_ALT_C_OPTS="
  --preview 'tree -C {} | head -200'
"

# Integration Ripgrep + FZF (live preview, opens in vim)
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
