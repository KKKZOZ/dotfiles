### Environment Variables ###
set -gx PATH /opt/homebrew/bin \
    /opt/homebrew/opt/openjdk@11/bin \
    /usr/local/bin \
    $PATH \
    $HOME/Scripts \
    /Users/kkkzoz/.cache/lm-studio/bin \
    /usr/local/go/bin \
    $HOME/Environments/jdk-17/bin \
    $HOME/.local/bin \
    /opt/homebrew/opt/llvm@14/bin \
    /usr/local/texlive/2025/bin/universal-darwin \
    /Users/kkkzoz/go/bin

set -x FISH_CONFIG "$HOME/.config/fish/config.fish"
set -x EDITOR nvim

set -x RUSTUP_DIST_SERVER "https://rsproxy.cn"
set -x RUSTUP_UPDATE_ROOT "https://rsproxy.cn/rustup"

set -x HOMEBREW_BREW_GIT_REMOTE "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
set -x HOMEBREW_API_DOMAIN "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
set -x HOMEBREW_BOTTLE_DOMAIN "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"

set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
set -x JAVA_HOME /opt/homebrew/opt/openjdk@21

### Aliases ###
if type -q nvim
    alias vim nvim
end

if type -q eza
    set ls "eza --icons=always --hyperlink"
else
    set ls ls
end

if type -q bat
    alias cat 'bat --theme=GitHub'
end

# Navigation
alias ... 'cd ../..'

# Listing
alias ls "$ls"
alias lsa "$ls -a"
alias lst "$ls -T -L 1"
alias lsd "$ls -d */"
alias lls "$ls -l"

# Utils
alias j just
alias cat 'bat --theme=GitHub'
alias mv 'mv -i'
alias ta 'tmux a'
alias lzd lazydocker
alias dp 'docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
alias py python
alias use-py 'source .venv/bin/activate.fish'
alias lg lazygit
alias ghce 'gh copilot explain'
alias ghcs 'gh copilot suggest'
alias jst 'jj st'
alias jlog 'jj log'

# MacOS

alias afk "osascript -e 'tell application \"System Events\" to keystroke \"q\" using {command down, control down}'"

alias afm "osascript -e 'tell application \"System Events\" to sleep'"

alias finder='open -a Finder'

### Functions ###

function mcd
    mkdir -p "$argv[1]"
    cd "$argv[1]"
end

function cdf
    set -l initial_pwd $PWD

    set -l selected (fd --hidden --follow --exclude .git | \
        fzf --preview 'if test -d {}
                          eza --tree --color=always --git --group-directories-first --icons=always --level=1 {}
                      else
                          bat --style=numbers --theme=GitHub --color=always --line-range :200 {}
                      end' \
            --preview-window=right:50%:wrap\
            --bind 'alt-j:preview-down,alt-k:preview-up')

    if test $status -eq 0
        if test -d "$selected"
            cd "$selected"
        else
            cd (dirname "$selected")
        end
    else
        cd $initial_pwd
    end
end

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

### Interactive Shell Specific Configurations ###
if status is-interactive
    # Remove fish greeting
    set fish_greeting

    # Tool Initializations that may produce output
    starship init fish | source
    enable_transience
    zoxide init fish | source
    fzf --fish | source
    direnv hook fish | source
    atuin init fish | source
end

### Commented Out Configurations ###
# set -x http_proxy socks5://127.0.0.1:7897
# set -x https_proxy socks5://127.0.0.1:7897
# alias fd='fdfind'
# rvm default

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
