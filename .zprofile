# It is assumed that pyenv is installed via Brew, so this is all we need to do.
eval "$(pyenv init --path)"

# I guess this is for Rust?
. "$HOME/.cargo/env"

# Sentry uses volta to install and manage the version of Node.js that they require.
export VOLTA_HOME="$HOME/.volta"
grep --silent "$VOLTA_HOME/bin" <<< $PATH || export PATH="$VOLTA_HOME/bin:$PATH"

# direnv automatically activates your virtual environment for Sentry.
eval "$(direnv hook zsh)"

#Flutter
export PATH="$PATH:$HOME/flutter/bin"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
