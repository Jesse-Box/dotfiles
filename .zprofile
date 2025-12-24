# Homebrew (must come first for brew-installed tools)
if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# pyenv (installed via Brew) 
eval "$(pyenv init --path)"

# Volta
export VOLTA_HOME="$HOME/.volta"
if ! grep --silent "$VOLTA_HOME/bin" <<< "$PATH"; then
  export PATH="$VOLTA_HOME/bin:$PATH"
fi

# Sentry devenv
export PATH="$HOME/.local/share/sentry-devenv/bin:$PATH"
export SENTRY_POST_MERGE_AUTO_UPDATE=1
