cdl() {
    # 检查参数数量
    if [ $# -gt 1 ]; then
        log "Usage: cdl [directory]" "$YELLOW"
        return 1
    fi

    # 获取目标目录，若无参数则使用 HOME
    local target="${1:-$HOME}"

    # 尝试切换目录
    if ! cd "$target" 2>/dev/null; then
        log "Error: Cannot change to directory '$target'" "$RED"
        return 1
    fi

    # 执行 ls
    ls
}
