export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

curl --proto '=https' --tlsv1.2 -sSf https://rsproxy.cn/rustup-init.sh | sh

CARGO_CONFIG_CONTENT="[source.crates-io]
replace-with = 'rsproxy-sparse'
[source.rsproxy]
registry = 'https://rsproxy.cn/crates.io-index'
[source.rsproxy-sparse]
registry = 'sparse+https://rsproxy.cn/index/'
[registries.rsproxy]
index = 'https://rsproxy.cn/crates.io-index'
[net]
git-fetch-with-cli = true"

# 检查 ~/.cargo 目录是否存在，不存在则创建
if [ ! -d "$HOME/.cargo" ]; then
    mkdir -p "$HOME/.cargo"
fi

# 将内容写入 ~/.cargo/config 中
echo "$CARGO_CONFIG_CONTENT" > "$HOME/.cargo/config"

source "$HOME/.cargo/env.fish"

cargo install eza
cargo install zoxide --locked
cargo install gping

curl -OL https://go.dev/dl/go1.23.2.linux-amd64.tar.gz

sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.23.2.linux-amd64.tar.gz

rm go1.23.2.linux-amd64.tar.gz

sudo apt-get install neovim
