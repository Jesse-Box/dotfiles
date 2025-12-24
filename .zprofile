export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="/Users/jessebox/.local/share/sentry-devenv/bin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv)"

# It is assumed that pyenv is installed via Brew, so this is all we need to do. 
eval "$(pyenv init --path)"
