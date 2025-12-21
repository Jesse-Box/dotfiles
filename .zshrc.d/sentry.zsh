# Sentry Development Environment

eval "$(direnv hook zsh)"

export VOLTA_HOME="$HOME/.volta"
if ! grep --silent "$VOLTA_HOME/bin" <<< "$PATH"; then
  export PATH="$VOLTA_HOME/bin:$PATH"
fi

export PATH="$HOME/.local/share/sentry-devenv/bin:$PATH"
