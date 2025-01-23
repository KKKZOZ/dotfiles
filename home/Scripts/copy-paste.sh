# 颜色定义
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# 日志函数
log() {
    local msg="$1"
    local color="${2:-$BLUE}"
    printf "${color}%s${NC}\n" "$msg"
}

# 跨平台获取绝对路径
get_abs_path() {
    local path="$1"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if [[ "$path" = /* ]]; then
            echo "$path"
        else
            echo "$(cd "$(dirname "$path")" && pwd)/$(basename "$path")"
        fi
    else
        # Linux
        realpath -m "$path"
    fi
}

copy() {
    local pastebin="${HOME}/.pastebin"

    # 检查参数
    if [ $# -eq 0 ]; then
        log "Usage: copy file1 [file2 ...]" "$YELLOW"
        return 1
    fi

    # 检查源文件是否都存在
    for file in "$@"; do
        if [ ! -e "$file" ]; then
            log "Error: '$file' does not exist" "$RED"
            return 1
        fi
    done

    # 创建或清空 pastebin
    if [ -d "$pastebin" ]; then
        rm -rf "${pastebin:?}/"*
    else
        if ! mkdir -p "$pastebin"; then
            log "Error: Failed to create pastebin directory" "$RED"
            return 1
        fi
    fi

    # 复制文件到 pastebin
    if ! cp -r "$@" "$pastebin/"; then
        log "Error: Failed to copy files" "$RED"
        return 1
    fi

    # 统计复制的文件和目录数量
    local files_count=$(find "$pastebin" -type f | wc -l)
    local dirs_count=$(find "$pastebin" -type d | wc -l)
    let dirs_count--

    log "Copied $files_count files and $dirs_count directories to pastebin" "$GREEN"
}

paste() {
    local pastebin="${HOME}/.pastebin"

    # 检查 pastebin 状态
    if [ ! -d "$pastebin" ]; then
        log "Error: Pastebin directory does not exist" "$RED"
        return 1
    fi

    if [ -z "$(ls -A "$pastebin")" ]; then
        log "Error: Pastebin is empty" "$RED"
        return 1
    fi

    # 确定目标路径
    local target_path="${1:-.}"
    
    # 如果目标路径不是绝对路径，转换为绝对路径
    target_path=$(get_abs_path "$target_path")

    # 检查目标路径是否在 pastebin 内
    if [[ "$target_path" == "$pastebin"* ]]; then
        log "Error: Cannot paste into pastebin directory or its subdirectories" "$RED"
        return 1
    fi

    # 创建目标目录
    if [ ! -d "$target_path" ]; then
        if ! mkdir -p "$target_path"; then
            log "Error: Failed to create target directory" "$RED"
            return 1
        fi
    fi

    # 检查目标目录的写权限
    if [ ! -w "$target_path" ]; then
        log "Error: No write permission for target directory" "$RED"
        return 1
    fi

    # 复制文件
    if ! cp -r "$pastebin/"* "$target_path/"; then
        log "Error: Failed to paste files" "$RED"
        return 1
    fi

    # 统计粘贴的文件和目录数量
    local files_count=$(find "$pastebin" -type f | wc -l)
    local dirs_count=$(find "$pastebin" -type d | wc -l)
    let dirs_count--

    log "Pasted $files_count files and $dirs_count directories to $target_path" "$GREEN"
}
