# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Profiling startup? zprof is your friend. Add `zmodload zsh/zprof` as the very
# first line here, then run `zprof` at the very end (or `zsh -i -c zprof`) to get
# a per-function time breakdown sorted by cost. Killer for finding slow plugins.

# Fast-path: when VS Code is resolving the shell environment (or any other
# non-interactive consumer that just needs env vars), skip oh-my-zsh, nvm,
# completions, etc. All required PATH/env exports live in ~/.zshenv.
# Saves ~1.5s on every VS Code shell env resolution.
if [[ -n "$VSCODE_RESOLVING_ENVIRONMENT" || -n "$COPILOT_RESOLVING_ENVIRONMENT" ]]; then
  return 0
fi

# Keep PATH free of duplicate entries (auto-dedupes on every prepend).
typeset -U path PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# Lazy-load nvm: defer sourcing nvm.sh until `nvm`, `node`, `npm`, `npx`, etc.
# are first called. Cuts ~1.1s off interactive startup.
zstyle ':omz:plugins:nvm' lazy yes
zstyle ':omz:plugins:nvm' lazy-cmd node npm npx yarn pnpm corepack

# Cheap plugins (aliases/functions only, ~no startup cost): git gh node npm
# python rsync vscode web-search colorize colored-man-pages brew macos golang
# Costed plugins (load completions, measurable): docker rust deno
# nvm is lazy-loaded via the zstyle above. zsh-autosuggestions then
# zsh-syntax-highlighting MUST stay last (highlighting binds the buffer).
plugins=(
    git
    gh
    node
    npm
    nvm
    deno
    docker
    golang
    rust
    python
    rsync
    macos
    vscode
    web-search
    colorize
    colored-man-pages
    brew
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Skip compaudit insecure-directory scan for faster startup
ZSH_DISABLE_COMPFIX=true

# Daily-cached compinit. OMZ hardcodes a full `compinit` every startup (~900ms on
# a rebuild). `autoload` won't override an existing function, so we shadow compinit
# *before* sourcing OMZ: OMZ's `autoload -U compinit` no-ops and its compinit call
# lands here, at the right spot (after plugin fpath is built). Full rebuild at most
# once a day; otherwise trust the cache with `-C`. Profiling? See the zprof note up top.
compinit() {
  unfunction compinit
  autoload -Uz compinit
  # local_options so we don't leak extended_glob; it's required for the (#q..) mtime glob.
  setopt local_options extended_glob
  if [[ -n "$ZSH_COMPDUMP"(#qN.mh+24) ]] || [[ ! -s "$ZSH_COMPDUMP" ]]; then
    compinit -d "$ZSH_COMPDUMP"
  else
    compinit -C -d "$ZSH_COMPDUMP"
  fi
}

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# NVM is loaded lazily by the oh-my-zsh `nvm` plugin (see zstyle above).
# NVM_DIR is exported in ~/.zshenv. Do not manually source nvm.sh here —
# it would force eager load and add ~1s to startup.

export DENO_INSTALL="/Users/austenstone/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

alias web="gh repo view --web"

# Load Angular CLI autocompletion.
if [[ $- == *i* ]] && [[ -z "$VSCODE_RESOLVING_ENVIRONMENT" ]] && command -v ng &>/dev/null; then
  source <(ng completion script)
fi

# gh completion: cache output to avoid forking `gh` every shell start.
# Regenerate when gh binary is newer than the cache.
_gh_completion_cache="$HOME/.cache/gh_completion.zsh"
if [[ -x "$(command -v gh)" ]]; then
  if [[ ! -f "$_gh_completion_cache" || "$(command -v gh)" -nt "$_gh_completion_cache" ]]; then
    mkdir -p "$(dirname "$_gh_completion_cache")"
    gh completion -s zsh > "$_gh_completion_cache" 2>/dev/null
  fi
  source "$_gh_completion_cache"
fi
unset _gh_completion_cache

# export GITHUB_TOKEN=$(gh auth token)

export GPG_TTY=$(tty)

# Ruby configuration
export LDFLAGS="${LDFLAGS:+$LDFLAGS }-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="${CPPFLAGS:+$CPPFLAGS }-I/opt/homebrew/opt/ruby/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# bun completions
[ -s "/Users/austenstone/.bun/_bun" ] && source "/Users/austenstone/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.nvm/versions/node/v24.14.0/bin:$PATH"
export PATH="$HOME/Library/Python/3.9/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/austenstone/source/austenstone-notes/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/austenstone/source/austenstone-notes/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/austenstone/source/austenstone-notes/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/austenstone/source/austenstone-notes/google-cloud-sdk/completion.zsh.inc'; fi

# API keys (BRAVE_API_KEY, GOOGLE_CSE_KEY, GOOGLE_CSE_CX) live in ~/.zshenv.local — sourced by ~/.zshenv.

# AsyncAPI CLI Autocomplete

ASYNCAPI_AC_ZSH_SETUP_PATH=/Users/austenstone/Library/Caches/@asyncapi/cli/autocomplete/zsh_setup && test -f $ASYNCAPI_AC_ZSH_SETUP_PATH && source $ASYNCAPI_AC_ZSH_SETUP_PATH; # asyncapi autocomplete setup

alias c="copilot"
# Use VS Code as the default CLI editor
export VISUAL="code-insiders -w"
export EDITOR="code-insiders -w"

# Always use VS Code Insiders
alias code="code-insiders"


# Added by Antigravity CLI installer
export PATH="/Users/austenstone/.local/bin:$PATH"

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
