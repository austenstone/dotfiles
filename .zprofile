# Add Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
# Add Deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$PATH:$DENO_INSTALL/bin"
# Add rust
export PATH="$PATH:$HOME/.cargo/bin"
# Set default editor to VSCode
export EDITOR="code -w"
